#!/bin/sh

rm -rf bundle
rm -f nxrm-operator-certified-metadata.zip

mkdir bundle

CSVS=$(find deploy/olm-catalog -name '*.clusterserviceversion.yaml')

cp -v $CSVS bundle
cp -v deploy/olm-catalog/nxrm-operator-certified/nxrm-operator-certified.package.yaml bundle
cp -v deploy/crds/sonatype.com_nexusrepos_crd.yaml bundle/nxrm-operator-certified.crd.yaml

(cd bundle; zip -rv ../nxrm-operator-certified-metadata.zip .)

rm -rf bundle
