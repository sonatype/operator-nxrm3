# {{templateWarning}}
FROM quay.io/operator-framework/helm-operator@sha256:0e77ef25f57061d9205f82c67b58f084a0e6aa7598d29bc7de7496773d05fa6b

# Required OpenShift Labels
LABEL name="Nexus Repository Operator" \
      vendor="Sonatype" \
      version="{{shortVersion}}" \
      release="1" \
      summary="The Nexus Repository Manager with universal support for popular component formats." \
      description="The Nexus Repository Manager with universal support for popular component formats."

USER root

RUN microdnf update -y \
    && microdnf clean all

# back to helm-operator's user
USER 1001

# Required Licenses
COPY licenses /licenses

COPY watches.yaml ${HOME}/watches.yaml
COPY helm-charts/ ${HOME}/helm-charts/
