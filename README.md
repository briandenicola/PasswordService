This project is an application that I wrote to learn modern application development and deployments.

# Repo Structure
* Clients  - PowerShell and Python modules that be used to call the API instead of using the Web API
* Database - dacpac to create SQL Server schema
* Source - The original Angular1/Web API (.NET 4.5) code base. 
* Deploy - Various Deployment methods for runtime. Includes:
    * Chef cookbooks to deploy to IIS Website on a Windows Server
    * PowerShell DSC methods to deploy to IIS Website on a Windows Server
    * Windows-based Docker Container 
    * Stateless Microservice in Service Fabric




