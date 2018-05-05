using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using PasswordService.Models;
using Microsoft.Extensions.Configuration;
using PasswordService.Common;

namespace PasswordService.Services
{
	public class AzureDBService : IAzureDBService
	{
		private static AzureTableRepository<Password> _tableProvider;
		private static Encryption _encryptionProvider;

		public AzureDBService(IConfiguration configuration)
		{
			_tableProvider = new AzureTableRepository<Password>(new AzureTableSettings(configuration));
			_encryptionProvider = new Encryption(configuration.GetSection("aesKey").Value, configuration.GetSection("aesIV").Value);
		}

		public async Task<Password> GetPassword(string id)
		{
			var password = await _tableProvider.GetItemAsync(id);
			password.PasswordString = Encryption.Decrypt(password.PasswordString).Replace(string.Concat(String.Concat(password.Salt, password.AccountName)), String.Empty);
			return password;
		}

		public async Task<IList<Password>> GetPasswords()
		{
			return await _tableProvider.GetItems();		
		}

		public async Task<Password> AddPassword(Password item)
		{
			item.CreatedDate = item.LastModifiedDate = DateTime.Now;
			try
			{
				item.CreatedBy = item.LastModifyBy = System.Threading.Thread.CurrentPrincipal.Identity.Name;
			}
			catch
			{
				item.CreatedBy = item.LastModifyBy = String.Empty;
			}
			item.Salt = Encryption.GenerateSalt();
			item.PasswordString = Encryption.Encrypt(String.Concat(item.Salt, item.AccountName, item.PasswordString));

			return await _tableProvider.CreateItemAsync(item);
		}

		public async Task<Password> UpdatePassword(string id, Password item)
		{
			if (id != item.RowKey)
			{
				return null;
			}

			item.LastModifiedDate = DateTime.Now;
			try
			{
				item.LastModifyBy = System.Threading.Thread.CurrentPrincipal.Identity.Name;
			}
			catch
			{
				item.LastModifyBy = String.Empty;
			}
			item.PasswordString = Encryption.Encrypt(String.Concat(item.Salt, item.AccountName, item.PasswordString));
			return await _tableProvider.UpdateItemAsync(id, item);
		}

		public async Task<Password> DeletePassword(string id)
		{
			return await _tableProvider.DeleteItemAsync(id);
		}
	}
}
