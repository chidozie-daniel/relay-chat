<%@ Page Title="Create account" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="relay_chat.Register" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
  <section class="py-5 my-5">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-md-5">
          <div class="magazine-card p-4 p-md-5">
            <div class="text-center mb-4">
              <h2 class="relay-heading">Create your account</h2>
              <p class="text-muted relay-copy">Join Relay and start chatting</p>
            </div>

            <asp:Panel ID="ErrorPanel" runat="server" Visible="false" CssClass="alert alert-danger py-2 small" role="alert">
              <asp:Literal ID="ErrorMessage" runat="server" />
            </asp:Panel>

            <div class="mb-3">
              <label for="Username" class="form-label small fw-semibold text-ink-soft">Username</label>
              <asp:TextBox ID="Username" runat="server" CssClass="form-control" placeholder="Choose a username" MaxLength="50" />
              <asp:RequiredFieldValidator ID="UsernameRequired" runat="server"
                ControlToValidate="Username" CssClass="text-danger small"
                Display="Dynamic" ErrorMessage="Username is required." />
              <asp:RegularExpressionValidator ID="UsernameFormat" runat="server"
                ControlToValidate="Username" CssClass="text-danger small"
                Display="Dynamic" ValidationExpression="^[a-zA-Z0-9_]{3,50}$"
                ErrorMessage="Username must be 3-50 characters (letters, numbers, underscores)." />
            </div>

            <div class="mb-3">
              <label for="DisplayName" class="form-label small fw-semibold text-ink-soft">Display name</label>
              <asp:TextBox ID="DisplayName" runat="server" CssClass="form-control" placeholder="Your display name" MaxLength="100" />
              <asp:RequiredFieldValidator ID="DisplayNameRequired" runat="server"
                ControlToValidate="DisplayName" CssClass="text-danger small"
                Display="Dynamic" ErrorMessage="Display name is required." />
            </div>

            <div class="mb-3">
              <label for="Email" class="form-label small fw-semibold text-ink-soft">Email</label>
              <asp:TextBox ID="Email" runat="server" CssClass="form-control" placeholder="you@example.com" MaxLength="255" />
              <asp:RequiredFieldValidator ID="EmailRequired" runat="server"
                ControlToValidate="Email" CssClass="text-danger small"
                Display="Dynamic" ErrorMessage="Email is required." />
              <asp:RegularExpressionValidator ID="EmailFormat" runat="server"
                ControlToValidate="Email" CssClass="text-danger small"
                Display="Dynamic" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                ErrorMessage="Enter a valid email address." />
            </div>

            <div class="mb-3">
              <label for="Password" class="form-label small fw-semibold text-ink-soft">Password</label>
              <asp:TextBox ID="Password" runat="server" TextMode="Password" CssClass="form-control" placeholder="Create a strong password" />
              <asp:RequiredFieldValidator ID="PasswordRequired" runat="server"
                ControlToValidate="Password" CssClass="text-danger small"
                Display="Dynamic" ErrorMessage="Password is required." />
              <asp:RegularExpressionValidator ID="PasswordStrength" runat="server"
                ControlToValidate="Password" CssClass="text-danger small"
                Display="Dynamic" ValidationExpression="^.{6,}$"
                ErrorMessage="Password must be at least 6 characters." />
            </div>

            <div class="mb-4">
              <label for="ConfirmPassword" class="form-label small fw-semibold text-ink-soft">Confirm password</label>
              <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Repeat your password" />
              <asp:RequiredFieldValidator ID="ConfirmRequired" runat="server"
                ControlToValidate="ConfirmPassword" CssClass="text-danger small"
                Display="Dynamic" ErrorMessage="Please confirm your password." />
              <asp:CompareValidator ID="PasswordCompare" runat="server"
                ControlToCompare="Password" ControlToValidate="ConfirmPassword"
                CssClass="text-danger small" Display="Dynamic"
                ErrorMessage="Passwords do not match." />
            </div>

            <asp:Button ID="RegisterButton" runat="server" Text="Create account"
              CssClass="btn btn-ink w-100 py-3" OnClick="RegisterButton_Click" />

            <div class="text-center mt-4">
              <p class="small text-muted relay-copy mb-0">
                Already have an account?
                <a href="Login" class="text-accent fw-semibold text-decoration-none">Sign in</a>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</asp:Content>
