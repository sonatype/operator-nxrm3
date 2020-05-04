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
   1. `operator-sdk build quay.io/<username>/nxrm-operator-certified`
   2. `docker login quay.io`
   3. `docker push quay.io/<username>/nxrm-operator-certified`
5. Make sure the new image on quay.io is public, so that the openshift
   cluster can pull it.
6. Update the `deploy/operator.yaml` to point to your test image at quay.io.
7. Install all the descriptors for the operator to your OpenShift cluster:
   1. `scripts/install.sh`
8. Expose the new Nexus Repo outside the cluster: 
   1. `kubectl expose deployment --type=NodePort example-nexusrepo-sonatype-nexus`
   2. Create a Route in OpenShift UI to the new service, port 8081.
9. Visit the new URL shown on the Route page in OpenShift UI.
  
## Uninstall NXRM 3 from a Local Test Cluster

1. Remove the route in the console.
2. Remove exposed service in the console.
3. Uninstall all the descriptors for the operator: `scripts/uninstall.sh`.

## Building for Production

1. Build the docker image for Red Hat repository:
   `operator-sdk build registry.connect.redhat.com/sonatype/nxrm-operator-certified`
2. Follow the "Upload Your Image" instructions with IDs provided at
   https://connect.redhat.com/project/3843071/view to login and push
   your docker image.
   1. `[image-id]` can be collected from `docker images`
   2. `[image-name]` is `nxrm-operator-certified`
   3. `[tag]` is the next version that's not already there in the form: `3.22.1-1`
3. Package and upload metadata to Operator Config
   1. Create the bundle zip file: `./scripts/bundle.sh`
   2. Upload the zip to "Operator Config" of
     https://connect.redhat.com/project/3843071/view
   3. Once it successfully scans, which can take up to an hour. Publish the config.
