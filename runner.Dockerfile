FROM registry.access.redhat.com/ubi8/ubi-minimal

ARG GITLAB_RUNNER_VERSION

ENV HOME=/home/gitlab-runner \
    GITLAB_RUNNER_VERSION=${GITLAB_RUNNER_VERSION:-"latest"}

WORKDIR $HOME

RUN curl -L https://gitlab-runner-downloads.s3.amazonaws.com/$GITLAB_RUNNER_VERSION/binaries/gitlab-runner-linux-amd64 \
         -o /usr/bin/gitlab-runner && \
    chmod a+x /usr/bin/gitlab-runner && \
    gitlab-runner --version

RUN chgrp -R 0 $HOME && \
    chmod -R g=u $HOME

USER 1001

CMD ["gitlab-runner", "run"]
