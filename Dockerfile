FROM google/cloud-sdk:alpine
LABEL maintainer="Glenn Morton <glenn@sandcastle.io>"

# https://github.com/helm/helm/releases
ENV HELM_VERSION 2.9.1
ENV HELM_FILENAME helm-v${HELM_VERSION}-linux-amd64.tar.gz

RUN gcloud components install alpha beta kubectl

# https://github.com/helm/helm
RUN set -ex \
    && curl -sSL https://storage.googleapis.com/kubernetes-helm/${HELM_FILENAME} | tar xz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf linux-amd64

CMD ["/bin/sh"]
