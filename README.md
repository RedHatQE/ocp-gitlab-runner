Intention
=========

Gitlab proposes to deploy the runner using Helm. It requires additional permissions and installed
Helm Tiller. This approach problematically to use in Openshift Container Platform if you don't
have cluster admin privileges. Moreover, default images are not designed to run using an arbitrarily
assigned user ID. This repo contains dockerfiles and an openshift template which allows you to
deploy the gitlab runner in OCP with minimum efforts. 


Contents
========


## runner.Dockerfile

This image based on UBI7-minimal to minimize the resource consumption. Contains `gitlab-runner`
executable that talks to Gitlab CI and spawns builder pods via `kubernetes` executor. Besides it
includes an internal Red Hat IT root certificate.


## helper.Dockerfile

Almost identical to default Gitlab's helper image. Some permission tweaks have been made in order to
run the container using an arbitrarily assigned user ID.


## builder.Dockerfile

A default IQE builder image. It contains all packages required for Insights QE CI process.


## iqe-gitlab-runner-template.yaml

An Openshift template that creates required objects and deploys the runner with minimum efforts.
Just provide a name, Gitlab instance url, runner's registration token and desired number of
concurrent build pods.
