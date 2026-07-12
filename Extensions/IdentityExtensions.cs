using System.Security.Principal;
using System.Web.Security;

namespace relay_chat.Extensions
{
    public static class IdentityExtensions
    {
        /// <summary>
        /// Gets the user ID from the Forms Authentication ticket.
        /// The user ID is stored in the ticket's UserData field.
        /// </summary>
        public static string GetUserId(this IIdentity identity)
        {
            if (identity == null || !identity.IsAuthenticated)
                return null;

            var formsIdentity = identity as FormsIdentity;
            if (formsIdentity == null)
                return null;

            return formsIdentity.Ticket.UserData;
        }
    }
}
