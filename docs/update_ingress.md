# Upgrading hostname in Ingress

In the Openstad admin panel it should be possible to adjust the base hostname of the application.
This hostnames are captured in Kubernetes Ingress objects which should be updated programmatically.
Because the delivery of Certificates is automated, this approach will also ensure the rollout.

## Prepare Service Account

By default an containerized application has no rights talking to its Kubernetes API unless you package a full kubeconfig file with access which is unsafe.
To support this ServiceAccounts are created which are defined connected to a Pod in a Deployment. ServiceAccount object refer to RoleBindings that contain Roles which define what you can do.

In the current setup there is already one ServiceAccount active for the pre-install-job.
For clarity we create a separate one so we can control it better.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: {{ .Release.Namespace }}
  name: openstad-ingress-update-role
rules:
  - apiGroups: ['']
    resources: ['ingress']
    verbs: ["create", "update", "patch", "delete", "get", "list", "watch"]

```

In the setup above all rights to Ingress are defined, and you can limit this down to just the functionality you need.
After that this role can be added to a service account for where we create a new one with a binding to the Role:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  namespace: {{ .Release.Namespace }}
  name: openstad-ingress-sa
```

And this ServiceAccount is connected the Role using a RoleBinding:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: openstad-ingress-update-rb
  namespace: {{ .Release.Namespace }}
roleRef:
  apiGroup: ''
  kind: Role
  name: openstad-ingress-update-role
subjects:
  - kind: ServiceAccount
    name: openstad-ingress-sa
```

This ServiceAccount can be added to an existing deployment file.
See this snippet:

```yaml
spec:
      serviceAccountName: openstad-ingress-sa
