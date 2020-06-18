# Updating the Helm repository release

## Setup

In fact creating a Helm repository just requires a central defined [index.yaml](../index.yaml) which contains the index of what you want to release.
We have placed this in the root of the repo and enabled Github pages. This makes `https://amsterdam.github.io/openstad-kubernetes/` a repo endpoint.

The release in your repository itself is just a compressed archive (tgz) which is downloaded. Per version supported a new one is placed in k8s/helmrepository and referred to from the index.yaml.

## Tools

Helm has tools built-in to make the work easier:

- [helm package](https://helm.sh/docs/helm/helm_package/) allows you to grab the helm chart and package it as tgz files so you can store it in your repository.
- [helm repo index](https://helm.sh/docs/helm/helm_repo_index/) can create the index file for you.
