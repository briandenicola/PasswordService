param(
    [string] $DBServer,
    [string] $DB,
    [string] $DBUser,
    [string] $DBPassword
)

$DBConString = "Server={0};Database={1};User Id={2};Password={3};" -f $DBServer, $DB, $DBUser, $DBPassword

[Environment]::SetEnvironmentVariable( "PasswordDbConString", $DBConString, "Machine" )
while ($true) { Start-Sleep -Seconds 3600 }