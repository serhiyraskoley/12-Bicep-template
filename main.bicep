targetScope = 'subscription'
param resoursePrefix string = 'EleksAzureDevOpsCamp'
param adminUserName string = 'serhiyadmin' 
@description('Location')
param location string = 'eastus'
@description('Operation System')
param os array = [
  'Windows'
  'Linux'
]
@description('Hostname')
param computerName string = 'Webserver'


resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${resoursePrefix}-rg'
  location: location
}

module virtualnetwork 'module/virtual-network.bicep' = {
  scope: rg
  name: 'virtualNetwork'
  params: {
    location: location
  }
}

module vm 'module/virtual-machine.bicep' = [for item in os: {
  scope: rg
  name: '${item}-virtualMachine'
  params: {
    location: location
    computerName: computerName
    os: item
    virtualNetworkName: virtualnetwork.outputs.vnet 
    subnetRef: virtualnetwork.outputs.subnetRef
    adminUsername: adminUserName
  }
}]
