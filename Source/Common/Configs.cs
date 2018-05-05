using Microsoft.Extensions.Configuration;

namespace PasswordService.Common
{
	public class AzureTableSettings
    {
		public string connectionString { get; private set; }
		public string tableName { get; private set; }
		public string partitionKey { get; private set; }

		public AzureTableSettings(IConfiguration configuration)
		{
			connectionString = configuration.GetSection("AzureStorageConnectionString").Value;
			tableName = configuration.GetSection("AzureStorageTableName").Value;
			partitionKey = configuration.GetSection("PartitionKey").Value;
		}
    }

	public class AzureQueueSettings
	{
		public string connectionString { get; private set; }
		public string queueName { get; private set; }

		public AzureQueueSettings(IConfiguration configuration)
		{
			connectionString = configuration.GetSection("AzureStorageConnectionString").Value;
			queueName = configuration.GetSection("AzureStorageQueueName").Value;
		}
	}
}
