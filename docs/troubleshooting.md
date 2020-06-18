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