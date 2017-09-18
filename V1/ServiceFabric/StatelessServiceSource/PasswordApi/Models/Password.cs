using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PasswordService.Web.Api.Models
{
    public class Password 
    {
        public virtual long PasswordId { get; set; }
        public virtual string Name { get; set; }
        public virtual string Salt { get; set; }
        public virtual string Value { get; set; }
        public virtual string Usage { get; set;  }
        public virtual string Notes { get; set; }
        public virtual string SecurityQuestions { get; set; }
        public virtual DateTime CreatedDate { get; set; }
        public virtual string CreatedBy { get; set; }
        public virtual DateTime LastModifiedDate { get; set; }
        public virtual string LastModifyBy { get; set; }
        public virtual byte[] Version { get; set; }
    }
}
