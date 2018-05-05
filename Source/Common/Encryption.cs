using System;
using System.Security.Cryptography;
using System.IO;

namespace PasswordService.Common
{
    public class Encryption
    {
        private static byte[] _key;
        private static byte[] _iv;
        private static int size = 8;

        public Encryption(string key, string iv) 
        {
            _key = Convert.FromBase64String(key);
            _iv = Convert.FromBase64String(iv);
        }

        public static string Encrypt(string plainText)
        {
            if (plainText == null || plainText.Length <= 0)
                throw new ArgumentNullException("plainText");

            byte[] encrypted_text;

            using (Aes aes = Aes.Create()) {
                aes.Key = _key;
                aes.IV = _iv;

                ICryptoTransform decryptor = aes.CreateEncryptor(aes.Key, aes.IV);
                using (MemoryStream memStream = new MemoryStream()) {
                    using (CryptoStream cryptoStream = new CryptoStream(memStream, decryptor, CryptoStreamMode.Write)) {
                        using (StreamWriter streamWriter = new StreamWriter(cryptoStream)) {
                            streamWriter.Write(plainText);
                        }
                        encrypted_text = memStream.ToArray();
                    }
                }
            }
            return Convert.ToBase64String(encrypted_text);
        }

        public static string Decrypt(string cipherText)
        {
            if (cipherText == null || cipherText.Length <= 0)
                throw new ArgumentNullException("cipherText");

            string plaintext = String.Empty;

            using(Aes aes = Aes.Create() ) {
                aes.Key = _key;
                aes.IV = _iv;

                ICryptoTransform decryptor = aes.CreateDecryptor(aes.Key, aes.IV);
                using(MemoryStream memStream = new MemoryStream(Convert.FromBase64String(cipherText) ) ) {
                    using(CryptoStream cryptoStream = new CryptoStream(memStream, decryptor, CryptoStreamMode.Read) ){
                        using(StreamReader  streamReader = new StreamReader(cryptoStream) ){
                            plaintext = streamReader.ReadToEnd();
                        }
                    }
                }
            }
            return plaintext;
        }

        public static string GenerateSalt()
        {
            RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
            byte[] buff = new byte[size];
            rng.GetBytes(buff);
            return Convert.ToBase64String(buff);
        }
    }
}
