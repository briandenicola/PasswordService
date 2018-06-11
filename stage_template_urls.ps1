$path = Join-Path -Path $PWD.Path -ChildPath "V1\Source\PasswordService.Web.Ui\template"
$hostname = "vault.denicolafamily.com"
$url = "https://{0}/template" -f $hostname
$ip = [System.Net.Dns]::GetHostAddresses($hostname)| Select-Object -ExpandProperty  IPAddressToString

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Output ("[{0}] - {1} resolves to {2}" -f $(Get-Date), $hostname, $ip)
Get-ChildItem -Include *.html -Path $path -Recurse | 
    ForEach-Object {
        if($_.Directory.BaseName -eq "template") {
            Invoke-WebRequest -UseBasicParsing -Uri ("{0}/{1}" -f $url,$_.Name) -Verbose | Select-Object -Expand StatusCode
        }
        else {
            Invoke-WebRequest -UseBasicParsing -Uri ("{0}/{1}/{2}" -f $url,$_.Directory.BaseName, $_.Name) -Verbose |  Select-Object -ExpandProperty StatusCode
        }
    }