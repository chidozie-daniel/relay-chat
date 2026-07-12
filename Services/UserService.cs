using System;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using relay_chat.Models;

namespace relay_chat.Services
{
    public class UserService : IDisposable
    {
        private readonly RelayDbContext _context;

        public UserService()
        {
            _context = new RelayDbContext();
        }

        /// <summary>
        /// Registers a new user. Returns null if successful, or an error message if the username/email is taken.
        /// </summary>
        public string Register(string username, string email, string password, string displayName)
        {
            // Check for existing username
            if (_context.Users.Any(u => u.Username == username))
                return "Username is already taken.";

            // Check for existing email
            if (_context.Users.Any(u => u.Email == email))
                return "An account with this email already exists.";

            var user = new User
            {
                Username = username,
                Email = email,
                PasswordHash = AuthService.HashPassword(password),
                DisplayName = string.IsNullOrWhiteSpace(displayName) ? username : displayName,
                CreatedAt = DateTime.UtcNow,
                IsOnline = false
            };

            _context.Users.Add(user);
            _context.SaveChanges();

            return null; // null means success
        }

        /// <summary>
        /// Authenticates a user by username and password.
        /// Returns the user if successful, null if credentials are invalid.
        /// </summary>
        public User Authenticate(string username, string password)
        {
            var user = _context.Users.FirstOrDefault(u => u.Username == username);
            if (user == null)
                return null;

            if (!AuthService.VerifyPassword(password, user.PasswordHash))
                return null;

            return user;
        }

        /// <summary>
        /// Gets a user by their ID.
        /// </summary>
        public User GetById(int userId)
        {
            return _context.Users.Find(userId);
        }

        /// <summary>
        /// Gets a user by their username.
        /// </summary>
        public User GetByUsername(string username)
        {
            return _context.Users.FirstOrDefault(u => u.Username == username);
        }

        /// <summary>
        /// Searches for users by username or display name.
        /// </summary>
        public IQueryable<User> Search(string query)
        {
            if (string.IsNullOrWhiteSpace(query))
                return Enumerable.Empty<User>().AsQueryable();

            return _context.Users
                .Where(u => u.Username.Contains(query) || u.DisplayName.Contains(query))
                .Take(20);
        }

        /// <summary>
        /// Updates the user's online status.
        /// </summary>
        public void UpdateOnlineStatus(int userId, bool isOnline)
        {
            var user = _context.Users.Find(userId);
            if (user != null)
            {
                user.IsOnline = isOnline;
                user.LastActiveAt = DateTime.UtcNow;
                _context.SaveChanges();
            }
        }

        /// <summary>
        /// Updates the user's profile information.
        /// </summary>
        public void UpdateProfile(int userId, string displayName, string bio, string avatarUrl)
        {
            var user = _context.Users.Find(userId);
            if (user != null)
            {
                if (!string.IsNullOrWhiteSpace(displayName))
                    user.DisplayName = displayName;
                if (bio != null)
                    user.Bio = bio;
                if (avatarUrl != null)
                    user.AvatarUrl = avatarUrl;

                _context.SaveChanges();
            }
        }

        public void Dispose()
        {
            _context?.Dispose();
        }
    }
}
