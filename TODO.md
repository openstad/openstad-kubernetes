# TODO

Points marked with (*) should be handled by or done together with the Opestad development team.
Last cleanup June 4, 2020 - 12:18PM.

## Software

- [ ] Use the correct builds for the containers based on the delivered branches.
- [ ] Ensure logging communicated is useful (operational logging instead of startup).(*)
- [x] Add Health check endpoints (*)
- [ ] Minimize sizes of build docker images (*)
- [ ] Default database setup including fixtures (*)

## Kubernetes

- [x] Secrets mapping to be added to Helm chart (https://helm.sh/docs/howto/charts_tips_and_tricks/#creating-image-pull-secrets)
- [x] PVC mappings in YAML format to be added to repository
- [x] PVC mappings to be added to Helm chart
- [x] Make PVC mappings configurable from Helm chart so storage-class and annotations can be added.

- [ ] Add MongoDB, MySQL and Cert-manager as subscharts including option to override it (enable/disable/set data)

## Administrative

- [ ] Add charts to be loaded from repository rather than checkout (https://medium.com/containerum/how-to-make-and-share-your-own-helm-package-50ae40f6c221)
- [ ] Structurally move to use the Github Openstad-Kubernetes repository instead of Stash.
- [ ] Ensure that the right branches are used in Dockerhub to support autobuilding and registration of the image.

## Documentation

- [ ] Document the values.yaml and put the configurable blocks on top.
- [ ] Finalize the README.md to support the Helm and standard install.
- [ ] Add guidelines for setup with custom Mysql database and Mongodb.

## Testing

- [ ] Check working with multiple replicas for each of the containers.
- [ ] See if deployment of a new version works correctly (*)
- [ ] Validate full end to end install with or without standard components (database/mongo/cert-manager)
- [ ] Validate Ingress setup and tune.
