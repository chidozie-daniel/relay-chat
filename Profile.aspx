<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="relay_chat.Profile" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
  <section class="py-5 my-5">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-md-6">

          <!-- Avatar + name header -->
          <div class="text-center mb-4">
            <div class="profile-avatar mx-auto mb-3">
              <asp:Image ID="AvatarImage" runat="server" CssClass="profile-avatar-img" Visible="false" />
              <span id="AvatarInitials" runat="server" class="profile-avatar-initials"></span>
            </div>
            <h2 class="relay-heading mb-0"><asp:Literal ID="DisplayNameHeader" runat="server" /></h2>
            <p class="text-muted relay-copy small">@<asp:Literal ID="UsernameHeader" runat="server" /></p>
          </div>

          <div class="magazine-card p-4 p-md-5">

            <asp:Panel ID="SuccessPanel" runat="server" Visible="false" CssClass="alert alert-success py-2 small mb-4" role="alert">
              Profile updated successfully.
            </asp:Panel>

            <asp:Panel ID="ErrorPanel" runat="server" Visible="false" CssClass="alert alert-danger py-2 small mb-4" role="alert">
              <asp:Literal ID="ErrorMessage" runat="server" />
            </asp:Panel>

            <h5 class="relay-heading mb-4">Edit profile</h5>

            <div class="mb-3">
              <label class="form-label small fw-semibold text-ink-soft">Username</label>
              <asp:TextBox ID="UsernameField" runat="server" CssClass="form-control" Enabled="false" />
              <div class="form-text text-muted relay-copy">Username cannot be changed.</div>
            </div>

            <div class="mb-3">
              <label for="DisplayName" class="form-label small fw-semibold text-ink-soft">Display name</label>
              <asp:TextBox ID="DisplayName" runat="server" CssClass="form-control" placeholder="Your display name" MaxLength="100" />
              <asp:RequiredFieldValidator ID="DisplayNameRequired" runat="server"
                ControlToValidate="DisplayName" CssClass="text-danger small"
                Display="Dynamic" ErrorMessage="Display name is required." />
            </div>

            <div class="mb-3">
              <label for="Bio" class="form-label small fw-semibold text-ink-soft">Bio</label>
              <asp:TextBox ID="Bio" runat="server" TextMode="MultiLine" Rows="3"
                CssClass="form-control" placeholder="Tell people a bit about yourself..." MaxLength="500" />
              <div class="form-text text-muted relay-copy">Max 500 characters.</div>
            </div>

            <div class="mb-4">
              <label for="AvatarUrl" class="form-label small fw-semibold text-ink-soft">Avatar URL</label>
              <asp:TextBox ID="AvatarUrl" runat="server" CssClass="form-control" placeholder="https://example.com/avatar.jpg" MaxLength="500" />
              <asp:RegularExpressionValidator ID="AvatarUrlFormat" runat="server"
                ControlToValidate="AvatarUrl" CssClass="text-danger small"
                Display="Dynamic" ValidationExpression="^(https?://.*)?$"
                ErrorMessage="Enter a valid URL (must start with http:// or https://)." />
              <div class="form-text text-muted relay-copy">Link to a profile picture.</div>
            </div>

            <asp:Button ID="SaveButton" runat="server" Text="Save changes"
              CssClass="btn btn-ink w-100 py-3" OnClick="SaveButton_Click" />

          </div>

          <!-- Account info -->
          <div class="magazine-card p-4 mt-4">
            <h5 class="relay-heading mb-3">Account</h5>
            <div class="d-flex justify-content-between align-items-center py-2" style="border-bottom: 1px solid var(--border-light);">
              <span class="small text-ink-soft relay-copy">Email</span>
              <span class="small fw-semibold"><asp:Literal ID="EmailDisplay" runat="server" /></span>
            </div>
            <div class="d-flex justify-content-between align-items-center py-2">
              <span class="small text-ink-soft relay-copy">Member since</span>
              <span class="small fw-semibold"><asp:Literal ID="MemberSince" runat="server" /></span>
            </div>
          </div>

        </div>
      </div>
    </div>
  </section>

  <style>
    .profile-avatar {
      width: 88px;
      height: 88px;
      border-radius: 50%;
      background: var(--milk-warm);
      border: 2px solid var(--border-light);
      display: flex;
      align-items: center;
      justify-content: center;
      overflow: hidden;
    }
    .profile-avatar-img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    .profile-avatar-initials {
      font-family: 'Sora', sans-serif;
      font-weight: 700;
      font-size: 2rem;
      color: var(--ink-soft);
    }
  </style>
</asp:Content>
