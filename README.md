# Repository for OpenStad Kubernetes related material

This repository holds the Kubernetes YAML files and the Helm chart for automated full stack deployment of [the components of OpenStad](https://github.com/Amsterdam/openstad-docs/blob/master/technical/README.md).
There are two options of rollout, using a Helm chart which will install every needed component or for advanced users a manual setup using Kubernetes YAML files.

## Helm chart

For a quick setup we have a Helm chart defined that can be used to set up a full environment in a Kubernetes environment.

### Helm preparation

Ensure you have Helm 3 installed. To use `--create-namespace`, version 3.2.0 or later is required.
Checkout this repository and go into [the `k8s/openstad` directory](./k8s/openstad).

Please ensure that the following is available:

- Ingress Controller : by default any controller can be used but it is tested using Nginx Ingress Controller including integration with Cert-Manager.
- Namespace : A namespace named 'openstad' is created automatically

### Values file

You can adjust [the `values.yaml` file](./k8s/openstad/values.yaml) to change setup, or create a separate file with only the values that are changed.
This file is the high level configuration of the Helm chart.

The setup is created to add configuration and allow to switch on and off dependencies.
For instance if you already have a database installed, this can be skipped.

```yaml
dependencies:
  mongodb:
    enabled: true
  mysql:
    enabled: true
  cert-manager:
    enabled: false
```

### Deployment

With the default `values.yaml` file you can run the install using this command:

```bash
cd k8s/openstad
helm dependency update
helm install --replace openstad . --namespace=openstad --create-namespace
```

If you created an additional custom values file, like `custom-values.yaml`, then you can add this:

```bash
helm install --values custom-values.yaml --replace openstad . --namespace=openstad --create-namespace 
```

## Additional

List of troubleshooting or customization items can be found in [docs/customization.md]
A description how to use internal Kubernetes API calls to update Ingress objects is in [docs/update_ingress.md]
