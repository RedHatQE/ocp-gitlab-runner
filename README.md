# Intention

Gitlab proposes to deploy the runner using Helm or GitLab operator. It requires additional
permissions. This approach problematically to use in OpenShift Container Platform if you don't have
cluster admin privileges. Moreover, default images are not designed to run using an arbitrarily
assigned user ID. This repo contains dockerfiles and an OpenShift template which allows you to
deploy the GitLab runner in OCP with minimum efforts.

## Usage

1. Clone required version, e.g. `v13.3.0`:

    ```shell
    git clone --depth=1 --branch=v13.3.0 https://github.com/RedHatQE/ocp-gitlab-runner
    ```

    You can also try to use `master` but it might not working due to the changes in
    `https://gitlab.com/gitlab-org/gitlab-runner`.

2. Add and instantiate the template:

    ```shell
    oc process -f ocp-gitlab-runner/ocp-gitlab-runner-template.yaml \
    -p NAME="some_name" \
    -p GITLAB_HOST="example.com" \
    -p REGISTRATION_TOKEN="$(echo -n some_token | base64)" \
    -p CONCURRENT="number_of_concurrent_pods" | oc create -f -
    ```

In order to delete all created objects:

```shell
oc delete secret,cm,sa,rolebindings,bc,is,dc -l app=some_name
```

## Contents

### runner.Dockerfile

This image based on `registry.access.redhat.com/ubi8-minimal`. It contains `gitlab-runner`
executable that talks to GitLab CI and spawns builder pods via `kubernetes` executor.

### helper.Dockerfile

GitLab's helper image with `gitlab-runner-helper` executable. The image based on
`registry.access.redhat.com/ubi8-minimal`.

### ocp-gitlab-runner-template.yaml

An OpenShift template that creates required objects and deploys the runner with minimum efforts.
Just provide a name, GitLab instance host, runner's registration token and desired number of
concurrent build pods.

#### Parameters

* NAME

    description: Name of DeploymentConfig and value of "app" label.

    required: true

* GITLAB_HOST

    description: Host of a GitLab instance.

    required: true

* GITLAB_RUNNER_VERSION

    description: GitLab runner version, e.g "v13.1.2".

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

    description: A default image which will be used in GitLab CI.

    required: false

* TLS_CA_CERT

    description: A certificate that is used to verify TLS peers when connecting to the GitLab
    server. Base64 encoded string is expected.

    required: false

* TEMPLATE_CONFIG_FILE

    description: A patch for config.toml which will be applied during runner registration. Details
    in https://docs.gitlab.com/runner/register/#runners-configuration-template-file

    required: false

* TEMPLATE_REPO

    description: A repo url with this template. It might be useful for development puproses.
    required: false

* TEMPLATE_REF

    description: A ref of the repo with this template. It might be useful for development puproses.
    required: false
