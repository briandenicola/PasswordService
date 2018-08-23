using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Table;
using PasswordService.Common;

namespace PasswordService.Services
{
    public class AzureTableRepository<T> where T : TableEntity , new()
	{
		private static AzureTableSettings _settings;
		private static CloudTableClient _client;
		private static CloudStorageAccount _cloudStorageAccount;
		private static CloudTable _table;
		private static string _partitionKey;

		public AzureTableRepository(AzureTableSettings settings)
		{
			_settings = settings;
			_partitionKey = _settings.partitionKey;
		}

		private async Task<CloudTable> GetTableAsync() {
			_cloudStorageAccount = CloudStorageAccount.Parse(_settings.connectionString);
			_client = _cloudStorageAccount.CreateCloudTableClient();
			_table = _client.GetTableReference(_settings.tableName);
			await _table.CreateIfNotExistsAsync();
			return _table;
		}

		public async Task<T> GetItemAsync(string id)
		{
			CloudTable table = await GetTableAsync();
			TableOperation retrieveOperation = TableOperation.Retrieve<T>(_partitionKey, id);
			TableResult result = await table.ExecuteAsync(retrieveOperation);

			if (result.Result != null ) {
				return (T)result.Result;
			}
			else {
				return null;
			}
		}

		public async Task<IList<T>> GetItems()
		{
			CloudTable table = await GetTableAsync();
			TableQuery<T> query = new TableQuery<T>().Where(TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, _partitionKey));
			TableContinuationToken token = null;
			var items = new List<T>();

			do
			{
				TableQuerySegment<T> seg = await table.ExecuteQuerySegmentedAsync<T>(query, token);
				token = seg.ContinuationToken;
				items.AddRange(seg);
			} while (token != null);

			return items;
		}

		public async Task<T> CreateItemAsync(T item)
		{
			CloudTable table = await GetTableAsync();
			item.PartitionKey = _partitionKey;
			TableOperation insertOperation = TableOperation.Insert(item);
			return (T)(await table.ExecuteAsync(insertOperation)).Result;
		}

		public async Task<T> UpdateItemAsync(string id, T item)
		{
			CloudTable table = await GetTableAsync();
			TableOperation retrieveOperation = TableOperation.Retrieve<T>(_partitionKey, id);
			TableResult result = await table.ExecuteAsync(retrieveOperation);

			item.PartitionKey = _partitionKey;
			item.RowKey = id;
			item.ETag = "*";

			if (result.Result != null)
			{
				TableOperation replaceOperation = TableOperation.Replace(item);
				return (T)(await table.ExecuteAsync(replaceOperation)).Result;
			}
			else
			{
				return null;
			}
		}

		public async Task<T> DeleteItemAsync(string id)
		{
			CloudTable table = await GetTableAsync();
			TableOperation retrieveOperation = TableOperation.Retrieve<T>(_partitionKey, id);
			TableResult result = await table.ExecuteAsync(retrieveOperation);

			if (result.Result != null)
			{
				TableOperation deleteOperation = TableOperation.Delete((T)result.Result);
				return (T)(await table.ExecuteAsync(deleteOperation)).Result;
			}
			else
			{
				return null;
			}
		}

	}
}
