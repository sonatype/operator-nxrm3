#!/bin/sh

rm -rf bundle

mkdir bundle

CSV_SOURCE=$(find deploy/olm-catalog/ -name '*.clusterserviceversion.yaml')

echo $CSV_SOURCE

cp -v deploy/olm-catalog/nxrm-operator-certified/nxrm-operator-certified.package.yaml bundle/nxrm-operator-certified.package.yaml
cp -v deploy/crds/sonatype.com_nexusrepos_crd.yaml bundle/nxrm-operator-certified.crd.yaml
cp -v $CSV_SOURCE bundle/

(cd bundle; zip -rv ../nxrm-operator-certified-metadata.zip .)

rm -rf bundle
