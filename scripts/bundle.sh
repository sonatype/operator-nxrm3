#!/bin/sh

# built from https://redhat-connect.gitbook.io/partner-guide-for-red-hat-openshift-and-container/certify-your-operator/upgrading-your-operator

# stage a clean bundle directory
rm -rf bundle
mkdir bundle

# copy the crd
cp -v deploy/crds/sonatype.com_nexusrepos_crd.yaml bundle

# copy every version of the csv and the package yaml
cp -rv deploy/olm-catalog/nxrm-operator-certified/* bundle

# distribute crd into each version directory
for d in $(find bundle/* -type d); do
    #cp -v deploy/crds/sonatype.com_nexusrepos_crd.yaml ${d}/nxrm-operator-certified.crd.yaml
    cp -v deploy/crds/sonatype.com_nexusrepos_crd.yaml ${d}
done

# restructure and generate docker file for the bundle
(
    cd bundle;
    latest_version=$(find . -type d -maxdepth 1| sort | tail -1)
    opm alpha bundle generate -d $latest_version -u $latest_version
)

# append more standard labels
cat >> bundle/bundle.Dockerfile <<EOF

LABEL com.redhat.openshift.versions="v4.5,v4.6"
LABEL com.redhat.delivery.backport=true
LABEL com.redhat.delivery.operator.bundle=true
EOF

# build the bundle docker image
(cd bundle; docker build . -f bundle.Dockerfile)

# rm -rf bundle
