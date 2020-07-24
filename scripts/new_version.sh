#!/bin/sh

if [ $# != 4 ]; then
    echo "Usage: $0 <shortVersion> <ubiVersion> <operatorVersion> <oldOperatorVersion>"
    echo "Ex: $0 3.20.0 3.20.0-ubi-1 3.20.0-1 3.19.0-1"
    exit 1
fi

shortVersion=$1
ubiVersion=$2
operatorVersion=$3
oldOperatorVersion=$4

function applyTemplate {
    sed "s/{{shortVersion}}/${shortVersion}/g" \
    | sed "s/{{ubiVersion}}/${ubiVersion}/g" \
    | sed "s/{{operatorVersion}}/${operatorVersion}/g" \
    | sed "s/{{oldOperatorVersion}}/${oldOperatorVersion}/g"
}

cat scripts/templates/Chart.yaml \
    | applyTemplate > helm-charts/sonatype-nexus/Chart.yaml

cat scripts/templates/Dockerfile \
    | applyTemplate > build/Dockerfile

cat scripts/templates/nxrm-operator-certified.package.yaml \
    | applyTemplate \
    > deploy/olm-catalog/nxrm-operator-certified/nxrm-operator-certified.package.yaml

if [ ! -d "deploy/olm-catalog/nxrm-operator-certified/${operatorVersion}" ]; then
    mkdir "deploy/olm-catalog/nxrm-operator-certified/${operatorVersion}"
fi

cat scripts/templates/nxrm-operator-certified.vX.X.X-X.clusterserviceversion.yaml \
    | applyTemplate \
    > "deploy/olm-catalog/nxrm-operator-certified/${operatorVersion}/nxrm-operator-certified.v${operatorVersion}.clusterserviceversion.yaml"

cat scripts/templates/operator.yaml | applyTemplate > deploy/operator.yaml

cat scripts/templates/sonatype.com_v1alpha1_nexusrepo_cr.yaml \
    | applyTemplate > deploy/crds/sonatype.com_v1alpha1_nexusrepo_cr.yaml

cat scripts/templates/values.yaml \
    | applyTemplate > helm-charts/sonatype-nexus/values.yaml
