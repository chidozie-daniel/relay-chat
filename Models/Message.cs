using System;
using System.ComponentModel.DataAnnotations;

namespace relay_chat.Models
{
    public class Message
    {
        public int Id { get; set; }

        public int ConversationId { get; set; }

        public int SenderId { get; set; }

        [Required]
        public string Content { get; set; }

        public DateTime SentAt { get; set; } = DateTime.UtcNow;

        public bool IsRead { get; set; }

        // Navigation properties
        public virtual Conversation Conversation { get; set; }
        public virtual User Sender { get; set; }
    }
}
