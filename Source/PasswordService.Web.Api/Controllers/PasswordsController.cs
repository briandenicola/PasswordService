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

        [System.Web.Http.HttpGet]
        public IQueryable<Password> GetPasswords()
        {
            
            var passswords = db.Passwords
                .ToList()
                .Select( item => new Password
                {
                    PasswordId = item.PasswordId,
                    Name = item.Name,
                    Salt = string.Concat(Enumerable.Repeat("*", 8)),
                    Value = item.Value,
                    Usage = item.Usage,
                    CreatedBy = item.CreatedBy,
                    CreatedDate = item.CreatedDate,
                    LastModifiedDate = item.LastModifiedDate,
                    LastModifyBy = item.LastModifyBy
                })
                .OrderByDescending(item => item.Name)
                .AsQueryable();

            return passswords;
        }

        [System.Web.Http.HttpGet]
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

        [System.Web.Http.HttpPut]
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

        [System.Web.Http.HttpPost]
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

        [System.Web.Http.HttpDelete]
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