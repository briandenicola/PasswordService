USE [master]
GO

CREATE DATABASE [PasswordService]
ALTER DATABASE [PasswordService] SET COMPATIBILITY_LEVEL = 100
ALTER DATABASE [PasswordService] SET RECOVERY SIMPLE 
GO

CREATE TABLE [PasswordService].[dbo].[Passwords](
	[PasswordId] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Salt] [nvarchar](max) NULL,
	[Usage] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[LastModifyBy] [nvarchar](max) NULL,
	[Version] [varbinary](max) NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Passwords] PRIMARY KEY CLUSTERED (
	[PasswordId] ASC
 )
)

GO