# Sonatype NXRM 3 Certified Operator
Red Hat certified OpenShift Operator for installing Sonatype Nexus Repository 
Manager 3 to an OpenShift cluster.

## Building from Source for Local Development and Testing

To develop and test locally, you'll use CodeReady Containers on your workstation
and push your operator image to quay.io to make it available for installation.

1. Install [Red Hat OpenShift Local](https://developers.redhat.com/products/codeready-containers/overview) (formerly known as CodeReady Containers)
   for a local Openshift 4 environment.
2. Ensure you have a personal quay.io account.
3. Generate a new version of the operator image using the templates under test:
   `./scripts/new_version.sh image <new-operator-version> <cert-app-image-version>`

   Example: `./scripts/new_version.sh image 3.41.1-1  3.41.1-1` (*)
4. Build and deploy the operator image to your personal quay.io repository:
   1. `docker build . -f build/Dockerfile --tag quay.io/<username>/nxrm-operator-certified:[operator-version]`
   2. `docker login quay.io`
   3. `docker push quay.io/<username>/nxrm-operator-certified:[operator-version]`
5. Make sure the new image on quay.io is public, so that the OpenShift
   cluster can pull it. You should have **nxrm-operator-certified** repository with public visibility.
6. Update the bundle files for the new image:
   ` ./scripts/new_version.sh bundle <new-operator-version> <operator-image-id> <certified-app-image-id>`

   Example: `./scripts/new_version.sh bundle 3.41.1-1 quay.io/{quay.io-account}/nxrm-operator-certified:3.41.1-1 registry.connect.redhat.com/sonatype/nxrm-operator-bundle@sha256:{sha256}` (*)
7. Install all the descriptors for the operator to your OpenShift cluster:
   1. `./scripts/install.sh`
   2. By executing `kubectl get pods` you should see a pod running in Openshift:

		`example-nexusrepo-sonatype-nexus-{id}`
8. Expose the new Nexus Repo outside the cluster: 
   1. Create a Route in OpenShift UI to the new service, port 8081.
   2. Create a Route in OpenShift UI to the new service, using:
      
      **Port:** 8081 -> 8081.

      **Service:** example-nexusrepo-sonatype-nexus-service
9. Visit the new URL shown on the Route page in OpenShift UI.

(*) You can get the tag of Nexus Repository Certified Image from the [Red Hat Catalog](https://catalog.redhat.com/software/containers/sonatype/nxrm-operator-bundle/5f7b7a8becb5245089512dd9?container-tabs=gti). And the image id from the **Manifest List Digest**.
  
## Uninstall NXRM 3 from a Local Test Cluster

1. Remove the route in the console.
3. Uninstall all the descriptors for the operator: `./scripts/uninstall.sh`.
