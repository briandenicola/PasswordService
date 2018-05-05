using System;
using Microsoft.WindowsAzure;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Auth;
using Microsoft.WindowsAzure.Storage.Table.Protocol;

using Microsoft.WindowsAzure.Storage.Table;

namespace PasswordService.Models
{
	public class Password : TableEntity
	{
		public virtual string SiteName { get; set; }
		public virtual string AccountName { get; set; }
        public string PasswordString { get; set; }
		public virtual string Salt { get; set; }
		public virtual string Notes { get; set; }
        public virtual string SecurityQuestions { get; set; }
        public virtual DateTime CreatedDate { get; set; }
        public virtual string CreatedBy { get; set; }
        public virtual DateTime LastModifiedDate { get; set; }
        public virtual string LastModifyBy { get; set; }

		public Password() {
			this.RowKey = Guid.NewGuid().ToString();
		}
    }
}
