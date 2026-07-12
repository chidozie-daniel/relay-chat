using Microsoft.AspNet.SignalR;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(relay_chat.Startup))]

namespace relay_chat
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            // Configure SignalR hub pipeline
            var hubConfiguration = new HubConfiguration
            {
                EnableDetailedErrors = true,
                EnableJavaScriptProxies = true
            };

            app.MapSignalR(hubConfiguration);
        }
    }
}
