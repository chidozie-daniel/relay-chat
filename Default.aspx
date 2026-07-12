<%@ Page Title="Relay - real-time messaging" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="relay_chat._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
  <section class="hero-section">
    <div class="container">
      <div class="row align-items-center g-lg-5">
        <div class="col-lg-6">
          <div class="chip-badge mb-3">
            <i class="bi bi-dot me-1"></i> real-time messaging
          </div>
          <h1 class="hero-title">
            Real-time <br /><span class="highlight">conversations.</span>
          </h1>
          <p class="hero-desc mt-3">
            Relay is a real-time messaging app. Create an account, find someone to talk to,
            and start chatting instantly &mdash; with typing indicators, online presence, and read receipts.
          </p>
          <div class="d-flex flex-wrap gap-3 mt-4">
            <a href="Register" class="btn btn-ink px-5 py-3"><i class="bi bi-arrow-right-circle me-2"></i>Start relaying</a>
            <a href="Login" class="btn btn-outline-ink px-5 py-3"><i class="bi bi-chat-dots me-2"></i>Go to your chats</a>
          </div>
          <div class="mt-5 d-flex flex-wrap align-items-center gap-4 text-muted small">
            <span><i class="bi bi-lightning-fill text-accent me-1"></i> Live via WebSockets</span>
            <span><i class="bi bi-pencil text-accent me-1"></i> Typing indicators</span>
            <span><i class="bi bi-check2-all text-accent me-1"></i> Read receipts</span>
          </div>
        </div>
        <div class="col-lg-6">
          <div class="mockup-slim ms-auto">
            <div class="inner">
              <div class="d-flex align-items-center gap-2 mb-3">
                <div class="chat-avatar chat-avatar-muted">R</div>
                <span class="fw-bold relay-heading">Relay</span>
                <span class="ms-auto text-muted small"><i class="bi bi-dot"></i> online</span>
              </div>
              <div class="d-flex flex-column gap-2">
                <div class="chat-bubble">Any thoughts on the draft?</div>
                <div class="chat-bubble self">Just pushed revisions - clean &amp; sharp.</div>
                <div class="chat-bubble chat-bubble-narrow">Let's review together</div>
                <div class="chat-bubble self chat-bubble-narrow">Relay call in 5 min</div>
                <div class="mockup-input mt-3">
                  <span class="mockup-input-text">Type a message...</span>
                  <span class="mockup-send-btn"><i class="bi bi-send-fill"></i></span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="py-5" id="features" style="border-top: 1px solid var(--border-light);">
    <div class="container">
      <div class="row mb-4">
        <div class="col-lg-8">
          <span class="chip-badge mb-2"><i class="bi bi-grid-3x3-gap-fill me-1"></i> Features</span>
          <h2 class="display-3 relay-heading fw-bold">Built for <span class="text-accent">real-time</span></h2>
          <p class="text-muted relay-copy" style="font-size: 1.15rem;">Everything you need for live conversation, built right in.</p>
        </div>
      </div>
      <div class="row g-4">
        <div class="col-md-4">
          <div class="magazine-card h-100">
            <span class="card-number">01</span>
            <div class="feature-icon mb-3"><i class="bi bi-pencil"></i></div>
            <h4 class="relay-heading">Typing indicators</h4>
            <p class="text-muted small relay-copy">See when someone is composing a reply &mdash; no more wondering if they saw your message.</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="magazine-card h-100">
            <span class="card-number">02</span>
            <div class="feature-icon mb-3"><i class="bi bi-circle-fill" style="color: #22c55e;"></i></div>
            <h4 class="relay-heading">Online presence</h4>
            <p class="text-muted small relay-copy">Green dots show who's available and ready to talk, right in your conversation list.</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="magazine-card h-100">
            <span class="card-number">03</span>
            <div class="feature-icon mb-3"><i class="bi bi-search"></i></div>
            <h4 class="relay-heading">User search</h4>
            <p class="text-muted small relay-copy">Find anyone by username or display name and start a conversation instantly.</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="magazine-card h-100">
            <span class="card-number">04</span>
            <div class="feature-icon mb-3"><i class="bi bi-check2-all"></i></div>
            <h4 class="relay-heading">Read receipts</h4>
            <p class="text-muted small relay-copy">Single check means delivered, double check means read &mdash; always know the status.</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="magazine-card h-100">
            <span class="card-number">05</span>
            <div class="feature-icon mb-3"><i class="bi bi-lightning-fill"></i></div>
            <h4 class="relay-heading">WebSocket delivery</h4>
            <p class="text-muted small relay-copy">Messages arrive instantly via SignalR WebSockets &mdash; no page refresh, no polling.</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="magazine-card h-100">
            <span class="card-number">06</span>
            <div class="feature-icon mb-3"><i class="bi bi-chat-dots"></i></div>
            <h4 class="relay-heading">Private conversations</h4>
            <p class="text-muted small relay-copy">One-on-one chats created in one click. Search for someone and start talking.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="py-5" id="how-it-works" style="border-top: 1px solid var(--border-light);">
    <div class="container">
      <div class="row mb-4">
        <div class="col-lg-8">
          <span class="chip-badge mb-2"><i class="bi bi-arrow-right-circle me-1"></i> how it works</span>
          <h2 class="display-4 relay-heading">Start chatting in <span class="text-accent">3 steps</span></h2>
          <p class="text-muted relay-copy">From sign-up to first message in under a minute.</p>
        </div>
      </div>
      <div class="row g-4 justify-content-center">
        <div class="col-md-4">
          <div class="magazine-card h-100">
            <span class="card-number">01</span>
            <div class="feature-icon mb-3"><i class="bi bi-person-plus"></i></div>
            <h4 class="relay-heading">Create your account</h4>
            <p class="text-muted small relay-copy mb-0">Sign up with a username and password in seconds. No email verification, no waiting.</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="magazine-card h-100">
            <span class="card-number">02</span>
            <div class="feature-icon mb-3"><i class="bi bi-search"></i></div>
            <h4 class="relay-heading">Find someone</h4>
            <p class="text-muted small relay-copy mb-0">Search by username or display name to find people and start a conversation with one click.</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="magazine-card h-100">
            <span class="card-number">03</span>
            <div class="feature-icon mb-3"><i class="bi bi-chat-dots-fill"></i></div>
            <h4 class="relay-heading">Start relaying</h4>
            <p class="text-muted small relay-copy mb-0">Send live messages with typing indicators, read receipts, and instant delivery via WebSockets.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="py-5 text-center cta-section" style="border-top: 1px solid var(--border-light); background: var(--milk-light);">
    <div class="container">
      <div class="py-4">
        <h2 class="display-3 relay-heading fw-bold">Start <span class="text-accent">relaying</span></h2>
        <p class="text-muted mb-4 mx-auto relay-copy" style="max-width: 480px; font-size: 1.15rem;">Create an account and start chatting in seconds &mdash; no setup required.</p>
        <div class="d-flex flex-wrap justify-content-center gap-3">
          <a href="Register" class="btn btn-ink px-5 py-3"><i class="bi bi-chat-dots-fill me-2"></i>Join the conversation</a>
          <a href="Login" class="btn btn-outline-ink px-5 py-3"><i class="bi bi-arrow-right-circle me-2"></i>Continue chatting</a>
        </div>
        <p class="mt-3 small text-muted relay-copy">Start chatting in seconds &mdash; it's free</p>
      </div>
    </div>
  </section>
</asp:Content>
