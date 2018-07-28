# gcloud-helm

> A container for that contains the [Google Cloud SDK](https://cloud.google.com/sdk/), [Helm](https://helm.sh/), [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) and a few lightweight helpers.

## Getting started

_Pulling the container:_

```sh
docker pull sandcastle/gcloud-helm:latest
```

## Example usage with Gitlab

_An example of how it can be used with gitlab deployments to gcloud:_

```yaml
deploy-staging:
  image: sandcastle/gcloud-helm:latest
  stage: staging
  environment:
    name: staging
    url: https://staging.sandcastle.io/
  when: manual
  variables:
    GCLOUD_KEY_FILE: /tmp/gcloud-api-key.json
    KUBE_NAMESPACE: staging
    HELM_NAME: helloworld
  before_script:
    - echo ${GCLOUD_API_KEYFILE} | base64 -d > ${GCLOUD_KEY_FILE}
    # use of the gcloud cli
    - gcloud auth activate-service-account --key-file ${GCLOUD_KEY_FILE}
    - gcloud beta container clusters get-credentials ${GCLOUD_CLUSTER}
      --region ${GCLOUD_REGION}
      --project ${GCLOUD_PROJECT}
    # use of the kubetool
    - kubetool ns set ${KUBE_NAMESPACE}
    # init of the helm client
    - helm init --client-only
  script:
    - helm upgrade --install ${HELM_NAME}
      --namespace "${KUBE_NAMESPACE}"
      --values ./kube/helloworld/values.yaml
      --set "ingress.domain=staging.sandcastle.io"
      --set "image.tag=latest"
      ./kube/helloworld
```

## Kubetool

> A lightweight (no deps) kubectl wrapper for working with contexts and namespaces,
> heavily inspired by [kubectx](https://github.com/ahmetb/kubectx)

#### Commands

This tool is provide to make the composition of some common `kubectl` calls in build
scripts a lot easier.

The following commands are available:

```
kubetool                    : show this message
kubetool ctx get            : gets the current context
kubetool ctx set NAME       : sets the current context
kubetool ctx ls,list        : lists all of the contexts
kubetool ctx rename OLD NEW : renames a context from the old value to the new valud
kubetool ns get             : get the current namespace for the current context
kubetool ns set NAME        : set the current namespace for the current context
kubetool ns ls,list         : list all namespaces for the current context
kubetool -h,--help          : show this message
```

#### Example

Without the `kubetool` some things like seting the current namespace for the current
context take too much effort:

```sh
KUBE_CTX="$(kubectl config current-context)"
kubectl config use-context "${1}" --namespace="${MY_NAMESPACE}"
```

With the `kubetool`:

```sh
kubetool ns set "${MY_NAMESPACE}"
```

## Contributing

PR's are more than welcome!

:beers: Enjoy!
