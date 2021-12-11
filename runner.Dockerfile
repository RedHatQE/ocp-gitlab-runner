ARG GITLAB_RUNNER_VERSION=master

FROM registry.access.redhat.com/ubi8:8.5 AS builder

ARG GITLAB_RUNNER_VERSION

ENV GITLAB_REPO=https://gitlab.com/gitlab-org/gitlab-runner.git \
    PATH=$PATH:/root/go/bin/

RUN dnf install -y git-core make go ncurses && \
    git clone --depth=1 --branch=${GITLAB_RUNNER_VERSION} ${GITLAB_REPO} && \
    cd gitlab-runner && \
    make runner-bin-host && \
    chmod a+x out/binaries/gitlab-runner && \
    out/binaries/gitlab-runner --version

FROM registry.access.redhat.com/ubi8-micro:8.5

ARG GITLAB_RUNNER_VERSION

COPY --from=builder /gitlab-runner/out/binaries/gitlab-runner /usr/bin

ENV HOME=/home/gitlab-runner

LABEL maintainer="Dmitry Misharov <misharov@redhat.com>" \
      version="$GITLAB_RUNNER_VERSION" \
      io.openshift.tags="gitlab,ci,runner" \
      name="ocp-gitlab-runner" \
      io.k8s.display-name="GitLab runner" \
      summary="GitLab runner" \
      description="A GitLab runner image designed to work in OpenShift." \
      io.k8s.description="A GitLab runner image designed to work in OpenShift." \
      url="https://github.com/RedHatQE/ocp-gitlab-runner"

WORKDIR $HOME

RUN chgrp -R 0 $HOME && \
    chmod -R g=u $HOME

USER 1001

CMD ["gitlab-runner", "run"]
