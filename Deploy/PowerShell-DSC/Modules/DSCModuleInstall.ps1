Set-Variable -Name dsc_module_path               -Value (Join-Path -Path $ENV:windir -ChildPath "system32\WindowsPowerShell\v1.0\Modules")
Set-Variable -Name webadministration_module_name -Value "xWebAdministration"
Set-Variable -Name database_module_name          -Value "xDatabase"


configuration DSCModuleInstall
{
    param(
        [string] $WebAdminPath,
        [string] $DatabasePath
    )

    Archive WebAdminstation
    {
        Ensure      = "Present"
        Destination = (Join-Path -Path $dsc_module_path -ChildPath $webadministration_module_name)
        Path        = $WebAdminPath
    }

    Archive DatabaseAdministrator
    {
        Ensure      = "Present"
        Destination = (Join-Path -Path $dsc_module_path -ChildPath $database_module_name)
        Path        = $DatabasePath
    }
}
