FROM fedora:30

ENV HOME=/home/workspace

WORKDIR $HOME

RUN dnf install -y python3-pip git wget python37 python36 gcc postgresql-devel python3-devel krb5-devel

RUN pip3 install -U pip tox setuptools setuptools-scm pre-commit devpi-client

RUN wget -nv https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    tar -C /tmp -xvf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    rm -f openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    cp /tmp/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/bin

RUN git init

COPY .pre-commit-config.yaml .

RUN pre-commit install-hooks && \
    chmod -R g=u $HOME && \
    chgrp -R 0 $HOME

USER 1000
