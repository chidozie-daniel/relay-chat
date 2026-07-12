using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace relay_chat.Models
{
    public class Conversation
    {
        public int Id { get; set; }

        [MaxLength(200)]
        public string Name { get; set; }

        /// <summary>
        /// 0 = OneToOne, 1 = Group
        /// </summary>
        public int Type { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // Navigation properties
        public virtual ICollection<ConversationParticipant> Participants { get; set; } = new List<ConversationParticipant>();
        public virtual ICollection<Message> Messages { get; set; } = new List<Message>();
    }
}
