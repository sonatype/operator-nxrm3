# Sonatype NXRM 3 Certified Operator
Red Hat certified OpenShift Operator for installing Sonatype Nexus Repository 
Manager 3 to an OpenShift cluster.

## Building from Source for Local Development and Testing

To develop and test locally, you'll use CodeReady Containers on your workstation
and push your operator image to quay.io to make it available for installation.

1. Install [CodeReady Containers](https://developers.redhat.com/products/codeready-containers/overview)
   for a local Openshift 4 environment.
2. Ensure you have a personal quay.io account.
3. Build and deploy the operator image to your personal quay.io repository:
   1. `docker build . -f build/Dockerfile --tag quay.io/<username>/nxrm-operator-certified:[operator-version]`
   2. `docker login quay.io`
   3. `docker push quay.io/<username>/nxrm-operator-certified:[operator-version]`
5. Make sure the new image on quay.io is public, so that the openshift
   cluster can pull it.
6. Update the `deploy/operator.yaml` to point to your test image at quay.io.
7. Install all the descriptors for the operator to your OpenShift cluster:
   1. `./scripts/install.sh`
8. Expose the new Nexus Repo outside the cluster: 
   1. `kubectl expose deployment --type=NodePort example-nexusrepo-sonatype-nexus`
   2. Create a Route in OpenShift UI to the new service, port 8081.
9. Visit the new URL shown on the Route page in OpenShift UI.
  
## Uninstall NXRM 3 from a Local Test Cluster

1. Remove the route in the console.
2. Remove exposed service in the console.
3. Uninstall all the descriptors for the operator: `./scripts/uninstall.sh`.
