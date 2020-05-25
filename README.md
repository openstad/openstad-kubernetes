# Repository for Openstad Kubernetes related material

In this repository we will place the Kubenernetes YAML files and the Helm chart for automated full stack deployment.
There are two options of rollout, using a Helm chart which will install every needed component or for advanced users a manual setup using Kubernetes YAML files.

## Kubernetes YAML files

### Dependency

The application requires to have a MySQL database and a MongoDB database installed within the same namespace.
Name of these endpoints is standardized to `mysql' and 'mongo' so as long as the resources are findable by these names no modifications are needed.
If the name is different, because of shared instances in or even outside the cluster, names of the databases must be configured in the db secrets later.

If you want to setup your databases yourself quickly we recommend installing it through helm, which is also part of the full install.

```bash
helm repo add https://mysql.repo
helm repo add https://mongo.repo
helm install mysql
helm install mongodb
```

After the installs please not the secrets in which the accounts are created for the databases and the names of the database since you will need that later for manual configuration in the database secrets.

### Preparation

In k8s/ you will find the basic setup files for the environment but they can need some manual adjustments to make it work, can best be rolled out in this order:

- Secrets
- ConfigMaps

> For those wondering why the different elements have been sorted by type, this is to make their functions easier to grasp for beginners.

### Installation

```bash
kubectl apply -f secrets/ configmaps/ deployments/ services/
```

You can validate the setup using the command `kubectl get podx 

## Helm chart

For quick setup we have a Helm chart defined that can be used to setup a full environment in a Kubernetes environment.

### Helm Preparation

### Value file

### Deployment
