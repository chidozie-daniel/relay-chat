using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace relay_chat.Models
{
    public class User
    {
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string Username { get; set; }

        [Required]
        [MaxLength(255)]
        public string Email { get; set; }

        [Required]
        [MaxLength(255)]
        public string PasswordHash { get; set; }

        [Required]
        [MaxLength(100)]
        public string DisplayName { get; set; }

        [MaxLength(500)]
        public string AvatarUrl { get; set; }

        [MaxLength(500)]
        public string Bio { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public DateTime? LastActiveAt { get; set; }

        public bool IsOnline { get; set; }

        // Navigation properties
        public virtual ICollection<Message> SentMessages { get; set; } = new List<Message>();
        public virtual ICollection<ConversationParticipant> Conversations { get; set; } = new List<ConversationParticipant>();
    }
}
