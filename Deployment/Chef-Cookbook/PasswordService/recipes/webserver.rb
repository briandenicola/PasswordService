#
# Cookbook Name:: PasswordService
# Recipe:: webserver
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

dsc_script 'Web-Server-Install' do
	code <<-EOH
		WindowsFeature Web-Server
		{
			Ensure = 'Present'
			Name   = 'Web-Server'
		}
		WindowsFeature Web-Default-Doc
		{
			Ensure = 'Present'
			Name   = 'Web-Default-Doc'
		}
		WindowsFeature Web-ASP-Net
		{
			Ensure = 'Present'
			Name   = 'Web-ASP-Net'
		}
		WindowsFeature Web-ASP-Net45
		{
			Ensure = 'Present'
			Name   = 'Web-ASP-Net45'
		}
		WindowsFeature Web-Log-Libraries
		{
			Ensure = 'Present'
			Name   = 'Web-Log-Libraries'
		}
		WindowsFeature Web-Basic-Auth
		{
			Ensure = 'Present'
			Name   = 'Web-Basic-Auth'
		}
		WindowsFeature Web-Windows-Auth
		{
			Ensure = 'Present'
			Name   = 'Web-Windows-Auth'
		}
		WindowsFeature Web-Http-Tracing
		{
			Ensure = 'Present'
			Name   = 'Web-Http-Tracing'
		}
		WindowsFeature Web-Request-Monitor
		{
			Ensure = 'Present'
			Name   = 'Web-Request-Monitor'
		}
		WindowsFeature Web-Mgmt-Tools
		{
			Ensure = 'Present'
			Name   = 'Web-Mgmt-Tools'
		}
		WindowsFeature Web-Scripting-Tools
		{
			Ensure = 'Present'
			Name   = 'Web-Scripting-Tools'
		}
		File IIS86PNG
		{
			Ensure            = "Absent"
			DestinationPath   = "C:\\Inetpub\\wwwroot\\iis-85.png"
		}
		File IISSTART
		{
			Ensure            = "Absent"
			DestinationPath   = "C:\\Inetpub\\wwwroot\\iisstart.htm"
		}
	EOH
end

include_recipe 'iis::remove_default_site'

iis_site 'Default Web Site' do
	action [:stop, :delete]
end

iis_pool 'DefaultAppPool' do
	action [:stop, :delete]
end

site_directory = 'C:\inetpub\sites\PasswordService'

windows_zipfile site_directory do
  source 'https://github.com/bjd145/PasswordService/raw/master/Deployment/Passwords_1.0.0.zip'
  action :unzip
  not_if { ::File.exists?(site_directory) }
end

iis_pool 'PasswordService' do
  runtime_version '4.0'
  action :add
end

directory site_directory do
  rights :read, 'IIS_IUSRS'
  recursive true
  action :create
end

# Create the Customers site.
iis_site 'PasswordService' do
  protocol :http
  port 80
  path site_directory
  application_pool 'PasswordService'
  action [:add, :start]
end

powershell_script 'Enable NTLM Auth' do
  code <<-POWERSHELL
    $ErrorActionPreference = 'Stop'
	Import-Module WebAdministration
	$opts = @{
		Name     = "Enabled"
		Value    = "True"
		PSPath   = "IIS:\"
		Location = "PasswordService"
		Filter   = "/system.webServer/security/authentication/windowsAuthentication"
	}
	Set-WebConfigurationProperty @opts 
  POWERSHELL
end

powershell_script 'Set AESs Key and IV' do
  code <<-POWERSHELL
    $ErrorActionPreference = 'Stop'
	
	[Reflection.Assembly]::LoadWithPartialName("System.Security") | Out-Null
	$aes = New-Object System.Security.Cryptography.RijndaelManaged
	$aes.KeySize = 256
	$aes.GenerateKey()
	
	$webconfig = (Join-Path -Path 'C:\\inetpub\\sites\\PasswordService' -ChildPath "web.Config")
	$xml  = [xml](Get-Content $webconfig)

	$aes_key = $xml.SelectSingleNode("//configuration/appSettings/add[@key='aesKey']")
	if ($aes_key -ne $null) {
		$appSettingsNode = $xml.SelectSingleNode("//configuration/appSettings")
		$appSettingsNode.RemoveChild($aes_key) | Out-Null
	}

	$root = $xml.get_DocumentElement()
	$aes_key = $xml.CreateNode('element',"add","")
	$aes_key.SetAttribute("key", "aesKey")
	$aes_key.SetAttribute("value", [Convert]::ToBase64String($aes.Key) )
	$xml.SelectSingleNode("//configuration/appSettings").AppendChild($aes_key)
	$xml.Save($webconfig)
	
	$aes_iv = $xml.SelectSingleNode("//configuration/appSettings/add[@key='aesIV']")
	if ($aes_iv -ne $null) {
		$appSettingsNode = $xml.SelectSingleNode("//configuration/appSettings")
		$appSettingsNode.RemoveChild($aes_iv) | Out-Null
	}

	$root = $xml.get_DocumentElement()
	$aes_iv = $xml.CreateNode('element',"add","")
	$aes_iv.SetAttribute("key", "aesIV")
	$aes_iv.SetAttribute("value", [Convert]::ToBase64String($aes.IV) )
	$xml.SelectSingleNode("//configuration/appSettings").AppendChild($aes_iv)
	$xml.Save($webconfig)
    
  POWERSHELL
end