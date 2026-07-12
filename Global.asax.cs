using System;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;

namespace relay_chat
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Initialize database
            DatabaseConfig.Initialize();

            // Register routes and bundles
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
    }
}