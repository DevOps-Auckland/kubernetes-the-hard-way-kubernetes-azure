param deploymentlocation string
targetScope = 'subscription'

resource kubernetesClusterGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'kubernetes-cluster'
  location: deploymentlocation
  properties: {

  }
}

module networkModule 'modules/network.bicep' = {
  name: 'kubernetes-the-hard-way-network'
  scope: resourceGroup(kubernetesClusterGroup.name)
  params: {
    location: deploymentlocation
  }
}
