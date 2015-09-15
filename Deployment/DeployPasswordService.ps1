#requires -version 3.0
#requires -RunAsAdministrator
[CmdletBinding()]
param ()

Set-Variable -Name package_source            -Value "C:\Sources"
Set-Variable -Name iis_home                  -Value "c:\inetpub\wwwroot"

Set-Variable -Name sql_server_express_url    -Value "http://download.microsoft.com/download/8/D/D/8DD7BDBA-CEF7-4D8E-8C16-D9F69527F909/ENU/x64/{0}"
Set-Variable -Name sql_server_express        -Value "SQLEXPR_x64_ENU.exe"
Set-Variable -Name sql_server_express_setup  -Value (Join-Path -Path $package_source -ChildPath "SQL")

Set-Variable -Name password_service_code_url -Value "https://github.com/bjd145/PasswordService/raw/master/Deployment/{0}"
Set-Variable -Name password_service_code     -Value "Passwords-1.0.0.zip"

Set-Variable -Name WebAdmin_resource_Url     -Value "https://gallery.technet.microsoft.com/xWebAdministration-Module-3c8bb6be/file/135740/1/{0}"
Set-Variable -Name WebAdmin_resource         -Value "xWebAdministration_1.3.2.4.zip"

Set-Variable -Name database_resource_Url     -Value "https://gallery.technet.microsoft.com/scriptcenter/xDatabase-PowerShell-0db6cdaf/file/120240/1/{0}"
Set-Variable -Name database_resource         -Value "xDatabase_1.1.zip"


Write-Verbose -Message ("[{0}] - Downloading Required Packages  . . ." -f $(Get-Date))
if( !(Test-Path -Path $package_source) ) {
    New-Item -Path $package_source -ItemType Directory
}

$wc = New-Object System.Net.WebClient
$wc.DownloadFile( ($sql_server_express_url    -f $sql_server_express),     (Join-Path -Path $package_source -ChildPath $sql_server_express)    )
$wc.DownloadFile( ($password_service_code_url -f $password_service_code),  (Join-Path -Path $package_source -ChildPath $password_service_code) )
$wc.DownloadFile( ($WebAdmin_resource_Url     -f $WebAdmin_resource),      (Join-Path -Path $package_source -ChildPath $WebAdmin_resource) )
$wc.DownloadFile( ($database_resource_Url     -f $database_resource),      (Join-Path -Path $package_source -ChildPath $database_resource) )

Write-Verbose -Message ("[{0}] - Extract SQL Express Install Files  . . ." -f $(Get-Date))
&(Join-Path -Path $package_source -ChildPath $sql_server_express) /x:$sql_server_express_setup /q

Write-Verbose -Message ("[{0}] - Installing xWebAdminitration and xDatabase Module Files  . . ." -f $(Get-Date))
. (Join-Path -Path $PWD.Path -ChildPath "Modules\DSCModuleInstall.ps1")
DSCModuleInstall -WebAdminPath (Join-Path -Path $package_source -ChildPath $WebAdmin_resource)  -DatabasePath (Join-Path -Path $package_source -ChildPath $database_resource)
Start-DscConfiguration -Path .\DSCModuleInstall -Wait -Verbose

Write-Verbose -Message ("[{0}] - Generating AES Encryption Keys  . . ." -f $(Get-Date))
[Reflection.Assembly]::LoadWithPartialName("System.Security") | Out-Null
$aes = New-Object System.Security.Cryptography.RijndaelManaged
$aes.KeySize = 256
$aes.GenerateKey()

Write-Verbose -Message ("[{0}] - Installing PasswordService Web Application  . . ." -f $(Get-Date))
. (Join-Path -Path $PWD.Path -ChildPath "Modules\PasswordServiceInstall.ps1")
$creds = Get-Credential -Message "Please enter the password for the account - administrator" -UserName "administrator"
$opts = @{
    SourcePath        = (Join-Path -Path $package_source -ChildPath $password_service_code)
    InstallPath       = $iis_home
    SQLInstaller      = (Join-Path -Path $sql_server_express_setup  -ChildPath "setup.exe")
    SQLCreationScript = (Join-Path -Path $iis_home                  -ChildPath "Data\PasswordService.dacpac")
    EncryptionKey     = [Convert]::ToBase64String($aes.Key)
    EncryptionIV      = [Convert]::ToBase64String($aes.IV)
    app_pool_password = $creds.GetNetworkCredential().Password
    app_pool_user     = $creds.GetNetworkCredential().UserName
}
PasswordServiceInstall @opts
Start-DscConfiguration -Path .\PasswordServiceInstall -Wait -Verbose
