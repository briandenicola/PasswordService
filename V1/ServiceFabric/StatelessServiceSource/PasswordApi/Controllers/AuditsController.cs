using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using PasswordService.Web.Api.Models;

namespace PasswordService.Web.Api.Controllers
{
    public class AuditsController : ApiController
    {
        private PasswordServiceWebApiContext db = new PasswordServiceWebApiContext();

        // GET: api/Audits
        public IQueryable<Audit> GetAudits()
        {
            return db.Audits.OrderByDescending(item => item.Date);
        }

        // GET: api/Audits/5
        [ResponseType(typeof(Audit))]
        public async Task<IHttpActionResult> GetAudit(long id)
        {
            Audit audit = await db.Audits.FindAsync(id);
            if (audit == null)
            {
                return NotFound();
            }

            return Ok(audit);
        }

        // PUT: api/Audits/5
        [ResponseType(typeof(void))]
        public Task<IHttpActionResult> PutAudit(long id, Audit audit)
        {
            throw new HttpResponseException(HttpStatusCode.MethodNotAllowed);
        }

        // POST: api/Audits
        [ResponseType(typeof(Audit))]
        public Task<IHttpActionResult> PostAudit(Audit audit)
        {
            throw new HttpResponseException(HttpStatusCode.MethodNotAllowed);
        }

        // DELETE: api/Audits/5
        [ResponseType(typeof(Audit))]
        public Task<IHttpActionResult> DeleteAudit(long id)
        {
            throw new HttpResponseException(HttpStatusCode.MethodNotAllowed);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing) { db.Dispose(); }
            base.Dispose(disposing);
        }

    }
}