#requires -version 3

Set-Variable -Name service_credentials -Value ([System.Management.Automation.PSCredential]::Empty) -Option AllScope
Set-Variable -Name passwordlist -Value @()

$password_urls = New-Object PSObject -Property @{
    PasswordList="https://api.password.com/api/passwords"
    PasswordDetails="https://api.password.com/api/passwords/{0}"
}

$password_output = New-Object PSObject -Property @{
}

$password_error_data = New-Object PSObject -Property @{ 
    NoAppName="No password was found of Name : {0}."  
    NoAppId="No password was found of ID : {0}."
}

function __Get-PasswordServiceCredentials 
{
    if($service_credentials -eq [System.Management.Automation.PSCredential]::Empty) {
        $service_credentials = Get-Credential ( $env:USERDOMAIN + "\" + $env:USERNAME )
    }
    return $service_credentials
}

function Get-Passwords
{
    if( $passwordlist -eq @() ) {
        $passwordlist = Invoke-RestMethod -Method Get -Uri $password_urls.PasswordList -Credential (__Get-PasswordServiceCredentials)
    }

    return $passwordlist
}

function Get-Password
{
    param (
        [int] $id
    )

    return (Invoke-RestMethod -Method Get -Uri ($password.PasswordDetails -f $id) -Credential (__Get-PasswordServiceCredentials))
}

function Create-NewPassword
{
    param (
        [Hashtable] $password
    )

    return (Invoke-RestMethod -Method Post -Uri $password.PasswordList -Credential (__Get-PasswordServiceCredentials) -Body $password)
}

function Update-Password 
{
    param (
        [int] $id,
        [Hashtable] $password
    )

    return (Invoke-RestMethod -Method Put -Uri ($password.PasswordDetails -f $id) -Credential (__Get-PasswordServiceCredentials) -Body ($password | ConvertTo-Json) -ContentType "application/json")
}

Export-ModuleMember -Function Get-Passwords, Get-Password, Get-passwordChecks, Create-NewPassword, Update-Password 