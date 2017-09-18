param(
    [string] $SFCluster  #xyzcontainers.westus.cloudapp.azure.com:19000
)

Import-Module "$ENV:ProgramFiles\Microsoft SDKs\Service Fabric\Tools\PSModule\ServiceFabricSDK\ServiceFabricSDK.psm1"

$PackageRoot  = ".\ApplicationPackageRoot"
$AppType      = "ServiceFabricContainerProjectType"
$AppName      = "ServiceFabricContainerProject"
$ServiceName  = "PasswordDBApiPkg"
$ServiceType  = "PasswordDBApiType"
$Version      = "1.0.0"
$InstanceCont = 1

Connect-ServiceFabricCluster -ConnectionEndpoint $SFCluster

Copy-ServiceFabricApplicationPackage -ApplicationPackagePath $PackageRoot `
    -ApplicationPackagePathInImageStore $AppType `
    -ImageStoreConnectionString (Get-ImageStoreConnectionStringFromClusterManifest(Get-ServiceFabricClusterManifest)) `
    -TimeoutSec 1800

Register-ServiceFabricApplicationType $AppType

New-ServiceFabricApplication fabric:/$AppName $AppType $Version

New-ServiceFabricService -Stateless -PartitionSchemeSingleton -ApplicationName fabric:/$AppName `
    -ServiceName fabric:/$AppName/$ServiceName `
    -ServiceTypeName $ServiceType -InstanceCount $InstanceCont 

