# Intention

Gitlab proposes to deploy the runner using Helm. It requires additional permissions and installed
Helm Tiller. This approach problematically to use in Openshift Container Platform if you don't
have cluster admin privileges. Moreover, default images are not designed to run using an arbitrarily
assigned user ID. This repo contains dockerfiles and an openshift template which allows you to
deploy the gitlab runner in OCP with minimum efforts.

## Contents

### runner.Dockerfile

This image based on UBI8-minimal to minimize the resource consumption. It contains `gitlab-runner`
executable that talks to Gitlab CI and spawns builder pods via `kubernetes` executor.

### helper.Dockerfile

Almost identical to default Gitlab's helper image. Some permission tweaks have been made in order to
run the container using an arbitrarily assigned user ID.

### ocp-gitlab-runner-template.yaml

An Openshift template that creates required objects and deploys the runner with minimum efforts.
Just provide a name, Gitlab instance url, runner's registration token and desired number of
concurrent build pods.

#### Parameters

* NAME

    description: Name of DeploymentConfig and value of "app" label.

    required: true

* GITLAB_HOST

    description: Host of a Gitlab instance.

    required: true

* GITLAB_RUNNER_VERSION

    description: Gitlab runner version, e.g "v12.10.0".

    required: false

* REGISTRATION_TOKEN

    description: Runner's registration token. Base64 encoded string is expected.

    required: true

* CONCURRENT

    description: The maximum number of concurrent CI pods.

    required: true

* RUNNER_TAG_LIST

    description: Tag list.

    required: false

* GITLAB_BUILDER_IMAGE

    description: A default image which will be used in Gitlab CI.

    required: false

* TLS_CA_CERT

    description: A certificate that is used to verify TLS peers when connecting to the GitLab server.
    Base64 encoded string is expected.

    required: false

## Usage

Add and instantiate the template:

```shell
oc process -f ocp-gitlab-runner-template.yaml \
  -p NAME="some_name" \
  -p GITLAB_HOST="example.com" \
  -p REGISTRATION_TOKEN="$(echo -n some_token | base64)" \
  -p CONCURRENT="number_of_concurrent_pods" | oc create -f -
```

Delete all created objects:

```shell
oc delete secret,cm,sa,rolebindings,bc,is,dc -l app=some_name
```
