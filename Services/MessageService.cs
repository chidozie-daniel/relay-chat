using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using relay_chat.Models;

namespace relay_chat.Services
{
    public class MessageService : IDisposable
    {
        private readonly RelayDbContext _context;

        public MessageService()
        {
            _context = new RelayDbContext();
        }

        /// <summary>
        /// Saves a new message to the database and returns it.
        /// Returns null if the sender is not a participant in the conversation.
        /// </summary>
        public Message SaveMessage(int conversationId, int senderId, string content)
        {
            // Verify sender is a participant
            bool isParticipant = _context.ConversationParticipants
                .Any(cp => cp.ConversationId == conversationId && cp.UserId == senderId);

            if (!isParticipant)
                return null;

            var message = new Message
            {
                ConversationId = conversationId,
                SenderId = senderId,
                Content = content,
                SentAt = DateTime.UtcNow,
                IsRead = false
            };

            _context.Messages.Add(message);
            _context.SaveChanges();

            return message;
        }

        /// <summary>
        /// Gets messages for a conversation with pagination (oldest first).
        /// </summary>
        public List<Message> GetMessages(int conversationId, int page = 1, int pageSize = 50)
        {
            return _context.Messages
                .Where(m => m.ConversationId == conversationId)
                .OrderByDescending(m => m.SentAt)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .OrderBy(m => m.SentAt)
                .Include(m => m.Sender)
                .ToList();
        }

        /// <summary>
        /// Marks a message as read if the user is a participant in the conversation.
        /// </summary>
        public void MarkAsRead(int messageId, int userId)
        {
            var message = _context.Messages.Find(messageId);
            if (message == null)
                return;

            // Only the recipient can mark as read (not the sender)
            if (message.SenderId == userId)
                return;

            // Verify user is a participant in this conversation
            bool isParticipant = _context.ConversationParticipants
                .Any(cp => cp.ConversationId == message.ConversationId && cp.UserId == userId);

            if (!isParticipant)
                return;

            message.IsRead = true;
            _context.SaveChanges();
        }

        /// <summary>
        /// Creates a new 1-on-1 conversation between two users, or returns existing one.
        /// </summary>
        public Conversation GetOrCreateOneOnOneConversation(int userId1, int userId2)
        {
            // Look for existing 1-on-1 conversation between these users
            var existing = (from cp1 in _context.ConversationParticipants
                           join cp2 in _context.ConversationParticipants
                           on cp1.ConversationId equals cp2.ConversationId
                           where cp1.UserId == userId1 && cp2.UserId == userId2
                              && cp1.Conversation.Type == 0 // OneToOne
                           select cp1.Conversation)
                           .FirstOrDefault();

            if (existing != null)
                return existing;

            // Create new conversation
            var conversation = new Conversation
            {
                Type = 0, // OneToOne
                CreatedAt = DateTime.UtcNow
            };

            _context.Conversations.Add(conversation);
            _context.SaveChanges();

            // Add both participants
            _context.ConversationParticipants.Add(new ConversationParticipant
            {
                ConversationId = conversation.Id,
                UserId = userId1,
                JoinedAt = DateTime.UtcNow
            });
            _context.ConversationParticipants.Add(new ConversationParticipant
            {
                ConversationId = conversation.Id,
                UserId = userId2,
                JoinedAt = DateTime.UtcNow
            });

            _context.SaveChanges();

            return conversation;
        }

        /// <summary>
        /// Gets all conversations for a user with the last message preview.
        /// </summary>
        public List<dynamic> GetUserConversations(int userId)
        {
            var conversations = _context.ConversationParticipants
                .Where(cp => cp.UserId == userId)
                .Select(cp => cp.Conversation)
                .Include(c => c.Participants.Select(p => p.User))
                .Include(c => c.Messages)
                .ToList();

            var result = new List<dynamic>();

            foreach (var conv in conversations)
            {
                var lastMessage = conv.Messages
                    .OrderByDescending(m => m.SentAt)
                    .FirstOrDefault();

                var otherParticipants = conv.Participants
                    .Where(p => p.UserId != userId)
                    .Select(p => new
                    {
                        p.User.Id,
                        p.User.Username,
                        p.User.DisplayName,
                        p.User.IsOnline,
                        p.User.AvatarUrl
                    })
                    .ToList();

                result.Add(new
                {
                    id = conv.Id,
                    name = conv.Name,
                    type = conv.Type,
                    createdAt = conv.CreatedAt,
                    otherParticipants,
                    lastMessage = lastMessage == null ? null : new
                    {
                        id = lastMessage.Id,
                        content = lastMessage.Content,
                        senderId = lastMessage.SenderId,
                        sentAt = lastMessage.SentAt,
                        isRead = lastMessage.IsRead
                    },
                    unreadCount = conv.Messages.Count(m => !m.IsRead && m.SenderId != userId)
                });
            }

            return result.OrderByDescending(c => c.lastMessage?.sentAt ?? c.createdAt).ToList();
        }

        public void Dispose()
        {
            _context?.Dispose();
        }
    }
}
