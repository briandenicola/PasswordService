using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using PasswordService.Services;
using PasswordService.Models;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;

namespace PasswordService.Controllers
{
	[Authorize]
    [Produces("application/json")]
    [Route("api/Password")]
    public class PasswordController : Controller
    {
		private static IAzureDBService _dbService;
		private static IAzureArchiveService _archiveService;

		public PasswordController(IAzureDBService dbService, IAzureArchiveService archiveService)
		{
			_dbService = dbService;
			_archiveService = archiveService;
		}

		// GET: api/Password
		[HttpGet]
        public async Task<ActionResult> GetPasswords()
        {
			IList<Password> passwords = await _dbService.GetPasswords();
			return Ok(passwords);
		}

        // GET: api/Password/5
        [HttpGet("{id}", Name = "Get")]
        public async Task<ActionResult> GetPassword(string id)
        {
			Password password = await _dbService.GetPassword(id);
			return Ok(password);
		}
        
        // POST: api/Password
        [HttpPost]
		[ActionName("Create")]
		public async Task<ActionResult> NewPassword([FromBody] Password password)
        {
			if (!ModelState.IsValid)
			{
				return BadRequest(ModelState);
			}

			await _archiveService.AddPassword(password);
			await _dbService.AddPassword(password);
			return Ok(password);
		}
        
        // PUT: api/Password/5
        [HttpPut("{id}")]
        public async Task<ActionResult>  UpdatePassword(string id, [FromBody]Password password)
        {
			if (!ModelState.IsValid)
			{
				return BadRequest(ModelState);
			}

			await _archiveService.AddPassword(password);
			await _dbService.UpdatePassword(id,password);
			return Ok(password);
		}
        
        // DELETE: api/ApiWithActions/5
        [HttpDelete("{id}")]
        public async Task<ActionResult> DeletePassword(string id)
        {
			if (!ModelState.IsValid)
			{
				return BadRequest(ModelState);
			}

			var orgPassword = await _dbService.GetPassword(id);
			await _archiveService.AddPassword(orgPassword);

			await _dbService.DeletePassword(id);
			return Ok();
		}
    }
}
