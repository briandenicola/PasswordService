using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Security.Cryptography;

namespace PasswordService.KeyGenerator
{
    class Program
    {
        static void Main(string[] args)
        {
             int RANDOM_KEY_TRIES = 1000;
             using (Aes aes = Aes.Create()) {
                aes.KeySize = 256;

                for (int i=0; i <= RANDOM_KEY_TRIES; i++) {
                     aes.GenerateKey();
                 }

                System.Console.WriteLine("Key = {0}", Convert.ToBase64String(aes.Key));
                System.Console.WriteLine("IV = {0}", Convert.ToBase64String(aes.IV));
            };
        }
    }
}
