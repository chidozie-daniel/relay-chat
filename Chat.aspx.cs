using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Script.Serialization;
using relay_chat.Services;

namespace relay_chat
{
    public partial class Chat : System.Web.UI.Page
    {
        public int CurrentUserId { get; private set; }
        public string CurrentUsername { get; private set; }
        public int SelectedConversationId { get; private set; }

        private readonly MessageService _messageService = new MessageService();
        private readonly UserService _userService = new UserService();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Ensure user is authenticated
            int? userId = AuthService.GetCurrentUserId();
            if (!userId.HasValue)
            {
                Response.Redirect("~/Login");
                return;
            }

            CurrentUserId = userId.Value;
            var user = _userService.GetById(CurrentUserId);
            CurrentUsername = user?.Username ?? "Unknown";

            // AJAX request handling
            if (Request.QueryString["ajax"] == "1")
            {
                HandleAjaxRequest();
                Response.End();
                return;
            }

            // Parse selected conversation
            string convParam = Request.QueryString["conversationId"];
            if (!string.IsNullOrEmpty(convParam) && int.TryParse(convParam, out int convId))
            {
                SelectedConversationId = convId;
            }
        }

        private void HandleAjaxRequest()
        {
            string search = Request.QueryString["search"];
            string startConv = Request.QueryString["start"];

            if (!string.IsNullOrEmpty(search))
            {
                RenderSearchResults(search);
            }
            else if (!string.IsNullOrEmpty(startConv) && int.TryParse(startConv, out int targetUserId))
            {
                StartConversation(targetUserId);
            }
            else if (Request.QueryString["conversationId"] != null)
            {
                int.TryParse(Request.QueryString["conversationId"], out int convId);
                int.TryParse(Request.QueryString["page"] ?? "1", out int page);
                if (page < 1) page = 1;
                RenderMessageHtml(convId, page);
            }
        }

        /// <summary>
        /// Renders conversation list HTML. Called from the ASPX page.
        /// </summary>
        public string RenderConversations()
        {
            var conversations = _messageService.GetUserConversations(CurrentUserId);
            var html = new System.Text.StringBuilder();

            foreach (dynamic conv in conversations)
            {
                string name = GetConversationDisplayName(conv);
                string preview = conv.lastMessage?.content ?? "No messages yet";
                string time = conv.lastMessage?.sentAt != null
                    ? FormatTime((DateTime)conv.lastMessage.sentAt)
                    : "";
                string unreadBadge = conv.unreadCount > 0
                    ? $"<span class=\"conv-unread\" id=\"unread-{conv.id}\">{conv.unreadCount}</span>"
                    : "";
                string activeClass = conv.id == SelectedConversationId ? " active" : "";
                string avatarLetter = name.Length > 0 ? name[0].ToString().ToUpper() : "?";

                // Get partner user ID for online status
                string partnerUserId = "";
                bool isOnline = false;
                foreach (var p in conv.otherParticipants)
                {
                    partnerUserId = p.Id.ToString();
                    isOnline = p.IsOnline;
                }

                html.Append($"<a class=\"conv-item{activeClass}\" id=\"conv-{conv.id}\" " +
                    $"data-name=\"{HttpUtility.HtmlAttributeEncode(name.ToLower())}\" " +
                    $"href=\"#\" onclick=\"selectConversation({conv.id},'{HttpUtility.HtmlAttributeEncode(name)}','{partnerUserId}');return false;\">" +
                    $"<div class=\"conv-avatar\" data-userid=\"{partnerUserId}\">" +
                    $"{avatarLetter}" +
                    $"<span class=\"{((isOnline) ? "online-dot" : "offline-dot")}\"></span>" +
                    $"</div>" +
                    $"<div class=\"conv-info\">" +
                    $"<div class=\"conv-name\">{HttpUtility.HtmlEncode(name)}</div>" +
                    $"<div class=\"conv-preview\">{HttpUtility.HtmlEncode(preview)}</div>" +
                    $"</div>" +
                    $"<div class=\"conv-meta\">" +
                    $"<span class=\"conv-time\">{time}</span>" +
                    $"{unreadBadge}" +
                    $"</div></a>");
            }

            return html.ToString();
        }

