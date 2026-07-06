<%@ Page Title="Relay - intelligent chat" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="relay_chat._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
  <section class="hero-section">
    <div class="container">
      <div class="row align-items-center g-5">
        <div class="col-lg-6">
          <div class="chip-badge mb-3">
            <i class="bi bi-dot me-1"></i> v3.0 - real-time
          </div>
          <h1 class="hero-title">
            Conversations <br /><span class="highlight">with clarity.</span>
          </h1>
          <p class="hero-desc mt-3">
            Relay is the intelligent chat for teams, thinkers, and creators.
            Minimal, secure, and built for focus.
          </p>
          <div class="d-flex flex-wrap gap-3 mt-4">
            <a href="#" class="btn btn-ink px-5 py-3"><i class="bi bi-arrow-right-circle me-2"></i>Start relaying</a>
            <a href="#" class="btn btn-outline-ink px-5 py-3"><i class="bi bi-play-circle me-2"></i>See it live</a>
          </div>
          <div class="mt-5 d-flex flex-wrap align-items-center gap-4 text-muted small">
            <span><i class="bi bi-check-circle-fill text-accent me-1"></i> 256-bit encryption</span>
            <span><i class="bi bi-clock-fill text-accent me-1"></i> 99.9% uptime</span>
          </div>
        </div>
        <div class="col-lg-6">
          <div class="mockup-slim mx-auto">
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
                <div class="mt-3 d-flex gap-1">
                  <span class="badge bg-milk-warm text-ink border border-milk px-3 py-2 rounded-pill relay-heading"><i class="bi bi-mic me-1"></i>voice</span>
                  <span class="badge bg-milk-warm text-ink border border-milk px-3 py-2 rounded-pill relay-heading"><i class="bi bi-camera-video me-1"></i>video</span>
                  <span class="badge bg-ink text-white px-4 py-2 rounded-pill ms-auto relay-heading"><i class="bi bi-send"></i></span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="py-5" id="features">
    <div class="container">
      <div class="row mb-4">
        <div class="col-lg-8">
          <span class="chip-badge mb-2"><i class="bi bi-grid-3x3-gap-fill me-1"></i> core</span>
          <h2 class="display-4 relay-heading">Designed for <span class="text-accent">depth</span></h2>
          <p class="text-muted relay-copy">Every detail refined for thoughtful communication.</p>
        </div>
      </div>
      <div class="row g-4">
        <div class="col-md-4">
          <div class="magazine-card h-100">
            <div class="feature-icon mb-3"><i class="bi bi-chat-dots"></i></div>
            <h4 class="relay-heading">Threads &amp; replies</h4>
            <p class="text-muted small relay-copy">Keep conversations structured with nested replies and smart mentions.</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="magazine-card h-100">
            <div class="feature-icon mb-3"><i class="bi bi-shield-check"></i></div>
            <h4 class="relay-heading">End-to-end encrypted</h4>
            <p class="text-muted small relay-copy">Messages are private by default. Modern E2EE with zero compromise.</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="magazine-card h-100">
            <div class="feature-icon mb-3"><i class="bi bi-palette"></i></div>
            <h4 class="relay-heading">Quiet design</h4>
            <p class="text-muted small relay-copy">Light, warm, and distraction-free. Choose your reading mode.</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="magazine-card h-100">
            <div class="feature-icon mb-3"><i class="bi bi-file-earmark-code"></i></div>
            <h4 class="relay-heading">Developer API</h4>
            <p class="text-muted small relay-copy">Extend with WebSocket &amp; REST APIs. Build your own integrations.</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="magazine-card h-100">
            <div class="feature-icon mb-3"><i class="bi bi-people"></i></div>
            <h4 class="relay-heading">Group calls</h4>
            <p class="text-muted small relay-copy">HD voice &amp; video for up to 50 participants. Crisp and clear.</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="magazine-card h-100">
            <div class="feature-icon mb-3"><i class="bi bi-cloud-check"></i></div>
            <h4 class="relay-heading">Sync across devices</h4>
            <p class="text-muted small relay-copy">Continuity across web, desktop, and mobile.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="py-5">
    <div class="container">
      <div class="row mb-4">
        <div class="col-lg-8">
          <span class="chip-badge"><i class="bi bi-quote me-1"></i> voices</span>
          <h2 class="display-4 relay-heading">What <span class="text-accent">readers</span> say</h2>
        </div>
      </div>
      <div class="row g-4">
        <div class="col-md-4">
          <div class="testimonial-card">
            <div class="d-flex gap-2 align-items-center mb-3">
              <div class="chat-avatar chat-avatar-muted">JD</div>
              <div><strong class="relay-heading">Jessie D.</strong><br /><span class="text-muted small relay-copy">CTO, Layer5</span></div>
            </div>
            <p class="testimonial-text mb-0">"Relay replaced three tools for us. The UI is smooth and the encryption is top-notch."</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="testimonial-card">
            <div class="d-flex gap-2 align-items-center mb-3">
              <div class="chat-avatar chat-avatar-muted">MR</div>
              <div><strong class="relay-heading">Marcus R.</strong><br /><span class="text-muted small relay-copy">Product @ Orbit</span></div>
            </div>
            <p class="testimonial-text mb-0">"The best chat experience on the web. I love how light and fast it feels, even on mobile."</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="testimonial-card">
            <div class="d-flex gap-2 align-items-center mb-3">
              <div class="chat-avatar chat-avatar-muted">AL</div>
              <div><strong class="relay-heading">Aiko L.</strong><br /><span class="text-muted small relay-copy">Design lead</span></div>
            </div>
            <p class="testimonial-text mb-0">"Relay's design system is a dream. It's the first chat app that feels like a native experience."</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="py-5 my-3">
    <div class="container">
      <div class="magazine-card cta-card p-5 text-center">
        <h2 class="display-3 relay-heading">Start <span class="text-accent">relaying</span></h2>
        <p class="text-muted mb-4 mx-auto relay-copy cta-copy">Join a community that values clarity and connection.</p>
        <div class="d-flex flex-wrap justify-content-center gap-3">
          <a href="#" class="btn btn-ink px-5 py-3"><i class="bi bi-download me-2"></i>Free download</a>
          <a href="#" class="btn btn-outline-ink px-5 py-3"><i class="bi bi-browser-chrome me-2"></i>Open in browser</a>
        </div>
        <p class="mt-3 small text-muted relay-copy">No credit card - 14-day premium trial</p>
      </div>
    </div>
  </section>
</asp:Content>
