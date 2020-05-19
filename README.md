# Repository for Openstad Kubernetes related material

In this repository we will place the Kubenernetes YAML files and the Helm chart for automated full stack deployment.

## Kubernetes YAML files

### Dependency


### Preparation
In k8s/ you will find the basic setup files for the environment but they will need some manual adjustments to make it work, and need to be rolled out in this order:

- Secrets
- ConfigMaps

> For those wondering why the different elements have been sorted by type, this is to make their functions easier to grasp for beginners.

### Installation

```
kubectl apply -f secrets/ configmaps/ deployments/ services/ ingress/


## Helm chart

For quick setup we have a Helm chart defined that can be used to setup a full environment in a Kubernetes environment.

### Preparation


### Value file



### Deployment