        /// <summary>
        /// Renders messages HTML for a conversation. Called from the ASPX page and AJAX.
        /// </summary>
        public string RenderMessages(int page = 1)
        {
            var html = new System.Text.StringBuilder();

            if (SelectedConversationId <= 0)
                return "";

            var messages = _messageService.GetMessages(SelectedConversationId, page);
            bool hasMore = messages.Count == 50; // page size

            if (page == 1 && messages.Count == 0)
            {
                html.Append("<div class=\"text-center text-muted py-5 relay-copy\">No messages yet. Start the conversation!</div>");
                return html.ToString();
            }

            // "Load older messages" button — shown at top when there may be more
            if (hasMore)
            {
                html.Append($"<div class=\"load-more-wrapper\" id=\"loadMoreWrapper-{page}\">" +
                    $"<button class=\"btn btn-outline-ink btn-sm load-more-btn\" " +
                    $"onclick=\"loadOlderMessages({SelectedConversationId}, {page + 1}, this)\">Load older messages</button>" +
                    $"</div>");
            }

            DateTime? lastDate = null;

            foreach (var msg in messages)
            {
                // Date separator
                if (!lastDate.HasValue || msg.SentAt.Date != lastDate.Value.Date)
                {
                    html.Append($"<div class=\"date-separator\"><span>{msg.SentAt:dddd, MMMM d}</span></div>");
                    lastDate = msg.SentAt.Date;
                }

                bool isSent = msg.SenderId == CurrentUserId;
                string bubbleClass = isSent ? "sent" : "received";
                string time = msg.SentAt.ToLocalTime().ToString("h:mm tt");
                string readIcon = isSent && msg.IsRead
                    ? " <span class=\"message-read\"><i class=\"bi bi-check-all\"></i></span>"
                    : isSent ? " <span class=\"message-read\"><i class=\"bi bi-check\"></i></span>" : "";

                html.Append($"<div class=\"message-row {bubbleClass}\">" +
                    $"<div class=\"message-bubble\">{HttpUtility.HtmlEncode(msg.Content)}" +
                    $"<div class=\"message-time\">{time}{readIcon}</div>" +
                    $"</div></div>");
            }

            return html.ToString();
        }

        private void RenderMessageHtml(int conversationId, int page = 1)
        {
            SelectedConversationId = conversationId;
            Response.ContentType = "text/html";
            Response.Write(RenderMessages(page));
        }

        private void RenderSearchResults(string query)
        {
            var results = _userService.Search(query)
                .Where(u => u.Id != CurrentUserId)
                .ToList();

            var html = new System.Text.StringBuilder();

            if (results.Count == 0)
            {
                html.Append("<p class=\"text-muted small relay-copy text-center py-3\">No users found</p>");
            }
            else
            {
                foreach (var user in results)
                {
                    string letter = user.DisplayName.Length > 0 ? user.DisplayName[0].ToString().ToUpper() : "?";
                    html.Append($"<div class=\"search-result-item\" onclick=\"startConversation({user.Id},'{HttpUtility.HtmlAttributeEncode(user.DisplayName)}')\">" +
                        $"<div class=\"conv-avatar\">{letter}</div>" +
                        $"<div><strong class=\"relay-heading\">{HttpUtility.HtmlEncode(user.DisplayName)}</strong><br />" +
                        $"<span class=\"text-muted small relay-copy\">@{HttpUtility.HtmlEncode(user.Username)}</span></div>" +
                        $"</div>");
                }
            }

            Response.ContentType = "text/html";
            Response.Write(html.ToString());
        }

        private void StartConversation(int targetUserId)
        {
            var conversation = _messageService.GetOrCreateOneOnOneConversation(CurrentUserId, targetUserId);

            var serializer = new JavaScriptSerializer();
            string json = serializer.Serialize(new { conversationId = conversation.Id });

            Response.ContentType = "application/json";
            Response.Write(json);
        }

        private string GetConversationDisplayName(dynamic conv)
        {
            // For 1-on-1, show the other participant's name
            if (conv.type == 0 && conv.otherParticipants.Count > 0)
            {
                var partner = conv.otherParticipants[0];
                return partner.DisplayName;
            }

            // For group, show the conversation name
            return !string.IsNullOrEmpty(conv.name) ? conv.name : "Group Chat";
        }

        private string FormatTime(DateTime dateTime)
        {
            var local = dateTime.ToLocalTime();
            var now = DateTime.Now;

            if (local.Date == now.Date)
                return local.ToString("h:mm tt");

            if (local.Year == now.Year)
                return local.ToString("MMM d");

            return local.ToString("M/d/yy");
        }

        public override void Dispose()
        {
            _messageService?.Dispose();
            _userService?.Dispose();
            base.Dispose();
        }
    }
}
