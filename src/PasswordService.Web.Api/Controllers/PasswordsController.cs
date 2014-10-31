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
using PasswordService.Common;

namespace PasswordService.Web.Api.Controllers
{
    [Authorize]
    public class PasswordsController : ApiController
    {
        private PasswordServiceWebApiContext db = new PasswordServiceWebApiContext();
        private Encryption encryption = new Encryption(Configs.Key, Configs.IV);

        // GET api/Passwords
        public IQueryable<Password> GetPasswords()
        {
            return db.Passwords.Select( x => new Password()
                {
                    PasswordId = x.PasswordId,
                    Name = x.Name,
                    Salt = String.Empty,
                    Value = x.Value,
                    Usage = x.Usage,
                    CreatedBy = x.CreatedBy,
                    CreatedDate = x.CreatedDate,
                    LastModifiedDate = x.LastModifiedDate,
                    LastModifyBy = x.LastModifyBy 
                }).OrderByDescending( x => x.Name );
        }

        // GET api/Passwords/5
        [ResponseType(typeof(Password))]
        public async Task<IHttpActionResult> GetPassword(long id)
        {
            Password password = await db.Passwords.FindAsync(id);
            if (password == null) {
                return NotFound();
            }

            password.Value = Encryption.Decrypt(password.Value).Replace(String.Concat(String.Concat(password.Name, password.Salt)),String.Empty).TrimStart();

            return Ok(password);
        }

        // PUT api/Passwords/5
        public async Task<IHttpActionResult> PutPassword(long id, Password password)
        {
            if (!ModelState.IsValid)  {
                return BadRequest(ModelState);
            }

            if (id != password.PasswordId) {
                return BadRequest();
            }

            password.LastModifiedDate = DateTime.Now;
            password.LastModifyBy = System.Threading.Thread.CurrentPrincipal.Identity.Name.ToString();
            password.Value = Encryption.Encrypt(String.Concat(password.Name, password.Salt, password.Value));

            db.Entry(password).State = EntityState.Modified;

            try {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException) {
                if (!PasswordExists(id))  {
                    return NotFound();
                }
                else {
                    throw;
                }
            }

            return StatusCode(HttpStatusCode.NoContent);
        }

        // POST api/Passwords
        [ResponseType(typeof(Password))]
        public async Task<IHttpActionResult> PostPassword(Password password)
        {
            if (!ModelState.IsValid) {
                return BadRequest(ModelState);
            }

            password.CreatedDate = password.LastModifiedDate = DateTime.Now;
            password.CreatedBy = password.LastModifyBy = System.Threading.Thread.CurrentPrincipal.Identity.Name.ToString();
            password.Salt = Encryption.GenerateSalt();
            password.Value = Encryption.Encrypt(String.Concat(password.Name, password.Salt, password.Value));

            db.Passwords.Add(password);
            await db.SaveChangesAsync();

            return CreatedAtRoute("DefaultApi", new { id = password.PasswordId }, password);
        }

        // DELETE api/Passwords/5
        [ResponseType(typeof(Password))]
        public Task<IHttpActionResult> DeletePassword(long id)
        {
            throw new HttpResponseException(HttpStatusCode.MethodNotAllowed); 
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing) { db.Dispose(); }
            base.Dispose(disposing);
        }

        private bool PasswordExists(long id)
        {
            return db.Passwords.Count(e => e.PasswordId == id) > 0;
        }
    }
}