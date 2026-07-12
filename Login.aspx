<%@ Page Title="Log in" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="relay_chat.Login" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
  <section class="py-5 my-5">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-md-5">
          <div class="magazine-card p-4 p-md-5">
            <div class="text-center mb-4">
              <h2 class="relay-heading">Welcome back</h2>
              <p class="text-muted relay-copy">Sign in to your Relay account</p>
            </div>

            <asp:Panel ID="ErrorPanel" runat="server" Visible="false" CssClass="alert alert-danger py-2 small" role="alert">
              <asp:Literal ID="ErrorMessage" runat="server" />
            </asp:Panel>

            <div class="mb-3">
              <label for="Username" class="form-label small fw-semibold text-ink-soft">Username</label>
              <asp:TextBox ID="Username" runat="server" CssClass="form-control" placeholder="Enter your username" />
              <asp:RequiredFieldValidator ID="UsernameRequired" runat="server"
                ControlToValidate="Username" CssClass="text-danger small"
                Display="Dynamic" ErrorMessage="Username is required." />
            </div>

            <div class="mb-4">
              <label for="Password" class="form-label small fw-semibold text-ink-soft">Password</label>
              <asp:TextBox ID="Password" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your password" />
              <asp:RequiredFieldValidator ID="PasswordRequired" runat="server"
                ControlToValidate="Password" CssClass="text-danger small"
                Display="Dynamic" ErrorMessage="Password is required." />
            </div>

            <div class="mb-4 form-check">
              <asp:CheckBox ID="RememberMe" runat="server" CssClass="form-check-input" />
              <label for="RememberMe" class="form-check-label small text-ink-soft">Remember me</label>
            </div>

            <asp:Button ID="LoginButton" runat="server" Text="Sign in"
              CssClass="btn btn-ink w-100 py-3" OnClick="LoginButton_Click" />

            <div class="text-center mt-4">
              <p class="small text-muted relay-copy mb-0">
                Don't have an account?
                <a href="Register" class="text-accent fw-semibold text-decoration-none">Create one</a>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</asp:Content>
