FROM registry.access.redhat.com/rhel7-atomic

ENV HOME=/home/gitlab-runner

WORKDIR $HOME

RUN microdnf --enablerepo=rhel-7-server-ose-3.11-rpms \
             --enablerepo=rhel-7-server-rpms \
             install atomic-openshift-clients wget git tzdata ca-certificates && \
    microdnf clean all && \
    wget -nv https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 \
         -O /usr/bin/gitlab-runner && \
    chmod a+x /usr/bin/gitlab-runner && \
    gitlab-runner --version && \
    wget -nv https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 \
         -O /usr/bin/dumb-init && \
    chmod a+x /usr/bin/dumb-init && \
    dumb-init --version && \
    wget -nv https://github.com/git-lfs/git-lfs/releases/download/v2.7.2/git-lfs-linux-amd64-v2.7.2.tar.gz \
         -O /tmp/git-lfs.tar.gz && \
    mkdir /tmp/git-lfs && \
    tar -xzf /tmp/git-lfs.tar.gz -C /tmp/git-lfs/ && \
    mv /tmp/git-lfs/git-lfs /usr/bin/git-lfs && \
    rm -rf /tmp/git-lfs* && \
    git-lfs install --skip-repo && \
    git-lfs version && \
    wget -nv https://password.corp.redhat.com/RH-IT-Root-CA.crt \
         -O /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt

RUN update-ca-trust && \
    chgrp -R 0 $HOME && \
    chmod -R g=u $HOME

USER 1000

ENTRYPOINT ["/usr/bin/dumb-init", "gitlab-runner"]
CMD ["run"]
