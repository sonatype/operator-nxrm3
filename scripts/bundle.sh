#!/bin/sh

if [ $# != 3 ]; then
    cat <<EOF
Usage: $0 <bundleNumber> <projectId> <apiKey>
    bundleNumber: appended to version to allow rebuilds, usually 1
    projectId: project id from Red Hat bundle project
    apiKey: api key from Red Hat bundle project
EOF

    exit 1
fi

bundleNumber=$1
projectId=$2
apiKey=$3

set -x -e

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
    cp -v deploy/crds/sonatype.com_nexusrepos_crd.yaml ${d}
done

# restructure and generate docker file for the bundle

cd bundle;

# TODO sort will only work to a point
latest_version=$(find . -type d -maxdepth 1| sort | tail -1 | sed 's!\./!!')
echo $latest_version
opm alpha bundle generate -d $latest_version -u $latest_version
mv bundle.Dockerfile bundle-$latest_version.Dockerfile

# append more labels
cat >> bundle-$latest_version.Dockerfile <<EOF
LABEL com.redhat.openshift.versions="v4.5,v4.6"
LABEL com.redhat.delivery.backport=true
LABEL com.redhat.delivery.operator.bundle=true
EOF

# build the bundle docker image
docker build . \
       -f bundle-$latest_version.Dockerfile \
       -t nxrm-operator-certified-bundle:$latest_version

docker tag \
       nxrm-operator-certified-bundle:$latest_version \
       scan.connect.redhat.com/${projectId}/nxrm-certified-operator-bundle:${latest_version}-${bundleNumber}

# push to red hat scan service
echo $apiKey | docker login -u unused --password-stdin scan.connect.redhat.com
docker push \
       scan.connect.redhat.com/${projectId}/nxrm-certified-operator-bundle:${latest_version}-${bundleNumber}
