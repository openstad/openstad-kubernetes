# Repository for OpenStad Kubernetes related material

This repository holds the Kubernetes YAML files and the Helm chart for automated full stack deployment.
There are two options of rollout, using a Helm chart which will install every needed component or for advanced users a manual setup using Kubernetes YAML files.

## Helm chart

For a quick setup we have a Helm chart defined that can be used to set up a full environment in a Kubernetes environment.

### Helm preparation

Ensure you have Helm 3 installed. To use `--create-namespace`, version 3.2.0 or later is required.
Checkout this repository and go into [the `k8s/openstad` directory](./k8s/openstad).

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

## Troubleshooting

List of troubleshooting or customization items can be found in [docs/customization.md]
