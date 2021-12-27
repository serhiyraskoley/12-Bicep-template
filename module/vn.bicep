param location string
param virtualNetworkName string = 'vnet'
param addressPrefixes array = [
  '10.0.0.0/24'
]
param addressPrefix string = '10.0.0.0/24'
param subnetName string = 'default'
param adminUsername string = 'serhiyadmin'
@description('Operation System')
@allowed([
  'Windows'
  'Linux'
])
param os string = 'Windows'

resource virtualNetworkName_resource 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: addressPrefix
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}
module vm 'vm.bicep' = {
  name: 'virtualMachines'
  params: {
    subnetRef: '${virtualNetworkName_resource}/properties/subnets[0]/id'
    adminUsername: adminUsername
    os: os
  }
}

output idvnet string =  virtualNetworkName_resource.properties.subnets[0].id

