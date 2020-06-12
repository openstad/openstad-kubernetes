# TODO

Points marked with (*) should be handled by or done together with the Openstad development team.
Last cleanup June 8, 2020 - 19:18PM.

## 1. Software

- [x] 1.1 Use the correct builds for the containers based on the delivered branches.
- [ ] 1.2 Ensure logging communicated is useful (operational logging instead of startup).(*)
- [x] 1.3 Add Health check endpoints (*)
- [ ] 1.4 Minimize sizes of build docker images (*)
- [x] 1.5 Default database install in helm
- [x] 1.6 Auto configuration of three databases and accounts using standard MySQL helm
- [ ] 1.7 Database setup including fixtures (*)
- [ ] 1.8 Prevent overwriting existing database after restart (*)
- [ ] 1.9 Local.js for development was patched for containers but needs integration (*)
- [ ] 1.10 Dependency of old branches to older MySQL where master has not (*)

## 2. Kubernetes

- [x] 2.1 Secrets mapping to be added to Helm chart (https://helm.sh/docs/howto/charts_tips_and_tricks/#creating-image-pull-secrets)
- [x] 2.2 PVC mappings in YAML format to be added to repository
- [x] 2.3 PVC mappings to be added to Helm chart
- [x] 2.4 Make PVC mappings configurable from Helm chart so storage-class and annotations can be added.
- [x] 2.5 Add MongoDB, MySQL and Cert-manager as subscharts including option to override it (enable/disable/set data)
- [x] 2.6 Ingress access to the frontend
- [x] 2.7 Automatic generaction of central certificate file using Helm and shared via secrets
- [x] 2.8 Add Ingress files for each container including automapping over multiple containers
- [ ] 2.9 Validate the Volume settings including helm annotations describing actions for cleanup and reinstall

## 3. Administrative

- [ ] 3.1 Add charts to be loaded from repository rather than checkout (https://medium.com/@mattiaperi/create-a-public-helm-chart-repository-with-github-pages-49b180dbb417)
- [x] 3.2 Structurally move to use the Github Openstad-Kubernetes repository instead of Stash.
- [x] 3.3 Ensure that the right branches are used in Dockerhub to support autobuilding and registration of the image.

## 4. Documentation

- [x] 4.1 Document the values.yaml and put the configurable blocks on top.
- [x] 4.2 Finalize the README.md to support the Helm and standard install.
- [ ] 4.3 Add guidelines for setup with custom Mysql database and Mongodb.
- [ ] 4.4 Describe use of xip.io or nip.io endpoint combining hostname and IP address if none defined

## 5. Testing

- [ ] 5.1 Check working with multiple replicas for each of the containers.
- [ ] 5.2 See if deployment of a new version works correctly (*)
- [ ] 5.3 Validate full end to end install with or without standard components (database/mongo/cert-manager)
- [ ] 5.4 Validate Ingress setup and tune.
