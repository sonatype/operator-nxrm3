# Sonatype NXRM 3 Certified Operator

Certified Operator for installing Sonatype Nexus Repository Manager 3 to a 
Kubernetes or OpenShift cluster.

## Building from Source to a Local Test Cluster

1. Build and deploy the operator image to quay.io:
  a. `operator-sdk build quay.io/jflinchbaugh/nxrm-operator-certified`
  b. `docker login quay.io`
  c. `docker push quay.io/jflinchbaugh/nxrm-operator-certified`
2. Install all the descriptors for the operator to your Kubernetes/OpenShift 
   cluster:
  a. `scripts/install.sh`
3. Expose the new NXRM outside the cluster: 
  a. `kubectl expose deployment --type=NodePort example-nxrm-sonatype-nexus`
  b. Create a Route in OpenShift to the new service, port 8081.
  
## Uninstall NXRM 3 from a Local Test Cluster

1. Remove the route in the console.
2. Remove exposed service in the console.
3. Uninstall all the descriptors for the operator: `scripts/uninstall.sh`.
