@description('Required. The name of the Short Term Retention backup policy. For example "default".')
param name string

@description('Required. The name of the SQL managed instance database')
param databaseName string

@description('Required. Name of the SQL managed instance.')
param managedInstanceName string

@description('Optional. The backup retention period in days. This is how many days Point-in-Time Restore will be supported.')
param retentionDays int = 35

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

resource managedInstance 'Microsoft.Sql/managedInstances@2021-05-01-preview' existing = {
  name: managedInstanceName

  resource managedInstaceDatabase 'databases@2020-02-02-preview' existing = {
    name: databaseName
  }
}

resource backupShortTermRetentionPolicy 'Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies@2017-03-01-preview' = {
  name: name
  parent: managedInstance::managedInstaceDatabase
  properties: {
    retentionDays: retentionDays
  }
}

@description('The name of the deployed database backup short-term retention policy')
output backupShortTermRetentionPolicyName string = backupShortTermRetentionPolicy.name

@description('The resource ID of the deployed database backup short-term retention policy')
output backupShortTermRetentionPolicyResourceId string = backupShortTermRetentionPolicy.id

@description('The resource group of the deployed database backup short-term retention policy')
output backupShortTermRetentionPolicyResourceGroup string = resourceGroup().name
