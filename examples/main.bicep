targetScope = 'subscription'
param resoursePrefix string = 'EleksAzureDevOpsCamp'
@description('Location')
@allowed([
  'eastus'
  'westus'
])
param location string = 'eastus'
@description('Operation System')
@allowed([
  'Windows'
  'Linux'
])
param os string = 'Windows'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${resoursePrefix}-rg'
  location: location
}

module vn 'module/virtualnetwork.bicep' = {
  scope: resourceGroup('EleksAzureDevOpsCamp-rg')
  name: 'virtualNetwork'
  params: {
    location: location
  }
  dependsOn: [
    rg
  ]
}

module vm 'module/virtualmachine.bicep' = {
  scope: resourceGroup('EleksAzureDevOpsCamp-rg')
  name: 'virtualMachines'
  params: {
    adminUsername: 'serhiyadmin'
    os: os
    subnetRef: vn.outputs.idvnet
  }
  dependsOn: [
    vn
  ]
}


