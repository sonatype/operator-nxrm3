# DO NOT MODIFY. This is produced by template.
FROM quay.io/operator-framework/helm-operator:v1.19.1

# Required OpenShift Labels
LABEL name="Nexus Repository Operator" \
      vendor="Sonatype" \
      version="3.38.1" \
      release="1" \
      summary="The Nexus Repository Manager with universal support for popular component formats." \
      description="The Nexus Repository Manager with universal support for popular component formats."

# Required Licenses
COPY licenses /licenses

COPY watches.yaml ${HOME}/watches.yaml
COPY helm-charts/ ${HOME}/helm-charts/
