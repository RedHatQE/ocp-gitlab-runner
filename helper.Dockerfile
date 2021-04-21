ARG GITLAB_RUNNER_VERSION=master

FROM registry.access.redhat.com/ubi8:8.3 AS builder

ARG GITLAB_RUNNER_VERSION

ENV GITLAB_REPO=https://gitlab.com/gitlab-org/gitlab-runner.git \
    PATH=$PATH:/root/go/bin/

RUN dnf install -y git-core make go ncurses && \
    git clone --depth=1 --branch=${GITLAB_RUNNER_VERSION} ${GITLAB_REPO} && \
    cd gitlab-runner && \
    make helper-bin-host && \
    chmod a+x out/binaries/gitlab-runner-helper/gitlab-runner-helper.x86_64 && \
    out/binaries/gitlab-runner-helper/gitlab-runner-helper.x86_64 --version

FROM registry.access.redhat.com/ubi8-minimal:8.3

ARG GITLAB_RUNNER_VERSION

COPY --from=builder /gitlab-runner/out/binaries/gitlab-runner-helper/gitlab-runner-helper.x86_64 \
     /usr/bin/gitlab-runner-helper

COPY --from=builder /gitlab-runner/dockerfiles/runner-helper/scripts/ /usr/bin

ENV HOME=/home/workspace \
    GITLAB_RUNNER_VERSION=${GITLAB_RUNNER_VERSION:-"master"}

LABEL maintainer="Dmitry Misharov <misharov@redhat.com>" \
      version="$GITLAB_RUNNER_VERSION" \
      io.openshift.tags="gitlab,ci,runner" \
      name="ocp-gitlab-helper" \
      io.k8s.display-name="GitLab helper" \
      summary="GitLab helper" \
      description="A GitLab helper image designed to work in OpenShift." \
      io.k8s.description="A GitLab helper image designed to work in OpenShift." \
      url="https://github.com/RedHatQE/ocp-gitlab-runner"

WORKDIR $HOME

RUN microdnf --disableplugin=subscription-manager install -y hostname git-core git-lfs perl-interpreter --nodocs && \
    microdnf clean all && \
    chgrp -R 0 $HOME && \
    chmod -R g=u $HOME

USER 1001

CMD ["sh"]
