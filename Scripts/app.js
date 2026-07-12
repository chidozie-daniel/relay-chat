// Relay Chat - SignalR client
(function () {
    "use strict";

    // ─── Scroll-link navigation (home page) ───
    var scrollLinks = document.querySelectorAll('.scroll-link');
    if (scrollLinks.length > 0) {
        // Smooth scroll on click
        scrollLinks.forEach(function (link) {
            link.addEventListener('click', function (e) {
                e.preventDefault();
                var targetId = this.getAttribute('href').slice(1);
                var target = document.getElementById(targetId);
                if (target) {
                    var navbar = document.querySelector('.navbar');
                    var offset = navbar ? navbar.offsetHeight : 60;
                    var top = target.getBoundingClientRect().top + window.pageYOffset - offset;
                    window.scrollTo({ top: top, behavior: 'smooth' });

                    // Close mobile nav
                    var navCollapse = document.getElementById('navbarNav');
                    if (navCollapse && navCollapse.classList.contains('show')) {
                        navCollapse.classList.remove('show');
                        var toggler = document.querySelector('.navbar-toggler');
                        if (toggler) toggler.setAttribute('aria-expanded', 'false');
                    }
                }
            });
        });

        // Active section tracking via IntersectionObserver
        var sections = [];
        scrollLinks.forEach(function (link) {
            var id = link.getAttribute('href').slice(1);
            var section = document.getElementById(id);
            if (section) sections.push(section);
        });

        var observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                var id = entry.target.getAttribute('id');
                var link = document.querySelector('.scroll-link[href="#' + id + '"]');
                if (link) {
                    if (entry.isIntersecting) {
                        link.classList.add('active');
                    } else {
                        link.classList.remove('active');
                    }
                }
            });
        }, { rootMargin: '-50% 0px -50% 0px' });

        sections.forEach(function (section) {
            observer.observe(section);
        });
    }

    // ─── SignalR chat (only on pages with SignalR loaded) ───
    if (typeof $ === "undefined" || typeof $.connection === "undefined") {
        return;
    }

    var chat = $.connection.chatHub;
    var currentUserId = null;

    // Client-side event handlers (called by the server)
    chat.client.newMessage = function (message) {
        $(document).trigger("relay:newMessage", [message]);
    };

    chat.client.userTyping = function (data) {
        $(document).trigger("relay:userTyping", [data]);
    };

    chat.client.userOnline = function (userId, username) {
        $(document).trigger("relay:userOnline", [{ userId: userId, username: username, isOnline: true }]);
    };

    chat.client.userOffline = function (userId) {
        $(document).trigger("relay:userOffline", [{ userId: userId, isOnline: false }]);
    };

    chat.client.messageRead = function (data) {
        $(document).trigger("relay:messageRead", [data]);
    };

    // Connection management
    var connection = $.connection.hub;

    connection.logging = false;

    connection.error(function (error) {
        console.error("SignalR error:", error);
    });

    connection.stateChanged(function (change) {
        if (change.newState === $.connection.connectionState.disconnected) {
            $(document).trigger("relay:disconnected");
        } else if (change.newState === $.connection.connectionState.connected) {
            $(document).trigger("relay:connected");
        }
    });

    // Start the connection
    function startConnection(userId) {
        currentUserId = userId;

        $.connection.hub.start().done(function () {
            console.log("SignalR connected");
        }).fail(function (error) {
            console.error("SignalR connection failed:", error);
            setTimeout(function () {
                startConnection(userId);
            }, 5000);
        });
    }

    // Public API for pages to use
    window.RelayChat = {
        init: function (userId) { startConnection(userId); },
        sendMessage: function (conversationId, content) {
            if (!content || !content.trim()) return;
            chat.server.sendMessage(conversationId, content.trim());
        },
        joinConversation: function (conversationId) { chat.server.joinConversation(conversationId); },
        leaveConversation: function (conversationId) { chat.server.leaveConversation(conversationId); },
        sendTyping: function (conversationId, isTyping) { chat.server.typing(conversationId, isTyping); },
        markAsRead: function (messageId, conversationId) { chat.server.markAsRead(messageId, conversationId); },
        isConnected: function () { return $.connection.hub.state === $.connection.connectionState.connected; }
    };

})();
