FROM fedora:30
RUN dnf install -y python3-pip git wget python37 python36 gcc postgresql-devel python3-devel
RUN pip3 install -U pip tox setuptools setuptools-scm pre-commit devpi-client
RUN wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    tar -C /tmp -xvf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    rm -f openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    cp /tmp/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/bin
WORKDIR see-me
RUN git init
COPY .pre-commit-config.yaml .
RUN pre-commit install-hooks
