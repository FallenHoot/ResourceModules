@description('Required. ID of the Cosmos DB database account.')
param databaseAccountName string

@description('Required. Name of the SQL database ')
param name string

@description('Optional. Array of containers to deploy in the SQL database.')
param containers array = []

@description('Optional. Request units per second')
param throughput int = 400

@description('Optional. Tags of the SQL database resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param telemetryCuaId string = ''

resource pid_cuaId 'Microsoft.Resources/deployments@2021-04-01' = if (!empty(telemetryCuaId)) {
  name: 'pid-${telemetryCuaId}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2021-07-01-preview' existing = {
  name: databaseAccountName
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-06-15' = {
  name: name
  parent: databaseAccount
  tags: tags
  properties: {
    resource: {
      id: name
    }
    options: {
      throughput: throughput
    }
  }
}

module container 'containers/deploy.bicep' = [for container in containers: {
  name: '${uniqueString(deployment().name, sqlDatabase.name)}-sqldb-${container.name}'
  params: {
    databaseAccountName: databaseAccountName
    sqlDatabaseName: name
    name: container.name
    paths: container.paths
    kind: container.kind
  }
}]

@description('The name of the SQL database.')
output sqlDatabaseName string = sqlDatabase.name

@description('The resource ID of the SQL database.')
output sqlDatabaseResourceId string = sqlDatabase.id

@description('The name of the resource group the SQL database was created in.')
output sqlDatabaseResourceGroup string = resourceGroup().name
