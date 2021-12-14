#!/bin/sh

if [ $# -lt 1 ]; then
    echo "Usage: $0 image <operatorVersion> <certAppVersion>"
    echo "Usage: $0 bundle <operatorVersion> <operatorImageSHA> <certAppImageSHA>"
    echo "Ex: $0 image 3.20.0-1 3.20.0-ubi-1"
    echo "Ex: $0 bundle 3.20.0-1 registry...@sha256:ab12... registry...@sha256:ab12..."
    exit 1
fi

stage=$1

shortVersion=$(echo $2 | sed 's/-.*//')

if [ "$1" = "image" ]; then
    if [ $# -ne 3 ]; then
        echo "Usage: $0 image <operatorVersion> <certAppVersion>"
        echo "Ex: $0 image 3.20.0-1 3.20.0-ubi-1"
        exit 1
    fi

    operatorVersion=$2
    certAppVersion=$3

    function applyTemplate {
        sed "s!{{shortVersion}}!${shortVersion}!g" \
        | sed "s!{{certAppVersion}}!${certAppVersion}!g" \
        | sed "s!{{operatorVersion}}!${operatorVersion}!g" \
        | sed "s!{{templateWarning}}!DO NOT MODIFY. This is produced by template.!g"
    }

    cat scripts/templates/Chart.yaml \
        | applyTemplate > helm-charts/sonatype-nexus/Chart.yaml

    cat scripts/templates/values.yaml \
        | applyTemplate > helm-charts/sonatype-nexus/values.yaml

    cat scripts/templates/Dockerfile \
        | applyTemplate > build/Dockerfile
fi

if [ "$1" = "bundle" ]; then
    if [ $# -ne 4 ]; then
        echo "Usage: $0 bundle <operatorVersion> <operatorImageSHA> <certAppImageSHA>"
        echo "Ex: $0 bundle 3.20.0-1 registry...@sha256:ab12... registry...@sha256:ab12..."
        exit 1
    fi

    operatorVersion=$2
    operatorSHA=$3
    certAppSHA=$4

    function applyTemplate {
        sed "s!{{shortVersion}}!${shortVersion}!g" \
        | sed "s!{{certAppSHA}}!${certAppSHA}!g" \
        | sed "s!{{operatorSHA}}!${operatorSHA}!g" \
        | sed "s!{{operatorVersion}}!${operatorVersion}!g" \
        | sed "s!{{templateWarning}}!DO NOT MODIFY. This is produced by template.!g"
    }

    cat scripts/templates/nxrm-operator-certified.package.yaml \
        | applyTemplate \
        > deploy/olm-catalog/nxrm-operator-certified/nxrm-operator-certified.package.yaml

    [ ! -d "deploy/olm-catalog/nxrm-operator-certified/${operatorVersion}/manifests" ] \
        && mkdir -p "deploy/olm-catalog/nxrm-operator-certified/${operatorVersion}/manifests"

    [ ! -d "deploy/olm-catalog/nxrm-operator-certified/${operatorVersion}/metadata" ] \
        && mkdir -p "deploy/olm-catalog/nxrm-operator-certified/${operatorVersion}/metadata"

    cat scripts/templates/annotations.yaml \
        | applyTemplate \
        > "deploy/olm-catalog/nxrm-operator-certified/${operatorVersion}/metadata/annotations.yaml"

    cat scripts/templates/nxrm-operator-certified.clusterserviceversion.yaml \
        | applyTemplate \
        > "deploy/olm-catalog/nxrm-operator-certified/${operatorVersion}/manifests/nxrm-operator-certified.clusterserviceversion.yaml"

    cat scripts/templates/sonatype.com_nexusrepos_crd.yaml \
        | applyTemplate \
        > "deploy/olm-catalog/nxrm-operator-certified/${operatorVersion}/manifests/sonatype.com_nexusrepos_crd.yaml"

    cat scripts/templates/operator.yaml | applyTemplate > deploy/operator.yaml

    cat scripts/templates/sonatype.com_v1alpha1_nexusrepo_cr.yaml \
        | applyTemplate > deploy/crds/sonatype.com_v1alpha1_nexusrepo_cr.yaml

fi
