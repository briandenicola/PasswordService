namespace PasswordService.Web.Api.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class SecurityQuestionColumns : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Passwords", "Notes", c => c.String());
            AddColumn("dbo.Passwords", "SecurityQuestions", c => c.String());
        }
        
        public override void Down()
        {
        }
    }
}
