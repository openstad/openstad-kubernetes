# Customizing Helm install

In order to tailor the install based on your specific environment or wishes you can apply some customizations.
Knowledge of the Kubernetes system and some of the components in it is required to do this successfully.

## Use your own databases

By default the Helm chart installs MySQL and MongoDB. In some cases these databases are already installed in the cluster or are available as a separate service.
In the values sepcification it is possible to stop automatic installation of the databases and ways to configure this manually to use other systems.
When the automatic installation is disabled, you have to supply database endpoints.

In the values.yaml these are the default settings.

```yaml
dependencies:
  ## Database
  mongodb:
    enabled: true
  mysql:
    enabled: true
```

Disabling it would require you to add a custom values file with the setting to false.
Configuring the database endpoints you have to overwrite these secrets specifications

```yaml
secrets:
  database:
    user: openstad
    password: examplePass2146
    hostname: abcd
```

## Existing LetsEncrypt

In some cases LetsEncrypt is already available and configured on your cluster.
There is no need to add an extra installation as long as the version is current.

It can be configured through:

```yaml
dependencies:
  ## Database
  letsencrypt:
    enabled: true
```

When settings this up separately you can define another ClusterIssuer email address for better maintainability.

```yaml
clusterIssuer:
  enabled: false  # Whether this issuer is created
  acme:           # Email used for requesting the certificates
    email: info@openstad.org
```

> Default setting on LetsEncrypt is the staging environment which installs the fake certificate.
> Please use this wil setting up until you are satisfied with the result and then switch to the production environment.
> Update thew Helm chart with this value adjustment.
>
> ```yaml
>  ingress:
>    annotations:
>      cert-manager.io/cluster-issuer: letsencrypt-production
> ```

## Using cluster-issuer from the Helm Chart

To be able to use the cluster issuer provided by this Helm Chart you first have to install the required CRD's. Currently this process is not automated. Please install the Helm Chart first with: 
```
$ helm install openstad . --namespace openstad --create-namespace --set clusterIssuer.enabled=false
```
After the Chart is installed, wait for about a minute to let everything process, and after that you can enable the cluster issuer with the following command:
```
$ helm upgrade openstad . --namespace openstad --set clusterIssuer.enabled=true
```

## Install without domain name

Initially you might not have the final hostname available or the option to quickly change it to the cluster Ingress IP LoadBalancer address.
However that does not have to stop you. These are the options available:

### Using a public IP address

If your cluster has a public IP address but you do not have an IP address available you can use xip.io.
You have to do the following two steps:

- Retrieve the IP Address of the Ingress to the outside, for instance 1.2.3.4
- Register as base hostname 1.2.3.4.xip.io, and then all subdomains under it will work as well.

### Using a private IP address

On your own machine you need something publically available to make DNS work and to ensure that you can request HTTPS.
There is a tunnel service available for developers that can supply this called [https://ngrok.com/](https://ngrok.com/).
It will allow you to create a tunnel to your cluster so it will have a public IP address.
For setup please read the NGrok manual at [https://ngrok.com/docs](https://ngrok.com/docs).

### Scalability

To create multiple replicas of any service, find an appropriate section (frontend, adminer, auth, api, image) in values.conf and change

```yaml
  replicas: 1
```

with a desired value.

---
Replication of frontend and image services might not work properly on some hosts. It's caused by persistent volume limitations and depends on supported storage class. Possible way to workaround it in future releases is using ScaleIO plugin.
---

