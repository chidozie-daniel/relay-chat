using System.Data.Entity;

namespace relay_chat.Models
{
    public class RelayDbContext : DbContext
    {
        public RelayDbContext() : base("name=RelayChatDb")
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Message> Messages { get; set; }
        public DbSet<Conversation> Conversations { get; set; }
        public DbSet<ConversationParticipant> ConversationParticipants { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            // User configuration
            modelBuilder.Entity<User>()
                .Property(u => u.Username)
                .IsRequired()
                .HasMaxLength(50);

            modelBuilder.Entity<User>()
                .Property(u => u.Email)
                .IsRequired()
                .HasMaxLength(255);

            modelBuilder.Entity<User>()
                .Property(u => u.PasswordHash)
                .IsRequired()
                .HasMaxLength(255);

            modelBuilder.Entity<User>()
                .Property(u => u.DisplayName)
                .IsRequired()
                .HasMaxLength(100);

            modelBuilder.Entity<User>()
                .Property(u => u.AvatarUrl)
                .HasMaxLength(500);

            modelBuilder.Entity<User>()
                .Property(u => u.Bio)
                .HasMaxLength(500);

            modelBuilder.Entity<User>()
                .HasIndex(u => u.Username)
                .IsUnique()
                .HasName("IX_Username");

            modelBuilder.Entity<User>()
                .HasIndex(u => u.Email)
                .IsUnique()
                .HasName("IX_Email");

            // Conversation configuration
            modelBuilder.Entity<Conversation>()
                .Property(c => c.Name)
                .HasMaxLength(200);

            // ConversationParticipant configuration (composite key)
            modelBuilder.Entity<ConversationParticipant>()
                .HasKey(cp => new { cp.ConversationId, cp.UserId });

            modelBuilder.Entity<ConversationParticipant>()
                .Property(cp => cp.JoinedAt)
                .IsRequired();

            modelBuilder.Entity<ConversationParticipant>()
                .HasRequired(cp => cp.Conversation)
                .WithMany(c => c.Participants)
                .HasForeignKey(cp => cp.ConversationId)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<ConversationParticipant>()
                .HasRequired(cp => cp.User)
                .WithMany(u => u.Conversations)
                .HasForeignKey(cp => cp.UserId)
                .WillCascadeOnDelete(false);

            // Message configuration
            modelBuilder.Entity<Message>()
                .Property(m => m.Content)
                .IsRequired();

            modelBuilder.Entity<Message>()
                .HasRequired(m => m.Conversation)
                .WithMany(c => c.Messages)
                .HasForeignKey(m => m.ConversationId)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Message>()
                .HasRequired(m => m.Sender)
                .WithMany(u => u.SentMessages)
                .HasForeignKey(m => m.SenderId)
                .WillCascadeOnDelete(false);

            // Indexes for Message
            modelBuilder.Entity<Message>()
                .HasIndex(m => m.ConversationId)
                .HasName("IX_Message_ConversationId");

            modelBuilder.Entity<Message>()
                .HasIndex(m => m.SenderId)
                .HasName("IX_Message_SenderId");

            base.OnModelCreating(modelBuilder);
        }
    }
}
