using System;
using System.Threading.Tasks;
using Microsoft.AspNet.SignalR;
using relay_chat.Extensions;
using relay_chat.Services;

namespace relay_chat.Hubs
{
    [Authorize]
    public class ChatHub : Hub
    {
        private readonly MessageService _messageService = new MessageService();

        /// <summary>
        /// Called when a client connects. Adds them to their personal group and marks them online.
        /// </summary>
        public override Task OnConnected()
        {
            string username = Context.User.Identity.Name;
            string userId = Context.User.Identity.GetUserId();

            // Add to personal group for 1-on-1 notifications
            Groups.Add(Context.ConnectionId, $"user_{userId}");

            // Update online status in database
            if (int.TryParse(userId, out int uid))
            {
                using (var userService = new UserService())
                {
                    userService.UpdateOnlineStatus(uid, true);
                }
            }

            // Broadcast online status to other users
            Clients.Others.UserOnline(userId, username);

            return base.OnConnected();
        }

        /// <summary>
        /// Called when a client disconnects. Marks them offline.
        /// </summary>
        public override Task OnDisconnected(bool stopCalled)
        {
            string userId = Context.User.Identity.GetUserId();

            // Update online status in DB
            if (int.TryParse(userId, out int uid))
            {
                using (var userService = new UserService())
                {
                    userService.UpdateOnlineStatus(uid, false);
                }
            }

            // Broadcast offline status
            Clients.Others.UserOffline(userId);

            return base.OnDisconnected(stopCalled);
        }

        /// <summary>
        /// Sends a message to a specific conversation. All participants receive it in real-time.
        /// </summary>
        public void SendMessage(int conversationId, string content)
        {
            string userId = Context.User.Identity.GetUserId();
            string username = Context.User.Identity.Name;

            if (string.IsNullOrWhiteSpace(content))
                return;

            if (!int.TryParse(userId, out int senderId))
                return;

            // Save to database
            var message = _messageService.SaveMessage(conversationId, senderId, content);
            if (message == null)
                return;

            // Broadcast to all participants in the conversation group
            Clients.Group($"conversation_{conversationId}").NewMessage(new
            {
                id = message.Id,
                conversationId = message.ConversationId,
                senderId = message.SenderId,
                senderUsername = username,
                content = message.Content,
                sentAt = message.SentAt.ToString("yyyy-MM-ddTHH:mm:ssZ"),
                isRead = message.IsRead
            });
        }

        /// <summary>
        /// Joins a conversation's SignalR group to receive real-time messages.
        /// </summary>
        public void JoinConversation(int conversationId)
        {
            Groups.Add(Context.ConnectionId, $"conversation_{conversationId}");
        }

        /// <summary>
        /// Leaves a conversation's SignalR group.
        /// </summary>
        public void LeaveConversation(int conversationId)
        {
            Groups.Remove(Context.ConnectionId, $"conversation_{conversationId}");
        }

        /// <summary>
        /// Sends a typing indicator to a conversation.
        /// </summary>
        public void Typing(int conversationId, bool isTyping)
        {
            string userId = Context.User.Identity.GetUserId();
            string username = Context.User.Identity.Name;

            Clients.Group($"conversation_{conversationId}").UserTyping(new
            {
                conversationId,
                userId,
                username,
                isTyping
            });
        }

        /// <summary>
        /// Marks a message as read.
        /// </summary>
        public void MarkAsRead(int messageId, int conversationId)
        {
            string userId = Context.User.Identity.GetUserId();

            if (!int.TryParse(userId, out int uid))
                return;

            _messageService.MarkAsRead(messageId, uid);

            Clients.Group($"conversation_{conversationId}").MessageRead(new
            {
                messageId,
                conversationId,
                readByUserId = userId
            });
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                _messageService?.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
