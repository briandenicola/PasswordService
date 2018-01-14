using System;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using PasswordService.Web.Api.Models;

namespace PasswordService.Web.Api.Controllers
{
	[Route("api/[controller]")]
	public class AuditsController : Controller
    {
        private PasswordServiceWebApiContext db = new PasswordServiceWebApiContext();

		[HttpGet]
		public IQueryable<Audit> GetAudits()
        {
            return db.Audits.OrderByDescending(item => item.Date);
        }

		[HttpGet("{id}")]
		public async Task<IActionResult> GetAudit(long id)
        {
            Audit audit = await db.Audits.FindAsync(id);
            if (audit == null)
            {
                return NotFound();
            }

            return Ok(audit);
        }

		[HttpPut("{id}")]
		public IActionResult Put(long id)
		{
			throw new NotImplementedException();
		}

		[HttpDelete("{id}")]
		public IActionResult Delete(int id)
		{
			throw new NotImplementedException();
		}

        protected override void Dispose(bool disposing)
        {
            if (disposing) { db.Dispose(); }
            base.Dispose(disposing);
        }

    }
}