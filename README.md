# Repository for Openstad Kubernetes related material

In this repository we will place the Kubenernetes YAML files and the Helm chart for automated full stack deployment.
There are two options of rollout, using a Helm chart which will install every needed component or for advanced users a manual setup using Kubernetes YAML files.

## Helm chart

For quick setup we have a Helm chart defined that can be used to setup a full environment in a Kubernetes environment.

### Helm Preparation

Ensure you have Helm 3 installed.
Checkout this repository and go into `k8s/openstad-chart` directory.

### Values file

You can adjust the `values.yaml` file to change setup or create a separate file with only the values that are changed.
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

With the default values you can run the install using this command.

```bash
helm install --replace openstad-chart . --namespace=openstad --create-namespace 
```

If you created a separate values file like custom-values.yaml you can add this:

```bash
helm install --values custom-values.yaml --replace openstad-chart . --namespace=openstad --create-namespace 
```

## Troubleshooting

List of troubleshooting or customization items can be found in [docs/customization.md]
