using System.Data.Entity;
using relay_chat.Models;

namespace relay_chat
{
    public class DatabaseConfig
    {
        public static void Initialize()
        {
            Database.SetInitializer(new CreateDatabaseIfNotExists<RelayDbContext>());
            
            using (var context = new RelayDbContext())
            {
                context.Database.Initialize(force: false);
            }
        }
    }
}
