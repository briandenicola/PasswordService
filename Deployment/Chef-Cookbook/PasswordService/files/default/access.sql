USE [PasswordService]
GO

CREATE LOGIN [IIS APPPOOL\PasswordService] FROM WINDOWS
CREATE USER [IIS APPPOOL\PasswordService]
GRANT ALL ON PasswordService TO [IIS APPPOOL\PasswordService]
GO