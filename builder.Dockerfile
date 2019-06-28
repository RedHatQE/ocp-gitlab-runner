FROM fedora:30

ENV HOME=/home/workspace

WORKDIR $HOME

RUN dnf install -y \
        origin-clients \
        python3-pip \
        git \
        wget \
        python37 \
        python36 \
        gcc \
        postgresql-devel \
        python3-devel \
        make \
        krb5-devel && \
    dnf clean all

RUN pip3 install -U pip tox setuptools setuptools-scm pre-commit devpi-client

RUN git init

COPY .pre-commit-config.yaml .

RUN pre-commit install-hooks && \
    chmod -R g=u $HOME && \
    chgrp -R 0 $HOME

USER 1000
