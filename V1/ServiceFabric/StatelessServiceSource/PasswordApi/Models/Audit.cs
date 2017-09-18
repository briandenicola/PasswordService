using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PasswordService.Web.Api.Models
{
    public class Audit
    {
        public virtual long AuditId { get; set; }
        public virtual DateTime Date { get; set; }
        public virtual DateTime DateUTC { get; set; }
        public virtual string AccountName  { get; set; }
        public virtual string Action { get; set; }
        public virtual string User { get; set; }
        public virtual string Notes { get; set; }
        public virtual byte[] Version { get; set; }
    }
}