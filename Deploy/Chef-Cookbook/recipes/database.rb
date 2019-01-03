#
# Cookbook Name:: PasswordService
# Recipe:: database
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'sql_server::server'

create_database_script_path = win_friendly_path(File.join(Chef::Config[:file_cache_path], 'create-database.sql'))

cookbook_file create_database_script_path do
  source 'create-database.sql'
end

sqlps_module_path = ::File.join(ENV['programfiles(x86)'], 'Microsoft SQL Server\110\Tools\PowerShell\Modules\SQLPS')

powershell_script 'Initialize database' do
  code <<-EOH
    Import-Module "#{sqlps_module_path}"
    Invoke-Sqlcmd -InputFile #{create_database_script_path}
  EOH
  guard_interpreter :powershell_script
  only_if <<-EOH
    Import-Module "#{sqlps_module_path}"
    (Invoke-Sqlcmd -Query "SELECT COUNT(*) AS Count FROM sys.databases WHERE name = 'PasswordService'").Count -eq 0
  EOH
end

access_script_path = win_friendly_path(File.join(Chef::Config[:file_cache_path], 'access.sql'))

cookbook_file access_script_path do
  source 'access.sql'
end

powershell_script 'Grant SQL Access to AppPool' do
  code <<-EOH
    Import-Module "#{sqlps_module_path}"
    Invoke-Sqlcmd -InputFile #{access_script_path}
  EOH
  guard_interpreter :powershell_script
   only_if <<-EOH
    Import-Module "#{sqlps_module_path}"
    $sp = Invoke-Sqlcmd -Database PasswordService -Query "EXEC sp_helprotect @username = 'IIS APPPOOL\\PasswordService'"
    ($sp.ProtectType.Trim() -eq 'Grant') -and ($sp.Action.Trim() -eq 'Select')
  EOH
end