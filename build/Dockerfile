FROM quay.io/operator-framework/helm-operator:v0.15.1

# Required OpenShift Labels
LABEL name="Sonatype NXRM Operator" \
      vendor="Sonatype" \
      version="v0.0.0" \
      release="1" \
      summary="This is a sonatype nxrm operator." \
      description="This operator will deploy an operator for Nexus Repositroy Manager."

# Required Licenses
COPY licenses /licenses

COPY watches.yaml ${HOME}/watches.yaml
COPY helm-charts/ ${HOME}/helm-charts/
