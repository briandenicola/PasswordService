namespace PasswordService.Web.Api.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class UpdatedProper : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Passwords", "Value", c => c.String());
            DropColumn("dbo.Passwords", "EncryptedPassword");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Passwords", "EncryptedPassword", c => c.String());
            DropColumn("dbo.Passwords", "Value");
        }
    }
}
