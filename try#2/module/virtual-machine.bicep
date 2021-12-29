param location string 
param networkInterfaceName string = '${resourceGroup().name}-net'
param networkSecurityGroupName string = '${resourceGroup().name}-nsg'
param virtualNetworkName string 
param publicIpAddressName string = 'windows3-ip'
param publicIpAddressType string = 'Dynamic'
param publicIpAddressSku string = 'Basic'
param osDiskType string = 'Premium_LRS'
param virtualMachineSize string = 'Standard_D2s_v3'
param computerName string
param hostname string = '${computerName}1'
param adminUsername string
param os string
param adminPassword string = 'Passw0rd123' 
param enableHotpatching bool = false
param subnetRef string
var nsgId = resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)

resource networkInterfaceName_resource 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId(resourceGroup().name, 'Microsoft.Network/publicIpAddresses', publicIpAddressName)
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgId
    }
  }
  tags: {
    resoursegroup: '${resourceGroup().name}'
    environment: os
  }
  dependsOn: [
    resourceGroup('Microsoft.Network/virtualNetworks', virtualNetworkName)
    networkSecurityGroupName_resource
    publicIpAddressName_resource
  ]
}

resource networkSecurityGroupName_resource 'Microsoft.Network/networkSecurityGroups@2019-02-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
              name: 'Allow-RDP'
              properties: {
                priority: 1000
                sourceAddressPrefix: '*'
                protocol: 'Tcp'
                destinationPortRange: '3389'
                access: 'Allow'
                direction: 'Inbound'
                sourcePortRange: '*'
                destinationAddressPrefix: '*'
            }   
      }
    ]
  }
  tags: {
    resoursegroup: '${resourceGroup().name}'
    environment: os
  }
}

resource publicIpAddressName_resource 'Microsoft.Network/publicIpAddresses@2019-02-01' = {
  name: publicIpAddressName
  location: location
  properties: {
    publicIPAllocationMethod: publicIpAddressType
  }
  sku: {
    name: publicIpAddressSku
  }
  tags: {
    resoursegroup: '${resourceGroup().name}'
  }
}

resource virtualMachineName_resource 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: os
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-datacenter-gensecond'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceName_resource.id
        }
      ]
    }
    osProfile: {
      computerName: hostname
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: false
        provisionVMAgent: true
        patchSettings: {
          enableHotpatching: enableHotpatching
          patchMode: 'Manual'
        }
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
  tags: {
    resoursegroup: '${resourceGroup().name}'
    environment: os
  }
}

