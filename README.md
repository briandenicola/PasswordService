This project is an application that I wrote to learn modern application development and deployments.

# Structure
* Clients  - PowerShell and Python modules that be used to call the API instead of using the Web API
* dotnet46 - The original Angular1/Web API (.NET 4.5) code base. Runtimes include IIS Website on a Windows Server, Azure App Service, Windows-based Docker Container or Stateless Microservice in Service Fabric
* dotnetcore2 - A rewrite of the application to use Angular with .NET Core 2 backed by Cosmosdb Document API

# Todo 
- [x] Restructure repository
- [x] Port main business logic to .Net Core 2
- [ ] Create sample console app to test ideas againist Cosmos DB
- [ ] Store passwords in CosmosDB instead of SQL Server or Azure Table Storage
- [ ] Store password history in json document in Cosmos DB
- [ ] Utilize Comos's change feed to create materialized view of current passwor per site
- [ ] Upate UI from AngularJS v1 to Angular 
- [ ] Create build and deployment pipeline 
