<%@ Page Title="Chats" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Chat.aspx.cs" Inherits="relay_chat.Chat" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Hidden data for client-side JS -->
  <input type="hidden" id="hfCurrentUserId" value="<%= CurrentUserId %>" />
  <input type="hidden" id="hfCurrentUsername" value="<%= CurrentUsername %>" />

  <div class="chat-dashboard">
    <!-- ─── Sidebar: Conversation List ─── -->
    <div class="conversation-sidebar" id="conversationSidebar">
      <div class="sidebar-header">
        <h5>Chats</h5>
        <button class="new-chat-btn" id="newChatBtn" title="New conversation" onclick="openNewChatModal()">
          <i class="bi bi-plus-lg"></i>
        </button>
      </div>

      <div class="search-box">
        <input type="text" id="convSearch" placeholder="Search conversations..." oninput="filterConversations(this.value)" />
      </div>

      <div class="conversation-list" id="conversationList">
        <%= RenderConversations() %>
      </div>
    </div>

    <!-- ─── Main: Active Chat ─── -->
    <div class="chat-main" id="chatMain">
      <!-- Empty state -->
      <div class="no-chat-selected" id="noChatSelected">
        <i class="bi bi-chat-dots"></i>
        <p>Select a conversation to start chatting</p>
      </div>

      <!-- Active conversation (hidden by default) -->
      <div id="activeChat" class="active-chat-panel">
        <div class="chat-header">
          <button class="d-md-none btn btn-sm btn-outline-ink me-2" onclick="showSidebar()" style="border-radius: 12px; padding: 0.3rem 0.6rem;">
            <i class="bi bi-arrow-left"></i>
          </button>
          <div class="chat-avatar" id="chatPartnerAvatar">?</div>
          <div class="chat-header-info">
            <div class="chat-header-name" id="chatPartnerName">Loading...</div>
            <div class="chat-header-status" id="chatPartnerStatus">offline</div>
          </div>
        </div>

        <div class="typing-indicator" id="typingIndicator">
          <div class="typing-dots">
            <span></span><span></span><span></span>
          </div>
          <span id="typingText">someone is typing...</span>
        </div>

        <div class="chat-messages" id="chatMessages">
          <%= RenderMessages(1) %>
        </div>

        <div class="chat-input-area">
          <textarea id="messageInput" rows="1" placeholder="Type a message..."
            onkeydown="handleInputKeydown(event)"
            oninput="autoResize(this); handleTyping()"></textarea>
          <button class="send-btn" id="sendBtn" onclick="sendMessage()" disabled>
            <i class="bi bi-send-fill"></i>
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- ─── New Chat Modal ─── -->
  <div class="modal-overlay" id="newChatModal">
    <div class="modal-content">
      <button class="close-modal" onclick="closeNewChatModal()"><i class="bi bi-x-lg"></i></button>
      <h4>New conversation</h4>

      <!-- Mode toggle -->
      <div class="chat-mode-toggle mb-3">
        <button class="mode-btn active" id="modeDirect" onclick="setMode('direct')">
          <i class="bi bi-person"></i> Direct
        </button>
        <button class="mode-btn" id="modeGroup" onclick="setMode('group')">
          <i class="bi bi-people"></i> Group
        </button>
      </div>

      <!-- Group name (group mode only) -->
      <div id="groupNameWrapper" style="display:none;" class="mb-2">
        <input type="text" id="groupName" class="form-control" placeholder="Group name..." maxlength="200" />
        <div id="groupNameError" class="text-danger small mt-1" style="display:none;"></div>
      </div>

      <div class="search-box px-0">
        <input type="text" id="userSearch" placeholder="Search by username or display name..."
          oninput="searchUsers(this.value)" autocomplete="off" />
      </div>

      <!-- Group selected members -->
      <div id="selectedMembers" style="display:none;" class="selected-members-list mt-2"></div>

      <div class="search-results" id="searchResults">
        <p class="text-muted small relay-copy text-center py-3">Type to search for users</p>
      </div>

      <!-- Group create button -->
      <div id="createGroupWrapper" style="display:none;" class="mt-3">
        <button class="btn btn-ink w-100" onclick="submitCreateGroup()">
          <i class="bi bi-people-fill me-2"></i>Create group
        </button>
      </div>
    </div>
  </div>

  <script>
    // ─── SignalR Client Integration ───
    var currentConvId = <%= SelectedConversationId %>;
    var isAtBottom = true;
    var typingTimer = null;
    var isTyping = false;

    $(document).ready(function () {
      // Initialize SignalR
      RelayChat.init($('#hfCurrentUserId').val());

      // Auto-select conversation from URL parameter — use server-rendered messages
      if (currentConvId > 0) {
        var $convItem = $('#conv-' + currentConvId);
        if ($convItem.length) {
          var name = $convItem.find('.conv-name').text();
          showChatPanel(currentConvId, name.trim(), '', true);
        } else {
          // Not in list — fetch via AJAX
          setTimeout(function () {
            showChatPanel(currentConvId, 'Conversation', '');
          }, 500);
        }
      }
    });

    // Listen for new messages
    $(document).on('relay:newMessage', function (e, msg) {
      if (msg.conversationId === currentConvId) {
        appendMessage(msg);
        // Mark as read
        RelayChat.markAsRead(msg.id, msg.conversationId);
      }
      // Update conversation list
      updateConversationLastMessage(msg);
    });

    // Listen for typing indicator
    $(document).on('relay:userTyping', function (e, data) {
      if (data.conversationId === currentConvId && data.userId !== $('#hfCurrentUserId').val()) {
        var indicator = $('#typingIndicator');
        $('#typingText').text(data.username + ' is typing...');
        indicator.addClass('visible');
        clearTimeout(typingTimer);
        typingTimer = setTimeout(function () {
          indicator.removeClass('visible');
        }, 3000);
      }
    });

    // Listen for online status
    $(document).on('relay:userOnline relay:userOffline', function (e, data) {
      updateOnlineStatus(data.userId, data.isOnline);
    });

    // Listen for connection state
    $(document).on('relay:connected', function () {
      if (currentConvId > 0) RelayChat.joinConversation(currentConvId);
    });

    // Track scroll position
    $('#chatMessages').on('scroll', function () {
      var el = $(this);
      isAtBottom = el.scrollTop() + el.innerHeight() >= el[0].scrollHeight - 50;
    });

    // ─── Message Functions ───

    function sendMessage() {
      var input = $('#messageInput');
      var content = input.val().trim();
      if (!content || !currentConvId) return;

      RelayChat.sendMessage(currentConvId, content);
      input.val('');
      input.trigger('input');
      $('#sendBtn').prop('disabled', true);
    }

    function appendMessage(msg) {
      var container = $('#chatMessages');
      var isSent = msg.senderId == $('#hfCurrentUserId').val();
      var time = new Date(msg.sentAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
      var bubbleClass = isSent ? 'sent' : 'received';

      var html = '<div class="message-row ' + bubbleClass + '">' +
        '<div class="message-bubble">' + escapeHtml(msg.content) +
        '<div class="message-time">' + time + (isSent ? ' <span class="message-read"><i class="bi bi-check"></i></span>' : '') +
        '</div></div></div>';

      container.append(html);
      scrollToBottom();
    }

    function scrollToBottom() {
      var el = $('#chatMessages');
      el.scrollTop(el[0].scrollHeight);
    }

    function handleInputKeydown(e) {
      if (e.key === 'Enter' && !e.shiftKey) {
        e.preventDefault();
        sendMessage();
      }
    }

    function handleTyping() {
      if (!currentConvId) return;
      if (!isTyping) {
        isTyping = true;
        RelayChat.sendTyping(currentConvId, true);
      }
      clearTimeout(window.typingStopTimer);
      window.typingStopTimer = setTimeout(function () {
        isTyping = false;
        RelayChat.sendTyping(currentConvId, false);
      }, 2000);

      // Enable/disable send button
      var hasText = $('#messageInput').val().trim().length > 0;
      $('#sendBtn').prop('disabled', !hasText);
    }

    // ─── Conversation Functions ───

    // Shows the chat panel. When skipLoad is true, uses server-rendered messages in the DOM.
    function showChatPanel(convId, name, partnerId, skipLoad) {
      currentConvId = convId;
      RelayChat.joinConversation(convId);

      $('.conv-item').removeClass('active');
      $('#conv-' + convId).addClass('active');
      $('#noChatSelected').hide();
      $('#activeChat').addClass('visible');

      $('#chatPartnerName').text(name);
      $('#chatPartnerAvatar').text(name.charAt(0).toUpperCase());

      if (skipLoad) {
        scrollToBottom();
      } else {
        $('#chatMessages').html('<div class="text-center text-muted py-5 relay-copy"><i class="bi bi-arrow-clockwise me-2"></i>Loading messages...</div>');
        $.get('Chat.aspx?conversationId=' + convId + '&page=1&ajax=1', function (data) {
          $('#chatMessages').html(data);
          scrollToBottom();
        });
      }

      history.pushState(null, '', 'Chat?conversationId=' + convId);
      $('#unread-' + convId).remove();

      if ($(window).width() <= 768) {
        $('#conversationSidebar').hide();
        $('#chatMain').addClass('mobile-visible');
      }
    }

    function selectConversation(convId, name, partnerId) {
      showChatPanel(convId, name, partnerId, false);
    }

    function showSidebar() {
      $('#conversationSidebar').show();
      $('#chatMain').removeClass('mobile-visible');
    }

    function updateConversationLastMessage(msg) {
      var convItem = $('#conv-' + msg.conversationId);
      if (convItem.length) {
        var time = new Date(msg.sentAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        convItem.find('.conv-preview').text(msg.content.substring(0, 60) + (msg.content.length > 60 ? '...' : ''));
        convItem.find('.conv-time').text(time);

        // Move to top
        var parent = convItem.closest('.conversation-list');
        convItem.prependTo(parent);
        convItem.removeClass('active');
      } else {
        // New conversation appeared — reload list
        location.reload();
      }
    }

    function filterConversations(query) {
      $('.conv-item').each(function () {
        var name = $(this).data('name').toLowerCase();
        $(this).toggle(name.indexOf(query.toLowerCase()) !== -1);
      });
    }

    // ─── Online Status ───

    function updateOnlineStatus(userId, online) {
      // Update conversation list avatars
      $('[data-userid="' + userId + '"]').each(function () {
        var dot = $(this).find('.online-dot, .offline-dot');
        dot.removeClass('online-dot offline-dot');
        dot.addClass(online ? 'online-dot' : 'offline-dot');
      });

      // Update chat header if it's the current partner
      if ($('#chatPartnerStatus').data('userid') == userId) {
        $('#chatPartnerStatus').text(online ? 'online' : 'offline').toggleClass('online', online);
      }
    }

    // ─── New Chat Modal ───

    var currentMode = 'direct';
    var selectedGroupMembers = {}; // { userId: displayName }

    function setMode(mode) {
      currentMode = mode;
      $('#modeDirect').toggleClass('active', mode === 'direct');
      $('#modeGroup').toggleClass('active', mode === 'group');
      $('#groupNameWrapper').toggle(mode === 'group');
      $('#selectedMembers').toggle(mode === 'group');
      $('#createGroupWrapper').toggle(mode === 'group' && Object.keys(selectedGroupMembers).length > 0);
      $('#userSearch').val('');
      $('#searchResults').html('<p class="text-muted small relay-copy text-center py-3">Type to search for users</p>');
    }

    function openNewChatModal() {
      $('#newChatModal').addClass('visible');
      currentMode = 'direct';
      selectedGroupMembers = {};
      $('#modeDirect').addClass('active');
      $('#modeGroup').removeClass('active');
      $('#groupNameWrapper').hide();
      $('#groupName').val('');
      $('#groupNameError').hide();
      $('#selectedMembers').hide().empty();
      $('#createGroupWrapper').hide();
      $('#userSearch').val('').focus();
      $('#searchResults').html('<p class="text-muted small relay-copy text-center py-3">Type to search for users</p>');
    }

    function closeNewChatModal() {
      $('#newChatModal').removeClass('visible');
    }

    var searchTimeout = null;

    function searchUsers(query) {
      clearTimeout(searchTimeout);
      if (query.length < 2) {
        $('#searchResults').html('<p class="text-muted small relay-copy text-center py-3">Type at least 2 characters to search</p>');
        return;
      }

      searchTimeout = setTimeout(function () {
        $.get('Chat.aspx?search=' + encodeURIComponent(query) + '&ajax=1', function (data) {
          $('#searchResults').html(data);
          // Mark already-selected members
          if (currentMode === 'group') {
            Object.keys(selectedGroupMembers).forEach(function (uid) {
              $('#searchResults [data-userid="' + uid + '"]').addClass('selected');
            });
          }
        });
      }, 300);
    }

    function startConversation(userId, username) {
      if (currentMode === 'group') {
        toggleGroupMember(userId, username);
        return;
      }
      closeNewChatModal();
      $.getJSON('Chat.aspx?start=' + userId + '&ajax=1', function (data) {
        if (data && data.conversationId) {
          selectConversation(data.conversationId, username, userId);
        }
      });
    }

    function toggleGroupMember(userId, displayName) {
      if (selectedGroupMembers[userId]) {
        delete selectedGroupMembers[userId];
      } else {
        selectedGroupMembers[userId] = displayName;
      }
      // Toggle visual selected state on search result
      $('#searchResults [data-userid="' + userId + '"]').toggleClass('selected', !!selectedGroupMembers[userId]);
      renderSelectedMembers();
    }

    function renderSelectedMembers() {
      var members = Object.keys(selectedGroupMembers);
      var $list = $('#selectedMembers');
      $list.empty();
      if (members.length === 0) {
        $list.hide();
        $('#createGroupWrapper').hide();
        return;
      }
      $list.show();
      members.forEach(function (uid) {
        var name = selectedGroupMembers[uid];
        var $tag = $('<span class="member-tag">' + escapeHtml(name) +
          ' <button onclick="toggleGroupMember(' + uid + ', \'' + escapeHtml(name) + '\')">&times;</button></span>');
        $list.append($tag);
      });
      $('#createGroupWrapper').show();
    }

    function submitCreateGroup() {
      var name = $('#groupName').val().trim();
      if (!name) {
        $('#groupNameError').text('Please enter a group name.').show();
        return;
      }
      $('#groupNameError').hide();

      var memberIds = Object.keys(selectedGroupMembers).join(',');

      $.post('Chat.aspx?createGroup=1&ajax=1', { name: name, memberIds: memberIds }, function (data) {
        if (data && data.conversationId) {
          closeNewChatModal();
          selectConversation(data.conversationId, data.name, '');
          location.reload(); // Refresh sidebar to show new group
        }
      }, 'json').fail(function (xhr) {
        var err = xhr.responseJSON && xhr.responseJSON.error ? xhr.responseJSON.error : 'Failed to create group.';
        $('#groupNameError').text(err).show();
      });
    }

    // ─── Utilities ───

    function loadOlderMessages(convId, page, btn) {
      var $btn = $(btn);
      var $wrapper = $btn.closest('.load-more-wrapper');
      $btn.prop('disabled', true).text('Loading...');

      var container = $('#chatMessages');
      var scrollHeightBefore = container[0].scrollHeight;

      $.get('Chat.aspx?conversationId=' + convId + '&page=' + page + '&ajax=1', function (data) {
        $wrapper.remove();
        container.prepend(data);

        // Maintain scroll position so user doesn't jump
        var scrollHeightAfter = container[0].scrollHeight;
        container.scrollTop(scrollHeightAfter - scrollHeightBefore);
      }).fail(function () {
        $btn.prop('disabled', false).text('Load older messages');
      });
    }

    function autoResize(el) {
      el.style.height = 'auto';
      el.style.height = Math.min(el.scrollHeight, 144) + 'px';
    }

    function escapeHtml(text) {
      var div = document.createElement('div');
      div.textContent = text;
      return div.innerHTML;
    }

    // Close modal on click outside
    $(document).on('click', function (e) {
      if ($(e.target).hasClass('modal-overlay')) {
        closeNewChatModal();
      }
    });
  </script>
</asp:Content>
