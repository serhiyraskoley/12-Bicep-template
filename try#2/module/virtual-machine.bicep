param location string 
param networkInterfaceName string = '${os}-net'
param networkSecurityGroupName string = '${os}-nsg'
param name string = '${os}-ipconfig'
param virtualNetworkName string 
param publicIpAddressName string = '${os}-ip'
param computerName string
param hostname string = '${computerName}1'
param adminUsername string
param os string
param adminPassword string = 'Passw0rd123' 
param enableHotpatching bool = false
param subnetRef string
param publisher string = (os == 'Windows') ? 'MicrosoftWindowsServer' : 'canonical'
param offer string = (os == 'Windows') ? 'WindowsServer' : '0001-com-ubuntu-server-focal'
param sku string = (os == 'Windows') ? '2019-datacenter-gensecond' : '20_04-lts'
param namensg string = (os == 'Windows') ? 'Allow-RDP' : 'Allow-SSH'
param destinationPortRange string = (os == 'Windows') ? '3389' : '22'
var nsgId = resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)

resource networkInterfaceName_resource 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: name
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
    networkSecurityGroupWindows
    publicIpAddressName_resource
  ]
}

resource networkSecurityGroupWindows 'Microsoft.Network/networkSecurityGroups@2019-02-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
              name: namensg
              properties: {
                priority: 1000
                sourceAddressPrefix: '*'
                protocol: 'Tcp'
                destinationPortRange: destinationPortRange
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

// resource networkSecurityGroupLinux 'Microsoft.Network/networkSecurityGroups@2021-05-01' = if (os == 'Linux'){
//   name: networkSecurityGroupName
//   location: location
//   properties: {
//     securityRules: [
//       {
//               name: 'Allow-SSH'
//               properties: {
//                 priority: 1000
//                 sourceAddressPrefix: '*'
//                 protocol: 'Tcp'
//                 destinationPortRange: '22'
//                 access: 'Allow'
//                 direction: 'Inbound'
//                 sourcePortRange: '*'
//                 destinationAddressPrefix: '*'
//             }   
//       }
//     ]
//   }
//   tags: {
//     resoursegroup: '${resourceGroup().name}'
//     environment: os
//   }
// }

resource publicIpAddressName_resource 'Microsoft.Network/publicIpAddresses@2019-02-01' = {
  name: publicIpAddressName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
  sku: {
    name: 'Basic'
  }
  tags: {
    resoursegroup: '${resourceGroup().name}'
    environment: os
  }
}

resource virtualMachineName_resource 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: os
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      imageReference: {
        publisher: publisher
        offer: offer
        sku: sku
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

