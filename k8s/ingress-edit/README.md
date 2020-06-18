# Example Ingress edit

This is an example setup how to talk to the local API and change Ingress files.
The manual for this is at `docs\update_ingress.md`

## Testing

```bash
kubectl apply -f serviceaccount.yaml
kubectl apply -f deployment.yaml
```

You can remotely access the machine using kubectl by getting the unique pod name and then use this command:

```bash
kubectl exec -n openstad -it [podname] bash
```

In this remote shell you can test access to the remote environment.

```bash
apt update; apt install -y curl
export TOKEN=`cat /var/run/secrets/kubernetes.io/serviceaccount/token`
curl -H "Authorization: Bearer $TOKEN" -k https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/api/
```