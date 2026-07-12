using System;
using System.Security.Cryptography;
using System.Web.Security;
using relay_chat.Models;

namespace relay_chat.Services
{
    public class AuthService
    {
        private const int SaltSize = 16;     // 128 bits
        private const int HashSize = 32;     // 256 bits
        private const int Iterations = 100000;

        /// <summary>
        /// Hashes a password using PBKDF2 with a random salt.
        /// Returns the salt and hash combined as a single string.
        /// </summary>
        public static string HashPassword(string password)
        {
            byte[] salt = new byte[SaltSize];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(salt);
            }

            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations, HashAlgorithmName.SHA256))
            {
                byte[] hash = pbkdf2.GetBytes(HashSize);
                return $"{Convert.ToBase64String(salt)}.{Convert.ToBase64String(hash)}";
            }
        }

        /// <summary>
        /// Verifies a password against a stored hash.
        /// </summary>
        public static bool VerifyPassword(string password, string hashedPassword)
        {
            var parts = hashedPassword.Split('.');
            if (parts.Length != 2)
                return false;

            byte[] salt = Convert.FromBase64String(parts[0]);
            byte[] storedHash = Convert.FromBase64String(parts[1]);

            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations, HashAlgorithmName.SHA256))
            {
                byte[] computedHash = pbkdf2.GetBytes(HashSize);
                return ConstantTimeEquals(storedHash, computedHash);
            }
        }

        /// <summary>
        /// Constant-time comparison to prevent timing attacks.
        /// </summary>
        private static bool ConstantTimeEquals(byte[] a, byte[] b)
        {
            if (a.Length != b.Length)
                return false;

            int result = 0;
            for (int i = 0; i < a.Length; i++)
                result |= a[i] ^ b[i];

            return result == 0;
        }

        /// <summary>
        /// Creates a Forms Authentication ticket for the given user and sets the auth cookie.
        /// </summary>
        public static void SignIn(User user, bool rememberMe = false)
        {
            var ticket = new FormsAuthenticationTicket(
                version: 1,
                name: user.Username,
                issueDate: DateTime.UtcNow,
                expiration: DateTime.UtcNow.AddDays(rememberMe ? 14 : 1),
                isPersistent: rememberMe,
                userData: user.Id.ToString(),
                cookiePath: FormsAuthentication.FormsCookiePath
            );

            string encryptedTicket = FormsAuthentication.Encrypt(ticket);
            var cookie = new System.Web.HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket)
            {
                HttpOnly = true,
                Secure = false, // Set to true in production with HTTPS
                SameSite = System.Web.SameSiteMode.Lax,
                Expires = ticket.Expiration
            };

            System.Web.HttpContext.Current.Response.Cookies.Set(cookie);
        }

        /// <summary>
        /// Signs the user out and clears the auth cookie.
        /// </summary>
        public static void SignOut()
        {
            FormsAuthentication.SignOut();
        }

        /// <summary>
        /// Gets the currently logged-in user's ID from the Forms Authentication ticket.
        /// Returns null if not authenticated.
        /// </summary>
        public static int? GetCurrentUserId()
        {
            var context = System.Web.HttpContext.Current;
            if (context?.User?.Identity?.IsAuthenticated != true)
                return null;

            var identity = (FormsIdentity)context.User.Identity;
            if (int.TryParse(identity.Ticket.UserData, out int userId))
                return userId;

            return null;
        }
    }
}
