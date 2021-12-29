targetScope = 'subscription'
param resoursePrefix string = 'EleksAzureDevOpsCamp'
param adminUserName string = 'serhiyadmin' 
@description('Location')
// @allowed([
//   'eastus'
//   'westus'
// ])
param location string = 'eastus'
@description('Operation System')
// @allowed([
//   'Windows'
//   'Linux'
// ])
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

module vn 'module/virtual-network.bicep' = {
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
    virtualNetworkName: vn.outputs.vnet 
    subnetRef: vn.outputs.subnetRef
    adminUsername: adminUserName
  }
}]