```

The service account spec including the settings for Ingress update are added to the Openstad API Deployment.

## Implement code

To access the Kubernetes API using code from the container you can use a prepackaged solution using a [Javascript Client](https://kubernetes.io/docs/tasks/administer-cluster/access-cluster-api/#javascript-client), but for demonstration purposes and because for this case it can be easier to manually code the action as HTTP requests.

### 1. Locate the API

The Kubernetes API server can be accessible directly on "https://kubernetes.default". It will use the serviceaccount specified on the Pod to access this. This default location can be changed in very exceptional cases so it is important to always validate if the API endpoint can be reached.

> The API endpoint specification is also available in the container environment variables under KUBERNETES_SERVICE_HOST and KUBERNETES_PORT_443_TCP_PORT. You can validate that by going into a pod using `kubectl exec [podname] -- sh -c set`.

### 2. Get Access Tokens

We need to pass a "ca cert" and "service account token" to authenticate with the API server.
The certificate file is stored at the following location inside the pod : `/var/run/secrets/kubernetes.io/serviceaccount/ca.crt`
and the default service account token at : `/var/run/secrets/kubernetes.io/serviceaccount/token`.

Validate if it works by doing the following command:

```bash
export TOKEN=`cat /var/run/secrets/kubernetes.io/serviceaccount/token`
curl -H "Authorization: Bearer $TOKEN" -k https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/api/
```

If curl is not available do a quick install:

```bash
apt update; apt install -y curl
```

or you can use wget instead:

```bash
wget --no-check-certificate --header="Authorization: Bearer $TOKEN" -S https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/api/
```

> Keep in mind that if you test this on a Pod that has no serviceaccount specified (which means default), all actions will be Unauthorized.

### 3. List the Ingress resources available

In order to check whichs Ingress definitions are in use you can list those that are available in the namespace.
This can be done use a GET command on the namespace for the type Ingress.

Using example below where we assume the application to be deployed in the openstad namespace:

```bash
curl -H "Authorization: Bearer $TOKEN" -k https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/apis/networking.k8s.io/v1beta1/namespaces/openstad/ingresses
```

This will return the following response starting with:

```json
{
  "kind": "IngressList",
  "apiVersion": "networking.k8s.io/v1beta1",
  "metadata": {
    "selfLink": "/apis/networking.k8s.io/v1beta1/namespaces/openstad/ingresses",
    "resourceVersion": "1473825"
  },
  "items": [
    {
      "metadata": {
        "name": "openstad-api",
        "namespace": "openstad",
        "selfLink": "/apis/networking.k8s.io/v1beta1/namespaces/openstad/ingresses/openstad-api",
        "uid": "7bc97ac8-fcb2-461d-9cab-d03dfc1d2fd7",
        "resourceVersion": "1375170",
        "generation": 1,
        "creationTimestamp": "2020-06-15T11:24:42Z",
        "labels": {
          "app.kubernetes.io/component": "openstad-api-ingress",
          "app.kubernetes.io/instance": "openstad",
          "app.kubernetes.io/managed-by": "Helm",
          "app.kubernetes.io/name": "openstad",
          "app.kubernetes.io/version": "1",
          "helm.sh/chart": "openstad-0.2.0"
        },
        "annotations": {
          "cert-manager.io/cluster-issuer": "letsencrypt-staging",
          "kubernetes.io/ingress.class": "nginx",
          "meta.helm.sh/release-name": "openstad",
          "meta.helm.sh/release-namespace": "openstad"
        }
      },
      "spec": {
        "tls": [
          {
            "hosts": [
              "www.api.openstad.softwaredepartment.net"
            ],
            "secretName": "openstad-tls-api"
          }
        ],
        "rules": [
          {
            "host": "www.api.openstad.softwaredepartment.net",
            "http": {
              "paths": [
                {
                  "path": "/",
                  "backend": {
                    "serviceName": "openstad-api",
                    "servicePort": 8111
                  }
                }
              ]
            }
          }
        ]
      },
      "status": {
        "loadBalancer": {
          "ingress": [
            {
              "ip": "64.225.80.119"
            }
          ]
        }
      }
    },.......
```

In the array of items there are the full Ingress objects that you can use to update

### 4. Post or Patch the Ingress resources

#### 4.1 Post

If you want to change for instance the hostname in the response about you do the following steps:

- iterate over the results
- edit the spec.tls.hosts and spec.rules.hosts
- store the metadata.name in $INGRESS_OBJECT_NAME
- store the contents of the single Ingress object in $INGRESS_OBJECT_FILE
- run the bash script below

```bash
curl -H "Authorization: Bearer $TOKEN" -XPOST -k \
     -d $INGRESS_OBJECT_FILE
     https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/apis/networking.k8s.io/v1beta1/namespaces/openstad/ingresses/$INGRESS_OBJECT_NAME
```

#### 4.2 Patch

Using the HTTP PATCH command you can send in changes to existing Kubernetes objects without the need of posting everything.
You just send in the changed fields so if you are already sure that an Ingress exists, you might not have to retrieve it fully first and directly patch it.

In this case you do not need the full object as above but replace it by generic:

```yaml
spec:
    tls:
        hosts: [
            "whatever.example"
        ]
    rules:
        host: "whatever.example"
```

```bash
curl -H "Authorization: Bearer $TOKEN" -XPATCH -k \
     -d $CHANGED_VALUES
     https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/apis/networking.k8s.io/v1beta1/namespaces/openstad/ingresses/$INGRESS_OBJECT_NAME
```

## Other usage

Apart from using this to update Ingress files in Kubernetes you can also use the same mechanism for managing or monitoring other objects.
You do not have to stop at standard objects but Custom Resource Definitions like Certificates or CSR (/apis/certificates.k8s.io/v1beta1/certificatesigningrequests) can be accessed for instance to track progress of registration.
In order to do this perform the following steps from above:

1. Create a new Role for access to the new object
2. Add the role to the RoleMapping
3. Create the interaction

### Using Node.js

The default Javascript client can be used for integration with Openstad.
It can be found at the [Kubernetes Website](https://kubernetes.io/docs/tasks/administer-cluster/access-cluster-api/#javascript-client).

Creating a new Ingress would look like this:

```javascript
const k8s = require('@kubernetes/client-node')
const kc = new k8s.KubeConfig()
kc.loadFromCluster();

const k8sApi = kc.makeApiClient(k8s.NetworkingV1beta1Api)
const clientIdentifier = 'openstad'

k8sApi.createNamespacedIngress('default', {
  apiVersions: 'networking.k8s.io/v1beta1',
  kind: 'Ingress',
  metadata: { name: `${clientIdentifier}-custom-domain` },
  spec: {
    rules: [{
      host: `${clientIdentifier}.openstad.org`,
      http: {
        paths: [{
          backend: {
            serviceName: 'openstad-frontend-service',
            servicePort: 4444
          },
          path: '/'
        }]
      }
    }],
    tls: [{ hosts: [`${clientIdentifier}.openstad.org`] }]
  }
}).catch(e => console.log(e))
```

For listing there is a standard function as is [documented in the source](https://github.com/kubernetes-client/javascript/blob/master/src/gen/api/networkingV1beta1Api.ts#L933)

For updating you can ([se the following](https://github.com/kubernetes-client/javascript/blob/master/src/gen/api/networkingV1beta1Api.ts#L1254)
