FROM registry.access.redhat.com/ubi8:8.2 AS builder

ARG GITLAB_RUNNER_VERSION

ENV GITLAB_RUNNER_VERSION=${GITLAB_RUNNER_VERSION:-"master"} \
    GITLAB_REPO=https://gitlab.com/gitlab-org/gitlab-runner.git \
    PATH=$PATH:/root/go/bin/

RUN dnf install -y git make go && \
    git clone --depth=1 --branch=${GITLAB_RUNNER_VERSION} ${GITLAB_REPO} && \
    cd gitlab-runner && \
    make helper-bin-host && \ 
    chmod a+x out/binaries/gitlab-runner-helper/gitlab-runner-helper.x86_64 && \
    out/binaries/gitlab-runner-helper/gitlab-runner-helper.x86_64 --version

FROM registry.access.redhat.com/ubi8-minimal:8.2

COPY --from=builder /gitlab-runner/out/binaries/gitlab-runner-helper/gitlab-runner-helper.x86_64 \
     /usr/bin/gitlab-runner-helper

COPY --from=builder /gitlab-runner/dockerfiles/build/scripts /usr/bin

ENV HOME=/home/workspace

WORKDIR $HOME

RUN microdnf install -y git perl && \
    curl -L https://packagecloud.io/github/git-lfs/packages/el/7/git-lfs-2.11.0-1.el7.x86_64.rpm/download.rpm \
         -o git-lfs-2.11.0-1.el7.x86_64.rpm && \
    rpm -i git-lfs-2.11.0-1.el7.x86_64.rpm && \ 
    microdnf clean all && \
    rm -f git-lfs-2.11.0-1.el7.x86_64.rpm && \
    git lfs install --skip-repo && \
    chgrp -R 0 $HOME && \
    chmod -R g=u $HOME

USER 1001

CMD ["sh"]
