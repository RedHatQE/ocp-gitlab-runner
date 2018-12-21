FROM fedora:28
RUN dnf install python-pip git wget -y python37
RUN pip install -U pip tox setuptools setuptools-scm pre-commit devpi-client
RUN wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
RUN tar -xvf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
RUN cp ./openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/bin
