#requires -version 3

Set-Variable -Name service_credentials -Value ([System.Management.Automation.PSCredential]::Empty) -Option Private
Set-Variable -Name passwordlist -Value @()

$password_urls = New-Object PSObject -Property @{
    PasswordList="http://10.2.1.235/api/passwords/"
    PasswordDetails="http://10.2.1.235/api/passwords/{0}"
}

$password_output = New-Object PSObject -Property @{
}

$password_error_data = New-Object PSObject -Property @{ 
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
    if( $passwordlist.Length -eq 0 ) {
        $passwordlist = Invoke-RestMethod -Method Get -Uri $password_urls.PasswordList -Credential (__Get-PasswordServiceCredentials)
    }

    return $passwordlist
}

function Get-Password
{
    param (
        [Parameter(Mandatory=$true)]
        [int] $id
    )

    return (Invoke-RestMethod -Method Get -Uri ($password_urls.PasswordDetails -f $id) -Credential (__Get-PasswordServiceCredentials))
}

function New-Password
{
    param (
        [Parameter(Mandatory=$true)]
        [Hashtable] $password
    )

    return (Invoke-RestMethod -Method Post -Uri $password_urls.PasswordList -Credential (__Get-PasswordServiceCredentials) -Body $password)
}

function Update-Password 
{
    param (
        [Parameter(Mandatory=$true)]
        [int] $id,
        [Parameter(Mandatory=$true)]
        [Hashtable] $password
    )

    return (Invoke-RestMethod -Method Put -Uri ($password_urls.PasswordDetails -f $id) -Credential (__Get-PasswordServiceCredentials) -Body ($password | ConvertTo-Json) -ContentType "application/json")
}

Export-ModuleMember -Function Get-Passwords, Get-Password, Get-PasswordChecks, New-Password, Update-Password 