#!/bin/sh

if [ $# != 3 ]; then
    echo "Usage: $0 <shortVersion> <certAppVersion> <operatorVersion>"
    echo "Ex: $0 3.20.0 3.20.0-ubi-1 3.20.0-1"
    exit 1
fi

shortVersion=$1
certAppVersion=$2
operatorVersion=$3

replacedOperatorVersion=$(cat deploy/olm-catalog/nxrm-operator-certified/nxrm-operator-certified.package.yaml \
    | grep currentCSV: | sed 's/.*v//')

function applyTemplate {
    sed "s/{{shortVersion}}/${shortVersion}/g" \
    | sed "s/{{certAppVersion}}/${certAppVersion}/g" \
    | sed "s/{{operatorVersion}}/${operatorVersion}/g" \
    | sed "s/{{replacedOperatorVersion}}/${replacedOperatorVersion}/g"
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
