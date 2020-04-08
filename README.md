# Sonatype NXRM 3 Certified Operator
Red Hat certified OpenShift Operator for installing Sonatype Nexus Repository 
Manager 3 to an OpenShift cluster.

## Building from Source for Local Development and Testing

To develop and test locally, you'll use CodeReady Containers on your workstation
and push your operator image to quay.io to make it available for installation.

1. Install [https://developers.redhat.com/products/codeready-containers/overview](CodeReady Containers)
   for a local Openshift 4 environment.
2. Ensure you have a personal quay.io account.
3. Build and deploy the operator image to your personal quay.io repository:
  a. `operator-sdk build quay.io/<username>/nxrm-operator-certified`
  b. `docker login quay.io`
  c. `docker push quay.io/<username>/nxrm-operator-certified`
5. Make sure the new image on quay.io is public.
6. Update the `deploy/operator.yaml` to point to your test image at quay.io.
7. Install all the descriptors for the operator to your OpenShift cluster:
  a. `scripts/install.sh`
8. Expose the new NXRM outside the cluster: 
  a. `kubectl expose deployment --type=NodePort example-nxrm-sonatype-nexus`
  b. Create a Route in OpenShift UI to the new service, port 8081.
9. Visit the new URL shown on the Route page in OpenShift UI.
  
## Uninstall NXRM 3 from a Local Test Cluster

1. Remove the route in the console.
2. Remove exposed service in the console.
3. Uninstall all the descriptors for the operator: `scripts/uninstall.sh`.
