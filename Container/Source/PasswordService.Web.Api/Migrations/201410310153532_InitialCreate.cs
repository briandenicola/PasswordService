namespace PasswordService.Web.Api.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Passwords",
                c => new
                    {
                        PasswordId = c.Long(nullable: false, identity: true),
                        Name = c.String(),
                        Salt = c.String(),
                        EncryptedPassword = c.String(),
                        Usage = c.String(),
                        CreatedDate = c.DateTime(nullable: false),
                        CreatedBy = c.String(),
                        LastModifiedDate = c.DateTime(nullable: false),
                        LastModifyBy = c.String(),
                        Version = c.Binary(),
                    })
                .PrimaryKey(t => t.PasswordId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Passwords");
        }
    }
}
