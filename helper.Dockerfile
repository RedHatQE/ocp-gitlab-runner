FROM gitlab/gitlab-runner-helper:x86_64-latest

ENV HOME=/home/workspace

WORKDIR $HOME

RUN chgrp -R 0 $HOME && \
    chmod -R g=u $HOME

USER 1001
