# Sonatype NXRM Certified Operator

Certified Operator for installing Sonatype Nexus Repository Manager 3 to a 
Kubernetes or OpenShift cluster.

# Building from Source

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
  
To uninstall all the descriptors for the operator, run `scripts/uninstall.sh`.
