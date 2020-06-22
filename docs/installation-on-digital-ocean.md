> :warning: **This is a work in progress**: Not finished yet

Prerequisites:
- Kubectl (1 version within digital ocean cluster version)
- Helm (version 3)

Main commands are kubectl and helm.

## 1 Create a Kubernetes Cluster in Digital Ocean

Screenshot offi


Select at least 6 nodes for a dev cluster.
This will take a few minutes.

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

- www.openstad.*domainname.com*
- www.api.openstad.*domainname.com*
- www.auth.openstad.*domainname.com*
- www.admin.openstad.*domainname.com*
- www.img.openstad.*domainname.com*

Advantage of first setting up domains is that Let's Encrypt configures the SSL certificates immediately.

If you have no domain, an alternative is xip.io which sends certain domain names automatically to your IP. For instance

- www.178.128.136.92.xip.io
- www.178.128.136.92.xip.io
- www.api.openstad.*domainname.com*
- www.auth.openstad.*domainname.com*
- www.admin.openstad.*domainname.com*
- www.img.openstad.*domainname.com*



## Confige your custom values
Copy values.yaml and configure values. Create a custom-values.yaml and set the domains corresponding to

- update custom mysql password
- check which containers are set, currently default are  with :test, latest one are development (and devel for application)


## First install
helm install --kubeconfig=config.yaml --values c-values.yaml --replace openstad . --namespace=openstad --create-namespace

## Upgrade for SSL to work
Wait a few minutes till all pods are running

kubectl get pods -n openstad



## Some other commands

```
helm upgrade openstad . --namespace openstad --values c-values.yaml --kubeconfig=config.yaml
```
```
kubectl get pods -n openstad --kubeconfig=config.yaml
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
```

Get namespace config
```
kubectl get namespace openstad -o json > openstad.json
```


## How to add your own container?
Current config assument a public docker hub
In config yaml
yourdockerhubrepo/name:tag
