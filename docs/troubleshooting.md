# Troubleshooting

In case of problems here are some ways to find out what happens and to access internal resources.
The example below assume that the application has been installed in the openstad namespace.

## Accessing MySQL

In order to be able to quickly work on the database, adminer has been added to the standard Chart but this is not made available publically.
You can make the Adminer interface locally available by using a port-forward construction:

```bash
kubectl port-forward -n openstad svc/openstad-adminer 8111:8080
```

After the command has started stating `Forwarding from 127.0.0.1:8111 -> 8080` you can open your browser to [http://localhost:8111/](http://localhost:8111/).
A login is requested after that for which you can find the settings in the `openstad-db-credentials` secret.

```bash
echo 'Hostname : '$(kubectl get secret -n openstad openstad-db-credentials -o=jsonpath='{.data.hostname}' | base64 -d)
echo 'Username : '$(kubectl get secret -n openstad openstad-db-credentials -o=jsonpath='{.data.username}' | base64 -d)
echo 'Password : '$(kubectl get secret -n openstad openstad-db-credentials -o=jsonpath='{.data.password}' | base64 -d)
```

After login you can enter the databases, view and edit the data when needed.

## Namespace hangs on terminations

Example of the problem:
```
$ kubectl get ns
NAME              STATUS        AGE
default           Active        20d
ingress-nginx     Active        14d
kube-node-lease   Active        20d
kube-public       Active        20d
kube-system       Active        20d
openstad          Terminating   114m
```

Caused by:
1. Deleting the namespace before deleting the Helm Chart
2. CRD stuck at deletion

### Fix for causation 1

Warning: This method deletes the globally defined CRD's of Cert-Manager.
This can cause unwanted data-loss in other services that use Cert-Manager.

Get a list of CRD's from cert-manager: 
```
  $ kubectl get crd | grep cert
    certificaterequests.cert-manager.io              2020-06-19T14:02:48Z
    certificates.cert-manager.io                     2020-06-19T14:02:49Z
    challenges.acme.cert-manager.io                  2020-06-19T14:02:50Z
    clusterissuers.cert-manager.io                   2020-06-19T14:02:52Z
    issuers.cert-manager.io                          2020-06-19T14:02:53Z
    orders.acme.cert-manager.io                      2020-06-19T14:02:54Z
```

After confirming the CRD's are still present, delete them manually with:
```
kubectl delete crd certificaterequests.cert-manager.io certificates.cert-manager.io clusterissuers.cert-manager.io challenges.acme.cert-manager.io issuers.cert-manager.io orders.acme.cert-manager.io
```

After this step the namespace should finally delete itself.

### Fix for causation 2

TBA
 
### Prevention

Uninstall the chart first with:
```
helm uninstall openstad --namespace openstad
```

Then delete the namespace:
```
kubectl delete ns openstad
```