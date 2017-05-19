namespace PasswordService.Web.Api.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AuditMigration : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Audit",
                c => new
                {
                    AuditId = c.Long(nullable: false, identity: true),
                    Date = c.DateTime(nullable: false),
                    DateUTC = c.DateTime(nullable: false),
                    AccountName = c.String(),
                    Action = c.String(),
                    User = c.String(),
                    Notes = c.String(),
                    Version = c.Binary(),
                })
                .PrimaryKey(t => t.AuditId);
    }
        
        public override void Down()
        {
            DropTable("dbo.Audit");
        }
    }
}
