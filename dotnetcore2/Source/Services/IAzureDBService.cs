using System.Collections.Generic;
using System.Threading.Tasks;
using PasswordService.Models;

namespace PasswordService.Services
{
	public interface IAzureDBService
	{
		Task<Password> GetPassword(string id);
		Task<IList<Password>> GetPasswords();
		Task<Password> AddPassword(Password item);
		Task<Password> UpdatePassword(string id, Password item);
		Task<Password> DeletePassword(string id);
	}
}
