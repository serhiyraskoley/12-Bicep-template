param location string = resourceGroup().location
param networkInterfaceName string = '${resourceGroup().name}-net'
param networkSecurityGroupName string = '${os}-nsg'
param publicIpAddressName string = '${os}-IP'
param publicIpAddressType string = 'Dynamic'
param publicIpAddressSku string = 'Basic'
param osDiskType string = 'Premium_LRS'
param virtualMachineSize string = 'Standard_D2s_v3'
param os string
param hostname string = os
param adminUsername string
//@secure()
param adminPassword string = 'Passw0rd123' 
param enableHotpatching bool = false
param subnetRef string 
var nsgId = resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)

resource networkInterfaceWindows 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            //<module-name>.outputs.<property-name>
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
    environment: os
  }
  dependsOn: [
    networkSecurityGroupWindows
    publicIpAddressWindows
    //resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks', 'vmet')
  ]
}

resource networkSecurityGroupWindows 'Microsoft.Network/networkSecurityGroups@2021-05-01' =  {
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
}

resource publicIpAddressWindows 'Microsoft.Network/publicIPAddresses@2021-05-01' =  {
  name: '${os}-publicIP'
  location: location
  properties: {
    publicIPAllocationMethod: publicIpAddressType
  }
  sku: {
    name: publicIpAddressSku
  }
  tags: {
    environment: os
  }
}

resource virtualMachineWindows 'Microsoft.Compute/virtualMachines@2021-07-01' =  {
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
          id: networkInterfaceWindows.id
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
    environment: os
  }
}
// resource networkInterfaceLinux 'Microsoft.Network/networkInterfaces@2021-05-01' = if (os == 'Linux'){
//   name: networkInterfaceName
//   location: location
//   properties: {
//     ipConfigurations: [
//       {
//         name: 'ipconfig1'
//         properties: {
//           subnet: {
//             id: 'default'
//           }
//           privateIPAllocationMethod: 'Dynamic'
//           publicIPAddress: {
//             id: resourceId(resourceGroup().name, 'Microsoft.Network/publicIpAddresses', publicIpAddressName)
//           }
//         }
//       }
//     ]
//     networkSecurityGroup: {
//       id: nsgId
//     }
//   }
//   tags: {
//     environment: hostname
//   }
//   dependsOn: [
//     networkSecurityGroupLinux
//     publicIpAddressLinux
//   ]
// }

// resource publicIpAddressLinux 'Microsoft.Network/publicIPAddresses@2021-05-01' = if (os == 'Linux') {
//   name: '${os}-publicIP'
//   location: location
//   properties: {
//     publicIPAddressVersion: publicIpAddressType
//   }
//   sku: {
//     name: publicIpAddressSku
//   }
//   tags: {
//     environment: hostname
//   }
// }


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
// }



// resource virtualMachineLinux 'Microsoft.Compute/virtualMachines@2021-07-01' = if(os == 'Linux'){
//   name: os
//   location: location
//   properties: {
//     hardwareProfile: {
//       vmSize: virtualMachineSize
//     }
//     storageProfile: {
//       osDisk: {
//         createOption: 'FromImage'
//         managedDisk: {
//           storageAccountType: osDiskType
//         }
//       }
//       imageReference: {
//         publisher: 'canonical'
//         offer: '0001-com-ubuntu-server-focal'
//         sku: '20_04-lts'
//         version: 'latest'
//       }
//     }
//     networkProfile: {
//       networkInterfaces: [
//         {
//           id: networkInterfaceLinux.id
//         }
//       ]
//     }
//     osProfile: {
//       computerName: hostname
//       adminUsername: adminUsername
//       adminPassword: adminPassword
//       windowsConfiguration: {
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
//     environment: hostname
//   }
// }


// output adminUsername string = adminUsername
