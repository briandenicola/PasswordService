using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace PasswordService.Common
{
    public class Configs
    {
        public static string Key = ConfigurationManager.AppSettings["aesKey"];
        public static string IV = ConfigurationManager.AppSettings["aesIV"];
    }
}
