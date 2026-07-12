using System;
using relay_chat.Services;

namespace relay_chat
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Mark user as offline
            int? userId = AuthService.GetCurrentUserId();
            if (userId.HasValue)
            {
                using (var userService = new UserService())
                {
                    userService.UpdateOnlineStatus(userId.Value, false);
                }
            }

            // Sign out and redirect
            AuthService.SignOut();
            Response.Redirect("~/");
        }
    }
}
