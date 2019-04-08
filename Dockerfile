FROM fedora:28
RUN dnf install -y python-pip git wget python37 postgresql-devel
RUN pip install -U pip tox setuptools setuptools-scm pre-commit devpi-client
RUN wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
RUN tar -xvf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
RUN cp ./openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/bin
