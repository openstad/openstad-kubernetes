> :warning: **This is a work in progress**: Not finished yet

Prerequisites:
- Kubectl (1 version within digital ocean cluster version)
- Helm (version 3)

Main commands are kubectl and helm.

## 1 Create a Kubernetes Cluster in Digital Ocean
Select at least 6 nodes for a dev cluster. This will take a few minutes.

## 2 Add Config of cluster to your local machine
Once your cluster installed you can download the config file and set it to your kubectl config
If you have no cluster yet you can set the config file to the default cluster:
$HOME/.kube/config

Learn how to set up multiple config files here:
https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/#explore-the-home-kube-directory


## 3 Install nginx-ingress
Most cloud providers come with a load balancer for ingress. For digital ocean this needs to be installed.

```
helm install nginx-ingress stable/nginx-ingress --set controller.publishService.enabled=true
```

## 4 Set your DNS
Once nginx0ngress is installed DO gives you a public IP. This is Visible in your dashboard.

Or with following commands

```
kubectl get svc
```

You should see something like this, look for External IP of the  ingress controller:
```
NAME                            TYPE           CLUSTER-IP       EXTERNAL-IP       PORT(S)                      AGE
kubernetes                      ClusterIP      10.999.0.1       <none>            443/TCP                      27h
nginx-ingress-controller        LoadBalancer   10.999.9.229     134.999.137.123   80:30694/TCP,443:31648/TCP   27h
nginx-ingress-default-backend   ClusterIP      10.999.223.138   <none>            80/TCP                       27h
```


Setting records for following domains

- www.*domainname.com*
- www.api.*domainname.com*
- www.auth.*domainname.com*
- www.admin.*domainname.com*
- www.img.*domainname.com*

Advantage of first setting up domains is that Let's Encrypt configures the SSL certificates immediately.

If you have no domain, an alternative is xip.io which sends certain domain names automatically to your IP. For instance

- www.api.*178.128.136.92.xip.io*
- www.auth.*178.128.136.92.xip.io*


## Configure your custom values
Go to k8s/openstad directory.

Copy values.yaml and configure values. Create a custom-values.yaml and set the pr corresponding to

- Set correct base domain
```
## Settings for DNS
host:
  ### Base URL of the web app
  ### subdomains will be prefixed with a .
  ### to this url
  ### e.g. subdomain.example.com
  base: openstad.baboom.nl
```

- update custom mysql password
- check which containers are set, latest one currently is development (and devel for application), but be aware these are auto pushed on git updates, so it might break every know and then

## First installation
On first install keep certissuer to false;

```
## Settings for Cert-Manager/Cluster issuer
clusterIssuer:
  enabled: false  # Whether this issuer is created

```

```
helm install --values custom-values.yaml --replace openstad . --namespace=openstad --create-namespace
```

## Upgrade for SSL to work
Wait a few minutes till all pods are running then enable certificates.

This way you can you check if the pods are all running
```
kubectl get pods -n openstad
```

If all are running enable clusterIssuer in custom-values.

```
## Settings for Cert-Manager/Cluster issuer
clusterIssuer:
  enabled: true  # Whether this issuer is created

```
Run upgrade command:

```
helm upgrade  -f custom-values.yaml openstad . -n openstad
```

What to expect: Domains configured should now run with standard CMS.
Currently fixtures are not being set properly.
Easy way to access the database to set correct config in database

```
kubectl port-forward -n openstad svc/openstad-adminer 8111:8080
```

After the command has started stating `Forwarding from 127.0.0.1:8111 -> 8080` you can open your browser to [http://localhost:8111/](http://localhost:8111/).

Password and user are defined in your values.

## Some other commands

```
helm upgrade openstad . --namespace openstad --values c-values.yaml --kubeconfig=config.yaml
```

```
kubectl set image deployment/openstad-admin openstad-admin=openstad/admin:700636910 --record -n openstad
```

```
helm upgrade  -f custom-values.yaml openstad . -n openstad
```

```
helm upgrade -f c-values.yaml openstad . -n openstad
```

```
helm get values openstad -n openstad
```

Port forwarding to access in local browser:
```
kubectl port-forward <pod_name> <local_port>:<pod_port>
kubectl port-forward openstad-admin-ccf84f977-r4b5c 9999:7777
```
This way you can acces adminer in local browser

## How to add your own container?
Current config assumes a public docker hub

In config yaml:
```
deploymentContainer:
  name: api-container
  # Docker image for this pod
  image: dockerhub/container:tag
```
