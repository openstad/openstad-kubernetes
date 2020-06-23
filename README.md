# Repository for Openstad Kubernetes related material

In this repository we will place the Kubernetes YAML files and the Helm chart for automated full stack deployment.
There are two options of rollout, using a Helm chart which will install every needed component or for advanced users a manual setup using Kubernetes YAML files.

## Helm chart

For quick setup we have a Helm chart defined that can be used to setup a full environment in a Kubernetes environment.

### Helm Preparation

Ensure you have Helm 3 installed.
Checkout this repository and go into `k8s/openstad` directory.

Please ensure that the following is available:

- Ingress Controller : by default any controller can be used but it is tested using Nginx Ingress Controller including integration with Cert-Manager.
- Namespace : A namespace named 'openstad' is created automatically if you add this to the install command, otherwise create it manually.

### Values file

You can adjust the `values.yaml` file to change setup or create a separate file with only the values that are changed.
This file is the high level configuration of the Helm chart.

The setup is created to add configuration and allow to switch on and off dependencies.
For instance if you already have a database installed, this can be adjusted.

```yaml
dependencies:
  mongodb:
    enabled: true
  mysql:
    enabled: true
  cert-manager:
    enabled: false
```

#### Configuration Variables

|  Parameter | Description | Default |
|---|---|---|
|  dependencies.mongodb.enabled | Install and configure MongoDB  | true  |
|  mongodb.usePassword | Use a password to access MongoDB  | false  |
|   |   |   |
|  dependencies.mysql.enabled | Install and configure MySQL  | true  |
|  mysql.db.user |   |   |
|  mysql.db.password |   |   |
|  mysql.db.password |  database for API   |   |
|  mysql.db.password |  database for Auth  |   |
|  mysql.db.password |  database for Image |   |
|   |   |   |
|  dependencies.cert-manager.enabled |  Install Cert-Manager | false |
|   |   |   |
|  host.base | base address of the openstad environment |  openstad.softwaredepartment.net |
|   |   |   |

### Deployment

#### From Source

With the default values you can run the install using this command.

```bash
helm install --replace openstad . --namespace=openstad --create-namespace
```

If you created a separate values file like custom-values.yaml you can add this:

```bash
helm install --values custom-values.yaml --replace openstad . --namespace=openstad --create-namespace
```

#### From Helm repository

In order to install the Helm chart without the need to checkout you can add it as repository.

```bash
helm repo add openstad https://amsterdam.github.io/openstad-kubernetes/
helm repo update
helm search openstad
```

After that you can do the installation using Helm by name of openstad/openstad.

```bash
helm install --replace openstad openstad/openstad --namespace=openstad --create-namespace
```

When using clusters with built-in catalogs you can add the repo catalog directory to the cluster using the UI.
For updating the Helm repository version see the description at [Helm Repository Update](docs/helm_repo_update.md).

### Deletion and Reinstallation

Due to the way the MySQL install works the accounts created are part of the data stored in the Persistent Volume Claims.
When uninstalling the application, the secrets and database storage are still there. So when doing a fresh reinstall the system will use new passwords but old stored data which will clash.

Quick fix here is to delete the namespace and the left-over PVC which removes everything:

```bash
kubectl delete ns openstad
```

## Additional

List of customization items can be found in [Customization](docs/customization.md).
In order to check application issues check the [Troubleshooting document](docs/troubleshooting.md).
A description how to use internal Kubernetes API calls to update Ingress objects is in [Update Ingress](docs/update_ingress.md).
