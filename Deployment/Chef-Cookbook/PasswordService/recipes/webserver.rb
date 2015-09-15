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

windows_zipfile app_directory do
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