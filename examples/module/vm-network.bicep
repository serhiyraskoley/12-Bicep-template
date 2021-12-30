param location string 
param networkInterfaceName string = '${os}-net'
param networkSecurityGroupName string = '${os}-nsg'
param name string = '${os}-ipconfig'
// param virtualNetworkName string 
param publicIpAddressName string = '${os}-ip'
// param computerName string
// param hostname string = '${computerName}1'
// param adminUsername string
param os string
// param adminPassword string = 'Passw0rd123' 
param enableHotpatching bool = false
param subnetRef string
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
    // resourceGroup('Microsoft.Network/virtualNetworks', virtualNetworkName)
    networkSecurityGroup
    publicIpAddressName_resource
  ]
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-02-01' = {
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

// resource virtualMachineWindows 'Microsoft.Compute/virtualMachines@2021-07-01' = if (os == 'Windows'){
//   name: os
//   location: location
//   properties: {
//     hardwareProfile: {
//       vmSize: 'Standard_D2s_v3'
//     }
//     storageProfile: {
//       osDisk: {
//         createOption: 'FromImage'
//         managedDisk: {
//           storageAccountType: 'Premium_LRS'
//         }
//       }
//       imageReference: {
//         publisher: 'MicrosoftWindowsServer'
//         offer: 'WindowsServer'
//         sku: '2019-datacenter-gensecond'
//         version: 'latest'
//       }
//     }
//     networkProfile: {
//       networkInterfaces: [
//         {
//           id: networkInterfaceName_resource.id
//         }
//       ]
//     }
//     osProfile: {
//       computerName: hostname
//       adminUsername: adminUsername
//       adminPassword: adminPassword
//       windowsConfiguration: {
//         enableAutomaticUpdates: false
//         provisionVMAgent: true
//         patchSettings: {
//           enableHotpatching: enableHotpatching
//           patchMode: 'Manual'
//         }
//       }
//     }
//     diagnosticsProfile: {
//       bootDiagnostics: {
//         enabled: true
//       }
//     }
//   }
//   tags: {
//     resoursegroup: '${resourceGroup().name}'
//     environment: os
//   }
// }

// resource virtualMachinesLinux 'Microsoft.Compute/virtualMachines@2021-07-01' = if (os == 'Linux'){
//   name: os
//   location: location
//   properties: {
//     hardwareProfile: {
//       vmSize: 'Standard_D2s_v3'
//     }
//     storageProfile: {
//       imageReference: {
//         publisher: 'canonical'
//         offer: '0001-com-ubuntu-server-focal'
//         sku: '20_04-lts'
//         version: 'latest'
//       }
//       osDisk: {
//         // osType: virtualMachines_Linux_name
//         // name: '${virtualMachines_Linux_name}_disk1_aa4a3d97a9aa4ab6b7339553dd04ce9a'
//         createOption: 'FromImage'
//         // caching: 'ReadWrite'
//         managedDisk: {
//           storageAccountType: 'Premium_LRS'
//           // id: resourceId('Microsoft.Compute/disks', '${virtualMachines_Linux_name}_disk1_aa4a3d97a9aa4ab6b7339553dd04ce9a')
//         }
//         deleteOption: 'Detach'
//         diskSizeGB: 30
//       }
//       dataDisks: []
//     }
//     osProfile: {
//       computerName: hostname
//       adminUsername: adminUsername
//       linuxConfiguration: {
//         disablePasswordAuthentication: false
//         provisionVMAgent: true
//         patchSettings: {
//           patchMode: 'ImageDefault'
//           assessmentMode: 'ImageDefault'
//         }
//       }
//       secrets: []
//       allowExtensionOperations: true
//       requireGuestProvisionSignal: true
//     }
//     networkProfile: {
//       networkInterfaces: [
//         {
//           id: networkInterfaceName_resource.id
//         }
//       ]
//     }
//     diagnosticsProfile: {
//       bootDiagnostics: {
//         enabled: true
//       }
//     }
//   }
// }

