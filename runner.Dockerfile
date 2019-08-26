FROM registry.access.redhat.com/ubi7/ubi-minimal

ENV HOME=/home/gitlab-runner

WORKDIR $HOME

RUN microdnf --enablerepo=rhel-7-server-ose-3.11-rpms \
             --enablerepo=rhel-7-server-rpms \
             install atomic-openshift-clients tzdata ca-certificates dumb-init && \
    microdnf clean all && \
    curl -L https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 \
         -o /usr/bin/gitlab-runner && \
    chmod a+x /usr/bin/gitlab-runner && \
    gitlab-runner --version

RUN curl -ksL https://url.corp.redhat.com/98bcda0 -o /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt

RUN update-ca-trust && \
    chgrp -R 0 $HOME && \
    chmod -R g=u $HOME

USER 1000

ENTRYPOINT ["/usr/bin/dumb-init", "gitlab-runner"]
CMD ["run"]
