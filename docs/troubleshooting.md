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

First we should identify the faulty CRD.
Assuming we have tried to delete the namespace or CRD's already, 
start by looking up which CRD's exists.

```
  $ kubectl get crd | grep cert
    challenges.acme.cert-manager.io                 2020-06-22T10:01:43Z
```
 
Clearly only everything but one of the CRD's are deleted. 
Let's see what its status is:
```
$ kubectl describe crd challenges.acme.cert-manager.io
---
...
Scroll to bottom
...

Status:
  Accepted Names:
    Kind:       Challenge
    List Kind:  ChallengeList
    Plural:     challenges
    Singular:   challenge
  Conditions:
    Last Transition Time:  2020-06-22T10:01:43Z
    Message:               no conflicts found
    Reason:                NoConflicts
    Status:                True
    Type:                  NamesAccepted
    Last Transition Time:  2020-06-22T10:01:47Z
    Message:               the initial names have been accepted
    Reason:                InitialNamesAccepted
    Status:                True
    Type:                  Established
    Last Transition Time:  2020-06-22T10:03:45Z
    Message:               CustomResource deletion is in progress
    Reason:                InstanceDeletionInProgress
    Status:                True
    Type:                  Terminating
  Stored Versions:
    v1alpha2
Events:  <none>
```
 Under the last message we see: `CustomResource deletion is in progress`. 
 Clearly something froze the CRD, possible a deadlock. (At the time of the
 command it was 13:34. This is 3 hours and 31 minutes after deletion.)
 
 In this case a quick dirty fix is to remove its finalizers.
 This can be done with:
 
```
 kubectl patch crd/challenges.acme.cert-manager.io -p '{"metadata":{"finalizers":[]}}' --type merge 
```

Notice:
The example had `challenges.acme.cert-manager.io` as the faulty CRD.
Replace all references to this with the CRD you after the first command
from this section.

### Prevention

Uninstall the chart first with:
```
helm uninstall openstad --namespace openstad
```

Then delete the namespace:
```
kubectl delete ns openstad
```

## A directory on a persistent volume has the wrong owner

When a persistent volume has the wrong ownership, it might not be possible for the application to write to this folder.

Example of this problem on the image server:

```
  $ kubectl exec openstad-image-yyyyyyyyy-zzzzz -- ls -la /app/images
    drwxrwxrwx 2 root root  1234 Dec 31 08:00 .
    drwxr-xr-x 1 root root  4096 Dec 31 08:00 ..
```

In this case, the `/app/images` folder is owned by `root:root`. 
To solve this problem we can use an initContainer in our `k8s/openstad/templates/image/deployment.yaml` using `busybox` to set the correct group and user (in this case: `node:node`):

```
initContainers:
- name: volume-mount-fix
  image: busybox
  command: ["sh", "-c", "chown -R node:node /app/images"]
  volumeMounts:
  - name: data-vol
    mountPath: /app/images
```

After running `helm upgrade`, the volume has the correct owner and can be written to:

```
  $ kubectl exec openstad-image-yyyyyyyyy-zzzzz -- ls -la /app/images
    drwxrwxrwx 2 node node  1234 Dec 31 08:00 .
    drwxr-xr-x 1 node node  4096 Dec 31 08:00 ..
```

The initContainer can now be removed from the deployment.yaml file.
