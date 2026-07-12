using System;
using relay_chat.Services;

namespace relay_chat
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect to home if already logged in
            if (User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/");
            }
        }

        protected void RegisterButton_Click(object sender, EventArgs e)
        {
            if (!IsValid)
                return;

            using (var userService = new UserService())
            {
                string error = userService.Register(
                    Username.Text.Trim(),
                    Email.Text.Trim(),
                    Password.Text,
                    DisplayName.Text.Trim()
                );

                if (error == null)
                {
                    // Registration successful — sign in automatically
                    var user = userService.Authenticate(Username.Text.Trim(), Password.Text);
                    if (user != null)
                    {
                        AuthService.SignIn(user, rememberMe: false);
                        userService.UpdateOnlineStatus(user.Id, true);
                        Response.Redirect("~/");
                    }
                }
                else
                {
                    ErrorPanel.Visible = true;
                    ErrorMessage.Text = error;
                }
            }
        }
    }
}
