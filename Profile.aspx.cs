using System;
using relay_chat.Services;

namespace relay_chat
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int? userId = AuthService.GetCurrentUserId();
            if (!userId.HasValue)
            {
                Response.Redirect("~/Login");
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile(userId.Value);
            }
        }

        private void LoadProfile(int userId)
        {
            using (var userService = new UserService())
            {
                var user = userService.GetById(userId);
                if (user == null)
                {
                    Response.Redirect("~/");
                    return;
                }

                // Header
                DisplayNameHeader.Text = System.Web.HttpUtility.HtmlEncode(user.DisplayName);
                UsernameHeader.Text = System.Web.HttpUtility.HtmlEncode(user.Username);

                if (!string.IsNullOrEmpty(user.AvatarUrl))
                {
                    AvatarImage.ImageUrl = user.AvatarUrl;
                    AvatarImage.AlternateText = user.DisplayName;
                    AvatarImage.Visible = true;
                    AvatarInitials.Visible = false;
                }
                else
                {
                    AvatarInitials.InnerText = user.DisplayName.Length > 0
                        ? user.DisplayName[0].ToString().ToUpper() : "?";
                    AvatarInitials.Visible = true;
                    AvatarImage.Visible = false;
                }

                // Form fields
                UsernameField.Text = user.Username;
                DisplayName.Text = user.DisplayName;
                Bio.Text = user.Bio ?? "";
                AvatarUrl.Text = user.AvatarUrl ?? "";

                // Account info
                EmailDisplay.Text = System.Web.HttpUtility.HtmlEncode(user.Email);
                MemberSince.Text = user.CreatedAt.ToLocalTime().ToString("MMMM d, yyyy");
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (!IsValid) return;

            int? userId = AuthService.GetCurrentUserId();
            if (!userId.HasValue)
            {
                Response.Redirect("~/Login");
                return;
            }

            string avatarUrl = AvatarUrl.Text.Trim();
            if (!string.IsNullOrEmpty(avatarUrl) &&
                !avatarUrl.StartsWith("http://") && !avatarUrl.StartsWith("https://"))
            {
                ErrorPanel.Visible = true;
                ErrorMessage.Text = "Avatar URL must start with http:// or https://.";
                return;
            }

            using (var userService = new UserService())
            {
                userService.UpdateProfile(
                    userId.Value,
                    DisplayName.Text.Trim(),
                    Bio.Text.Trim(),
                    string.IsNullOrEmpty(avatarUrl) ? null : avatarUrl
                );
            }

            SuccessPanel.Visible = true;
            ErrorPanel.Visible = false;

            // Refresh header to reflect new values
            LoadProfile(userId.Value);
        }
    }
}
