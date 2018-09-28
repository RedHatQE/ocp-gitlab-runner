FROM fedora:28
RUN dnf install python-pip git -y python37
RUN pip install -U pip tox setuptools setuptools-scm pre-commit
