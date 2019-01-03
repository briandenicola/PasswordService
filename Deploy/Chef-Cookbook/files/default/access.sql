USE [master]
GO
CREATE LOGIN [IIS APPPOOL\PasswordService] FROM WINDOWS
GO

USE [PasswordService]
CREATE USER [IIS APPPOOL\PasswordService] FOR LOGIN [IIS APPPOOL\PasswordService]
GO

EXEC sp_addrolemember N'db_owner', N'IIS APPPOOL\PasswordService'
GO