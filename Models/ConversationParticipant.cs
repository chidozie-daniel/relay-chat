using System;

namespace relay_chat.Models
{
    public class ConversationParticipant
    {
        public int ConversationId { get; set; }

        public int UserId { get; set; }

        public DateTime JoinedAt { get; set; } = DateTime.UtcNow;

        // Navigation properties
        public virtual Conversation Conversation { get; set; }
        public virtual User User { get; set; }
    }
}
