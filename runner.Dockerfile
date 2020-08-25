FROM registry.access.redhat.com/ubi8:8.2 AS builder

ARG GITLAB_RUNNER_VERSION

ENV GITLAB_RUNNER_VERSION=${GITLAB_RUNNER_VERSION:-"master"} \
    GITLAB_REPO=https://gitlab.com/gitlab-org/gitlab-runner.git \
    PATH=$PATH:/root/go/bin/

RUN dnf install -y git make go && \
    git clone --depth=1 --branch=${GITLAB_RUNNER_VERSION} ${GITLAB_REPO} && \
    cd gitlab-runner && \
    make runner-bin-host && \ 
    chmod a+x out/binaries/gitlab-runner && \
    out/binaries/gitlab-runner --version

FROM registry.access.redhat.com/ubi8-minimal:8.2

COPY --from=builder /gitlab-runner/out/binaries/gitlab-runner /usr/bin

ENV HOME=/home/gitlab-runner

WORKDIR $HOME

RUN chgrp -R 0 $HOME && \
    chmod -R g=u $HOME

USER 1001

CMD ["gitlab-runner", "run"]
