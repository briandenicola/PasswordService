configuration PasswordServiceInstall
{
    param(
        [string] $SourcePath,
        [string] $InstallPath,
        [string] $SQLInstaller,
        [string] $SQLCreationScript,
        [string] $EncryptionKey,
        [string] $EncryptionIV,
        [string] $app_pool_user,
        [string] $app_pool_password
    )

    Import-DscResource -ModuleName xWebAdministration
    Import-DscResource -ModuleName xDatabase

    Node 'localhost'
    {

        foreach($feature in @(
            "Web-Server", "Web-Default-Doc", "Web-ASP-Net", "Web-ASP-Net45", "Web-Log-Libraries", "Web-Basic-Auth","Web-Windows-Auth","Web-Http-Tracing",
            "Web-Request-Monitor", "Web-Mgmt-Tools","Web-Scripting-Tools","Web-Mgmt-Service","Web-Mgmt-Compat") )
        {
            WindowsFeature $feature
            {
                Ensure = 'Present'
                Name   = $feature
            }

        }

        Archive InstallPasswordCode
        {
            Ensure      = "Present"
            Destination = $InstallPath
            Path        = $SourcePath
        }

        foreach( $file in ("iis-85.png", "iisstart.htm") )
        {
            File $file
            {
                Ensure            = "Absent"
                DestinationPath   = (Join-Path -Path $InstallPath -ChildPath $file)
            }
        }

        Script SetWindowsAuthentication
        {
            SetScript =
            {
                Import-Module WebAdministration
                $opts = @{
                    Name     = "Enabled"
                    Value    = "True"
                    PSPath   = "IIS:\"
                    Location = "Default Web Site"
                    Filter   = "/system.webServer/security/authentication/windowsAuthentication"
                }
                Set-WebConfigurationProperty @opts 
                    
            }

            TestScript =
            {
                return $false
            }

            GetScript =
            {
                return @{
                    GetScript  = $GetScript
                    SetScript  = $SetScript
                    TestScript = $TestScript
                    Result     = false
                }
            }
        }

        Script SetApplicationPoolAccount
        {
            SetScript =
            {
                Import-Module WebAdministration
                $app_pool_path = 'IIS:\AppPools\DefaultAppPool'
                Set-ItemProperty $app_pool_path -Name processModel -Value @{userName=$using:app_pool_user;password=$using:app_pool_password;identitytype=3}
            }

            TestScript =
            {
                return $false
            }

            GetScript =
            {
                return @{
                    GetScript  = $GetScript
                    SetScript  = $SetScript
                    TestScript = $TestScript
                    Result     = false
                }
            }
        }
     

        Script SetAESKey
        {
            SetScript =
            {
                $webconfig = (Join-Path -Path $using:InstallPath -ChildPath "Web.Config")
                $xml  = [xml](Get-Content $webconfig)

                $aes_key = $xml.SelectSingleNode("//configuration/appSettings/add[@key='aesKey']")
                if ($aes_key -ne $null) {
                    $appSettingsNode = $xml.SelectSingleNode("//configuration/appSettings")
                    $appSettingsNode.RemoveChild($aes_key) | Out-Null
                }

                $root = $xml.get_DocumentElement()
                $aes_key = $xml.CreateNode('element',"add","")
                $aes_key.SetAttribute("key", "aesKey")
                $aes_key.SetAttribute("value", $using:EncryptionKey )
                $xml.SelectSingleNode("//configuration/appSettings").AppendChild($aes_key)
                $xml.Save($webconfig)
            }

            TestScript =
            {
                return $false
            }

            GetScript =
            {
                return @{
                    GetScript  = $GetScript
                    SetScript  = $SetScript
                    TestScript = $TestScript
                    Result     = false
                }
            }
        }

        Script SetAESIV
        {
            SetScript =
            {
                $webconfig = (Join-Path -Path $using:InstallPath -ChildPath "Web.Config")
                $xml  = [xml](Get-Content $webconfig)

                $aes_iv = $xml.SelectSingleNode("//configuration/appSettings/add[@key='aesIV']")
                if ($aes_iv -ne $null) {
                    $appSettingsNode = $xml.SelectSingleNode("//configuration/appSettings")
                    $appSettingsNode.RemoveChild($aes_iv) | Out-Null
                }

                $root = $xml.get_DocumentElement()
                $aes_iv = $xml.CreateNode('element',"add","")
                $aes_iv.SetAttribute("key", "aesIV")
                $aes_iv.SetAttribute("value", $using:EncryptionIV )
                $xml.SelectSingleNode("//configuration/appSettings").AppendChild($aes_iv)
                $xml.Save($webconfig)
            }

            TestScript =
            {
                return $false
            }

            GetScript =
            {
                return @{
                    GetScript  = $GetScript
                    SetScript  = $SetScript
                    TestScript = $TestScript
                    Result     = false
                }
            }
        }

        Package SQLServerExpress
        {
            Ensure    = 'Present'
            Name      = 'SQL Server 2012 Express'
            Path      = $SQLInstaller
            ProductId = '7f121c35-f095-47aa-bc04-d214bc04727a'
            Arguments = '/Action=Install /q /IAcceptSQLServerLicenseTerms /InstanceName=MSSQLSERVER /ROLE=AllFeatures_WithDefaults /SQLSYSADMINACCOUNTS="BUILTIN\Administrators" /TCPENABLED=1'
        }

        xDatabase DeployDacPac
        {
            Ensure                = "Present"
            SqlServer             = "localhost"
            SqlServerVersion      = "2012"
            DatabaseName          = "PasswordService"
            DacPacPath            =  $SQLCreationScript
            DacPacApplicationName = "PasswordService"
        }

    }
}
