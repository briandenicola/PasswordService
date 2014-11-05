#requires -version 3

Set-Variable -Name service_credentials -Value ([System.Management.Automation.PSCredential]::Empty) -Option AllScope
Set-Variable -Name passwordlist -Value @()
Set-Variable -Name password_server -Value "10.2.1.235"

$password_urls = New-Object PSObject -Property @{
    PasswordList="http://$password_server/api/passwords/"
    PasswordDetails="http://$password_server/api/passwords/{0}"
}

$password_output = New-Object PSObject -Property @{
}

$password_error_data = New-Object PSObject -Property @{
    NoServiceAccountName="No Service Account was found of Name : {0}"
    NoPasswordofId="No Password was found of ID : {0}."
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
        [Parameter(ParameterSetName="Name",Mandatory=$true)]
        [string] $name,

        [Parameter(ParameterSetName="ID",Mandatory=$true)]
        [int] $id,

        [Parameter(ParameterSetName="Object",Mandatory=$true, ValueFromPipeline=$true)]
        [System.Management.Automation.PSObject] $password
    )

    begin { 
        $password_details = @()
    }

    process {

        if($PsCmdlet.ParameterSetName -eq "Name") {
            $id = Get-Passwords | Where { $_.Name -eq $Name } | Select -ExpandProperty PasswordId

            if(!$id) {
                throw ($password_error_data.NoServiceAccountName -f $name)
            }
        }
        elseif($PsCmdlet.ParameterSetName -eq "Object" ) {
            $id = $password.PasswordId
        }

        $response = Invoke-RestMethod -Method Get -Uri ($password_urls.PasswordDetails -f $id) -Credential (__Get-PasswordServiceCredentials)

        if(!$response) {
            throw ($password_error_data.NoPasswordofId -f $id)
        }
    }
    end {
        return $response
    }
}

function New-Password
{
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [System.Management.Automation.PSObject] $password
    )

    begin {
    }
    process {
        $response = Invoke-RestMethod -Method Post -Uri $password_urls.PasswordList -Credential (__Get-PasswordServiceCredentials) -Body $password
    }
    end {
        return $response 
    }
}

function Update-Password 
{
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [System.Management.Automation.PSObject] $password
    )

    begin {
    }
    process {
        $reponse = Invoke-RestMethod -Method Put -Uri ($password_urls.PasswordDetails -f $password.PasswordId) -Credential (__Get-PasswordServiceCredentials) -Body ($password | ConvertTo-Json) -ContentType "application/json"
    }
    end {
        return $reponse
    }

}

Export-ModuleMember -Function Get-Passwords, Get-Password, Get-PasswordChecks, New-Password, Update-Password 