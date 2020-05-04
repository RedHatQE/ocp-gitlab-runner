FROM registry.access.redhat.com/ubi8/ubi-minimal

ENV HOME=/home/gitlab-runner

WORKDIR $HOME

RUN curl -L https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 \
         -o /usr/bin/gitlab-runner && \
    chmod a+x /usr/bin/gitlab-runner && \
    gitlab-runner --version

RUN chgrp -R 0 $HOME && \
    chmod -R g=u $HOME

USER 1000

CMD ["gitlab-runner", "run"]
