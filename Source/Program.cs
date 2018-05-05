using PasswordService.Common;
using PasswordService.Models;
using PasswordService.Services;

using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;

namespace PasswordService
{
    public class Program
    {
        public static void Main(string[] args)
        {
			BuildWebHost(args).Run();
        }

        public static IWebHost BuildWebHost(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                .UseStartup<Startup>()
                .Build();
    }
}
