namespace relay_chat
{
    public partial class Register
    {
        protected global::System.Web.UI.WebControls.Panel ErrorPanel;
        protected global::System.Web.UI.WebControls.Literal ErrorMessage;
        protected global::System.Web.UI.WebControls.TextBox Username;
        protected global::System.Web.UI.WebControls.RequiredFieldValidator UsernameRequired;
        protected global::System.Web.UI.WebControls.RegularExpressionValidator UsernameFormat;
        protected global::System.Web.UI.WebControls.TextBox DisplayName;
        protected global::System.Web.UI.WebControls.RequiredFieldValidator DisplayNameRequired;
        protected global::System.Web.UI.WebControls.TextBox Email;
        protected global::System.Web.UI.WebControls.RequiredFieldValidator EmailRequired;
        protected global::System.Web.UI.WebControls.RegularExpressionValidator EmailFormat;
        protected global::System.Web.UI.WebControls.TextBox Password;
        protected global::System.Web.UI.WebControls.RequiredFieldValidator PasswordRequired;
        protected global::System.Web.UI.WebControls.RegularExpressionValidator PasswordStrength;
        protected global::System.Web.UI.WebControls.TextBox ConfirmPassword;
        protected global::System.Web.UI.WebControls.RequiredFieldValidator ConfirmRequired;
        protected global::System.Web.UI.WebControls.CompareValidator PasswordCompare;
        protected global::System.Web.UI.WebControls.Button RegisterButton;
    }
}
