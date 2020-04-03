FROM quay.io/operator-framework/helm-operator:v0.16.0

# Required OpenShift Labels
LABEL name="Nexus Repository Manager Operator" \
      vendor="Sonatype" \
      version="3.22.0" \
      release="1" \
      summary="The Nexus Repository Manager with universal support for popular component formats." \
      description="The Nexus Repository Manager with universal support for popular component formats."

COPY watches.yaml ${HOME}/watches.yaml
COPY helm-charts/ ${HOME}/helm-charts/
