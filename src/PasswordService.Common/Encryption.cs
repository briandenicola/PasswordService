using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Security.Cryptography;
using System.IO;

namespace PasswordService.Common
{
    public class Encryption
    {
        private static byte[] _key;
        private static byte[] _iv;

        public Encryption(string key, string iv) 
        {
            _key = Convert.FromBase64String(key);
            _iv = Convert.FromBase64String(iv);
        }

        public static string Encrypt(string plainText)
        {
            if (plainText == null || plainText.Length <= 0)
                throw new ArgumentNullException("plainText");

            MemoryStream msEncrypt = null;
            CryptoStream csEncrypt = null;
            StreamWriter swEncrypt = null;

            RijndaelManaged aesAlg = null;

            try {
                aesAlg = new RijndaelManaged();
                aesAlg.Key = _key;
                aesAlg.IV = _iv;
                ICryptoTransform encryptor = aesAlg.CreateEncryptor(aesAlg.Key, aesAlg.IV);
                msEncrypt = new MemoryStream();
                csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write);
                swEncrypt = new StreamWriter(csEncrypt);
                swEncrypt.Write(plainText);

            }
            finally {
                if (swEncrypt != null) swEncrypt.Close();
                if (csEncrypt != null) csEncrypt.Close();
                if (msEncrypt != null) msEncrypt.Close();
                if (aesAlg != null) aesAlg.Clear();
            }

            return Convert.ToBase64String(msEncrypt.ToArray());
        }

        public static string Decrypt(string cipherText)
        {
            if (cipherText == null || cipherText.Length <= 0)
                throw new ArgumentNullException("cipherText");

            MemoryStream    msDecrypt   = null;
            CryptoStream    csDecrypt   = null;
            StreamReader    srDecrypt   = null;
            RijndaelManaged aesAlg      = null;
            string plaintext = String.Empty;

            try {
                aesAlg = new RijndaelManaged();
                aesAlg.Key = _key;
                aesAlg.IV = _iv;

                ICryptoTransform decryptor = aesAlg.CreateDecryptor(aesAlg.Key, aesAlg.IV);
                msDecrypt = new MemoryStream(Convert.FromBase64String(cipherText));
                csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read);
                srDecrypt = new StreamReader(csDecrypt);

                plaintext = srDecrypt.ReadToEnd();
            }
            finally  {
                if (srDecrypt != null) srDecrypt.Close();
                if (csDecrypt != null) csDecrypt.Close();
                if (msDecrypt != null) msDecrypt.Close();
                if (aesAlg != null) aesAlg.Clear();
            }

            return plaintext;
        }

        public static string GenerateSalt()
        {
            int size = 256;
            RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
            byte[] buff = new byte[size];
            rng.GetBytes(buff);
            return Convert.ToBase64String(buff);
        }
    }
}
