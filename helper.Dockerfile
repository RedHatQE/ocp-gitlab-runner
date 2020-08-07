FROM gitlab/gitlab-runner-helper:x86_64-448c28a9

ENV HOME=/home/workspace

WORKDIR $HOME

RUN chgrp -R 0 $HOME && \
    chmod -R g=u $HOME

USER 1001
