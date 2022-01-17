@description('Optional. Name of the network watcher resource. Must be in the resource group where the Flow log will be created and same region as the NSG')
param networkWatcherName string = 'NetworkWatcher_${resourceGroup().location}'

@description('Optional. Name of the resource.')
param name string

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. List of connection monitor endpoints.')
param endpoints array = []

@description('Optional. List of connection monitor test configurations.')
param testConfigurations array = []

@description('Optional. List of connection monitor test groups.')
param testGroups array = []

@description('Optional. Specify the Log Analytics Workspace Resource ID')
param workspaceResourceId string = ''

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param telemetryCuaId string = ''

var outputs = !empty(workspaceResourceId) ? [
  {
    type: 'Workspace'
    workspaceSettings: {
      workspaceResourceId: workspaceResourceId
    }
  }
] : null

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

resource networkWatcher 'Microsoft.Network/networkWatchers@2021-03-01' existing = {
  name: networkWatcherName
}

resource connectionMonitor 'Microsoft.Network/networkWatchers/connectionMonitors@2021-03-01' = {
  name: name
  parent: networkWatcher
  tags: tags
  location: location
  properties: {
    endpoints: endpoints
    testConfigurations: testConfigurations
    testGroups: testGroups
    outputs: outputs
  }
}

@description('The name of the deployed connection monitor')
output connectionMonitorName string = connectionMonitor.name

@description('The resource ID of the deployed connection monitor')
output connectionMonitorResourceId string = connectionMonitor.id

@description('The resource group the connection monitor was deployed into')
output connectionMonitorResourceGroup string = resourceGroup().name
