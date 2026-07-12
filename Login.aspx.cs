using System;
using relay_chat.Services;

namespace relay_chat
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect to home if already logged in
            if (User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/");
            }
        }

        protected void LoginButton_Click(object sender, EventArgs e)
        {
            if (!IsValid)
                return;

            using (var userService = new UserService())
            {
                var user = userService.Authenticate(Username.Text.Trim(), Password.Text);

                if (user != null)
                {
                    // Sign in via Forms Authentication
                    AuthService.SignIn(user, RememberMe.Checked);

                    // Update online status
                    userService.UpdateOnlineStatus(user.Id, true);

                    // Redirect to home page or return URL (local only to prevent open redirect)
                    string returnUrl = Request.QueryString["ReturnUrl"];
                    if (!string.IsNullOrEmpty(returnUrl) && returnUrl.StartsWith("/") && !returnUrl.StartsWith("//"))
                    {
                        Response.Redirect(returnUrl);
                    }

                    Response.Redirect("~/");
                }
                else
                {
                    ErrorPanel.Visible = true;
                    ErrorMessage.Text = "Invalid username or password. Please try again.";
                }
            }
        }
    }
}
