param(
    [string] $SFCluster,             #xyzcontainers.westus.cloudapp.azure.com:19000
    [string] $clusterCertThumbprint, #201B82B89554D4E7FE351D8EEBDA137C157AF581
    [string] $adminCertThumbprint    #9200D3AACFD4BDE77A013A506EA92045A4C18440
)

Import-Module "$ENV:ProgramFiles\Microsoft SDKs\Service Fabric\Tools\PSModule\ServiceFabricSDK\ServiceFabricSDK.psm1"

$PackageRoot  = ".\ApplicationPackageRoot"
$AppType      = "PasswordAppType"
$AppName      = "passwordapp"
$ServiceName  = "service001"
$ServiceType  = "PasswordDBApiPkgType"
$Version      = "1.0.0"
$InstanceCont = 1

Connect-ServiceFabricCluster -ConnectionEndpoint $SFCluster `
    -X509Credential -ServerCertThumbprint $clusterCertThumbprint `
    -FindType FindByThumbprint -FindValue $adminCertThumbprint `
    -StoreLocation CurrentUser -StoreName 'My'

Copy-ServiceFabricApplicationPackage -ApplicationPackagePath $PackageRoot `
    -ApplicationPackagePathInImageStore $AppType `
    -ImageStoreConnectionString (Get-ImageStoreConnectionStringFromClusterManifest(Get-ServiceFabricClusterManifest)) `
    -TimeoutSec 1800

Register-ServiceFabricApplicationType $AppType

New-ServiceFabricApplication fabric:/$AppName $AppType $Version

New-ServiceFabricService -Stateless -PartitionSchemeSingleton -ApplicationName fabric:/$AppName `
    -ServiceName fabric:/$AppName/$ServiceName `
    -ServiceTypeName $ServiceType -InstanceCount $InstanceCont 

