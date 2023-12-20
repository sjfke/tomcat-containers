# Podman Kube for tomcat-containers

This document describes

* `podman-compose` a Python script supporting a subset of [docker compose](https://docs.docker.com/compose/compose-file/03-compose-file/)
* `podman play kube` support for a subset of the Kubernetes API YAML files

The `podman-compose` Python script is intended as a convenience for importing a `Docker Compose` configuration into `Podman`, from which the Kubernetes API YAML files can be generated for use with `podman play kube`

## General Podman References

* [Podman Commands](https://docs.podman.io/en/v4.2/Commands.html)
* [Podman: Tutorials](https://docs.podman.io/en/latest/Tutorials.html)
* [Podman: Python scripting for Podman services](https://podman-py.readthedocs.io/en/latest/index.html)
* [Github: Containers/Podman](https://github.com/containers/podman/releases)

## Using Kubernetes Files

While `podman-compose` allows you to use your `Docker Compose` file, to deploy your containers, inspect and generate Kubernetes YAML files from them, it is probably cleaner to start directly from the Kubernetes YAML files.

To be consistent with the `compose.yaml`, the same ***network name*** and ***physical volume*** are used, these are setup in the [next section](#prerequisites-for-kubernetes-files)

### Prerequisites for Kubernetes Files

First create the `jspnet` network, see [podman-network-create - Create a Podman CNI network](https://docs.podman.io/en/v3.2.0/markdown/podman-network-create.1.html) to isolate the Bookstore application from the `podman-default-kube-network`, removing the `tomcat-containers_jspnet` network if it was created using `podman-compose`

```console
PS C:\Users\sjfke> podman network ls                                   # what networks exist?

PS C:\Users\sjfke> podman network inspect podman-default-kube-network  # network details
PS C:\Users\sjfke> podman inspect podman-default-kube-network          # 'network' keyword is optional

PS C:\Users\sjfke> podman network rm tomcat-containers_jspnet          # remove podman-compose network
PS C:\Users\sjfke> podman network create jspnet                        # create jspnet with the defaults
PS C:\Users\sjfke> podman network inspect jspnet                       # what was created
[
     {
          "name": "jspnet",
          "id": "65ae91d5af3205c1407eed6a74c8fb73d0b8165f9dbb5e16e41281441e07c22f",
          "driver": "bridge",
          "network_interface": "podman3",
          "created": "2023-12-12T17:05:52.13265508+01:00",
          "subnets": [
               {
                    "subnet": "10.89.2.0/24",
                    "gateway": "10.89.2.1"
               }
          ],
          "ipv6_enabled": false,
          "internal": false,
          "dns_enabled": true,
          "ipam_options": {
               "driver": "host-local"
          }
     }
]
```

Next step would be to create the `jsp_bookstoredata` volume, see [podman-volume-create - Create a new volume](https://docs.podman.io/en/v3.2.0/markdown/podman-volume-create.1.html), but this was created and populated in the [PODMAN, Application Specific Setup](./PODMAN.md#application-specific-setup).

```console
PS C:\Users\sjfke> podman volume list
PS C:\Users\sjfke> podman volume create jsp_bookstoredata
PS C:\Users\sjfke> podman volume inspect jsp_bookstoredata
[
     {
          "Name": "jsp_bookstoredata",
          "Driver": "local",
          "Mountpoint": "/home/user/.local/share/containers/storage/volumes/jsp_bookstoredata/_data",
          "CreatedAt": "2023-08-17T10:27:14.459352827+02:00",
          "Labels": {},
          "Scope": "local",
          "Options": {},
          "MountCount": 0,
          "NeedsCopyUp": true,
          "LockNumber": 0
     }
]
```

The `Docker Compose` original uses a *hard-coded* database password, but with `podman play kube` it is possible to do this with a `Kubernetes Secret or ConfigMap`.

This documentation covers assumes using the `Secret` as a standalone `secrets.yaml` file.

To use a `configMap`, which must be specified in the ***deployment*** file, see [bookstoredb-configmap-deployment.yaml](./Podman/bookstoredb-configmap-deployment.yaml)

In order to create the [secrets.yaml](./Podman/secrets.yaml) file it is necessary to [base64](#base64-encodedecode) encode the `db_root_password` password, see [Base64 encode/decode](#base64-encodedecode) for how this can be done.

Having created the [secrets.yaml](./Podman/secrets.yaml) file, add it to `Podman`

```console
PS C:\Users\sjfke> podman kube play secrets.yaml
PS C:\Users\sjfke> podman secret list
PS C:\Users\sjfke> podman secret inspect bookstore-secrets
[
    {
        "ID": "8f41fa6116bbd7696d791ea84",
        "CreatedAt": "2023-12-13T16:36:16.035042384+01:00",
        "UpdatedAt": "2023-12-13T16:36:16.035042384+01:00",
        "Spec": {
            "Name": "bookstore-secrets",
            "Driver": {
                "Name": "file",
                "Options": {
                    "path": "/home/user/.local/share/containers/storage/secrets/filedriver"
                }
            },
            "Labels": {}
        }
    }
]
```

### Building and Deploying

To build and deploy the application, the following files are used

1. [Dockerfile](./Podman/Dockerfile)
2. [adminer-deployment.yaml](./Podman/adminer-deployment.yaml)
3. [bookstoredb-deployment.yaml](./Podman/bookstoredb-deployment.yaml)
4. [bookstore-deployment.yaml](./Podman/bookstore-deployment.yaml)

File `bookstoredb-deployment.yaml`, (3), requires that the `secret` and `volume` that were created in [Using Kubernetes files](#using-kubernetes-files)

All the YAML files, (2, 3, 4), used by the `podman play kube --start` commands, must use the ***same network***, either the `jspnet` network created in [Using Kubernetes files](#using-kubernetes-files) or the default `podman-default-kube-network`.

```console
PS C:\Users\sjfke> podman build --tag localhost/bookstore:latest --squash -f .\Dockerfile

PS C:\Users\sjfke> podman image list --all
REPOSITORY                 TAG                   IMAGE ID      CREATED        SIZE
docker.io/library/adminer  latest                8485d1424e61  33 hours ago   258 MB
docker.io/library/mariadb  latest                c74611c2858a  4 days ago     411 MB
localhost/podman-pause     4.5.0-1681486976      2d395fdc32ec  6 days ago     1.09 MB
localhost/bookstore        latest                e59e14df9f4b  6 days ago     489 MB
docker.io/library/tomcat   9.0.71-jdk17-temurin  b07e16b11088  10 months ago  482 MB

PS C:\Users\sjfke> podman kube play .\secrets.yaml
PS C:\Users\sjfke> podman secret list
ID                         NAME               DRIVER      CREATED         UPDATED
8f41fa6116bbd7696d791ea84  bookstore-secrets  file        15 minutes ago  15 minutes ago

PS C:\Users\sjfke> podman play kube --start .\adminer-deployment.yaml                      # podman-default-kube-network
PS C:\Users\sjfke> podman play kube --start .\bookstoredb-deployment.yaml                  # podman-default-kube-network
PS C:\Users\sjfke> podman play kube --start .\bookstore-deployment.yaml                    # podman-default-kube-network

PS C:\Users\sjfke> podman play kube --start --network jspnet .\adminer-deployment.yaml     # jspnet
PS C:\Users\sjfke> podman play kube --start --network jspnet .\bookstoredb-deployment.yaml # jspnet
PS C:\Users\sjfke> podman play kube --start --network jspnet .\bookstore-deployment.yaml   # jspnet

PS C:\Users\sjfke> podman ps -a --format "{{.ID}}\t{{.Names}}\t {{.Ports}}\t {{.Status}}\t {{.Image}}"
473b28a5f228    6bbad1d1e7ff-infra       0.0.0.0:8081->8080/tcp  Up 2 minutes    localhost/podman-pause:4.5.0-1681486976
959b5fd53929    adminer-pod-adminer      0.0.0.0:8081->8080/tcp  Up 2 minutes    docker.io/library/adminer:latest
8c7ffd2caafb    5759a5265178-infra       0.0.0.0:3306->3306/tcp  Up 2 minutes    localhost/podman-pause:4.5.0-1681486976
e9f8fdf3a4a5    bookstoredb-pod-bookstoredb      0.0.0.0:3306->3306/tcp  Up 2 minutes    docker.io/library/mariadb:latest
3662396a7652    25f1e479a31f-infra       0.0.0.0:8080->8080/tcp  Up About a minute       localhost/podman-pause:4.5.0-1681486976
4f08f26111db    bookstore-pod-bookstore  0.0.0.0:8080->8080/tcp  Up About a minute       localhost/bookstore:latest

PS C:\Users\sjfke> start "http://localhost:8080/Bookstore"  # Bookstore Application
PS C:\Users\sjfke> start http://localhost:8081              # Adminer

PS C:\Users\sjfke> podman play kube --down .\bookstoredb-deployment.yaml                   # network name optional
PS C:\Users\sjfke> podman play kube --down --network jspnet .\adminer-deployment.yaml      # network name optional
PS C:\Users\sjfke> podman play kube --down .\bookstore-deployment.yaml                     # network name optional
```

Once you are done, do not forget the **final clean up**

```console
PS C:\Users\sjfke> podman secret list
PS C:\Users\sjfke> podman secret rm bookstore-secrets
PS C:\Users\sjfke> podman volume list
PS C:\Users\sjfke> podman volume rm jsp_bookstoredata
```

## Support for Docker Compose

The `podman-compose` command, see [Github: podman-compose](https://github.com/containers/podman-compose), is a Python script, which supports using `Docker Compose` files with `Podman`.

It is assumed `podman-compose` is installed in a `virtualenv`, which is indicated in the command prompt.

```console
PS C:\Users\sjfke> podman network ls            # list all networks (NB 'list' no-work)
PS C:\Users\sjfke> podman volume list           # list all volumes
PS C:\Users\sjfke> podman image list [-a]       # list all images (alias: podman images)
PS C:\Users\sjfke> podman image prune           # remove all 'dangling' images
PS C:\Users\sjfke> podman image rm 720ca5299f68 # delete image by id (alias: podman rmi)
PS C:\Users\sjfke> podman build --tag localhost/tomcat-containers_bookstore --squash -f .\Dockerfile

(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml up -d
(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml down
```

Note all of the above commands can be run all the commands inside the `virtualenv`.

### Using Docker compose file

* [The Compose Specification](https://github.com/compose-spec/compose-spec/blob/master/spec.md)
* [Compose file version 3 reference](https://docs.docker.com/compose/compose-file/compose-file-v3/)
* [Compose file version 2 reference](https://docs.docker.com/compose/compose-file/compose-file-v2/)

The `podman-compose` is not intended as a *plug-in* replacement for `podman play kube`, for more details see [Podman Compose or Docker Compose: Which should you use in Podman?](https://www.redhat.com/sysadmin/podman-compose-docker-compose)

Like `docker compose`, `podman-compose` will generate missing images from the `Dockerfile` or `Containerfile` in the current folder.
To illustrate this, two example `podman-compose` are shown, the [first](#manual-build) manually builds the `Bookstore` image, and uses prebuilt image, where as the [second](#compose-build) the `Bookstore` image is built *on-the-fly* from the `Docker` file.

The results of running `podman kube generate` on the `Docker Compose` configuration are stored in [generated](./Podman/generated/) folder, see [Extracting `Compose build` containers](#extracting-compose-build-containers).

#### Manual build

Builds the `Bookstore` image, using `--tag` to supply the name and `--squash` to merge the image’s new layers into a single new layer.

```console
PS C:\Users\sjfke> podman image list -a
REPOSITORY  TAG         IMAGE ID    CREATED     SIZE

PS C:\Users\sjfke> podman build --tag localhost/tomcat-containers_bookstore --squash -f .\Dockerfile

PS C:\Users\sjfke> podman image list -a
REPOSITORY                             TAG                   IMAGE ID      CREATED         SIZE
localhost/tomcat-containers_bookstore  latest                ac5831c2ddf8  18 seconds ago  489 MB
docker.io/library/tomcat               9.0.71-jdk17-temurin  b07e16b11088  10 months ago   482 MB

(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml up -d

PS C:\Users\sjfke> podman image list -a
REPOSITORY                             TAG                   IMAGE ID      CREATED         SIZE
localhost/tomcat-containers_bookstore  latest                a92421f59491  26 minutes ago  489 MB
docker.io/library/mariadb              latest                f8c340abd40f  8 days ago      411 MB
docker.io/library/adminer              latest                7554c8e10d81  2 weeks ago     258 MB
docker.io/library/tomcat               9.0.71-jdk17-temurin  b07e16b11088  10 months ago   482 MB

PS C:\Users\sjfke> podman ps -a --format "{{.ID}}\t{{.Names}}\t {{.Ports}}\t {{.Status}}\t {{.Image}}"
62882d87dafc    tomcat-containers_bookstoredb_1  0.0.0.0:3306->3306/tcp  Up 21 minutes   docker.io/library/mariadb:latest
73e91ba5b4b2    tomcat-containers_bookstore_1    0.0.0.0:8080->8080/tcp  Up 21 minutes   localhost/tomcat-containers_bookstore:latest
df094bcea12a    tomcat-containers_adminer_1      0.0.0.0:8081->8080/tcp  Up 21 minutes   docker.io/library/adminer:latest

PS C:\Users\sjfke> start "http://localhost:8080/Bookstore"  # Bookstore Application
PS C:\Users\sjfke> start http://localhost:8081              # Adminer

(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml down
```

#### Compose build

In this example the `Bookstore` image is created from [Dockerfile](./Podman/Dockerfile) as specified in the `compose.yaml` in the parent folder.

```console
PS C:\Users\sjfke> podman image list --all
REPOSITORY  TAG         IMAGE ID    CREATED     SIZE

(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml up -d

PS C:\Users\sjfke> podman image list --all
REPOSITORY                             TAG                   IMAGE ID      CREATED             SIZE
localhost/tomcat-containers_bookstore  latest                a25abbf58cdc  About a minute ago  489 MB
<none>                                 <none>                1953d1d27a3f  About a minute ago  489 MB
<none>                                 <none>                8beee9a8e270  About a minute ago  489 MB
<none>                                 <none>                75a73c19a5c8  About a minute ago  487 MB
<none>                                 <none>                8f591d910c74  About a minute ago  489 MB
<none>                                 <none>                837f6c4d3635  About a minute ago  487 MB
<none>                                 <none>                5ae1d5e96da2  About a minute ago  487 MB
<none>                                 <none>                d13586aa9b17  About a minute ago  487 MB
<none>                                 <none>                f171388c02ea  About a minute ago  487 MB
<none>                                 <none>                aebeb5988595  About a minute ago  482 MB
<none>                                 <none>                54bfddb8b669  About a minute ago  482 MB
<none>                                 <none>                db3b15ff5254  About a minute ago  482 MB
<none>                                 <none>                fc4732df67bf  About a minute ago  482 MB
<none>                                 <none>                8e004cbae72d  About a minute ago  482 MB
docker.io/library/mariadb              latest                f8c340abd40f  8 days ago          411 MB
docker.io/library/adminer              latest                7554c8e10d81  2 weeks ago         258 MB
docker.io/library/tomcat               9.0.71-jdk17-temurin  b07e16b11088  10 months ago       482 MB

PS C:\Users\sjfke> podman ps -a --format "{{.ID}}\t{{.Names}}\t {{.Ports}}\t {{.Status}}\t {{.Image}}"
9da81c6dced7    tomcat-containers_bookstoredb_1  0.0.0.0:3306->3306/tcp  Up About a minute       docker.io/library/mariadb:latest
e308e0ce32ec    tomcat-containers_bookstore_1    0.0.0.0:8080->8080/tcp  Up About a minute       localhost/tomcat-containers_bookstore:latest
74d7ed4a2500    tomcat-containers_adminer_1      0.0.0.0:8081->8080/tcp  Up About a minute       docker.io/library/adminer:latest

PS C:\Users\sjfke> start http://localhost:8080/Bookstore
PS C:\Users\sjfke> start http://localhost:8081

(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml down
PS C:\Users\sjfke> podman image list --all
REPOSITORY                             TAG                   IMAGE ID      CREATED        SIZE
localhost/tomcat-containers_bookstore  latest                a25abbf58cdc  4 minutes ago  489 MB
<none>                                 <none>                1953d1d27a3f  4 minutes ago  489 MB
<none>                                 <none>                8beee9a8e270  4 minutes ago  489 MB
<none>                                 <none>                75a73c19a5c8  4 minutes ago  487 MB
<none>                                 <none>                8f591d910c74  4 minutes ago  489 MB
<none>                                 <none>                837f6c4d3635  4 minutes ago  487 MB
<none>                                 <none>                5ae1d5e96da2  4 minutes ago  487 MB
<none>                                 <none>                d13586aa9b17  4 minutes ago  487 MB
<none>                                 <none>                f171388c02ea  4 minutes ago  487 MB
<none>                                 <none>                aebeb5988595  4 minutes ago  482 MB
<none>                                 <none>                54bfddb8b669  4 minutes ago  482 MB
<none>                                 <none>                db3b15ff5254  4 minutes ago  482 MB
<none>                                 <none>                fc4732df67bf  4 minutes ago  482 MB
<none>                                 <none>                8e004cbae72d  4 minutes ago  482 MB
docker.io/library/mariadb              latest                f8c340abd40f  8 days ago     411 MB
docker.io/library/adminer              latest                7554c8e10d81  2 weeks ago    258 MB
docker.io/library/tomcat               9.0.71-jdk17-temurin  b07e16b11088  10 months ago  482 MB
```

### Extracting `Compose build` containers

To demonstrate the `podman kube generate` all the files in the [generated](./Podman/generated) folder where created as show below.

To be able to use these with `podman play kube`, some manual editing of the *label* and *name* attributes is needed.

```console
(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml up -d

PS C:\Users\sjfke> podman kube generate --type deployment tomcat-containers_adminer_1 -f adminer-deployment.yaml
PS C:\Users\sjfke> podman kube generate --type pod tomcat-containers_adminer_1 -f adminer-pod.yaml
PS C:\Users\sjfke> podman kube generate --type deployment --service tomcat-containers_adminer_1 -f adminer-deployment-service.yaml
PS C:\Users\sjfke> podman kube generate --type pod --service tomcat-containers_adminer_1 -f adminer-pod-service.yaml

PS C:\Users\sjfke> podman kube generate --type deployment tomcat-containers_bookstore_1 -f bookstore-deployment.yaml
PS C:\Users\sjfke> podman kube generate --type pod tomcat-containers_bookstore_1 -f bookstore-pod.yaml
PS C:\Users\sjfke> podman kube generate --type deployment --service tomcat-containers_bookstore_1 -f bookstore-deployment-service.yaml
PS C:\Users\sjfke> podman kube generate --type pod --service tomcat-containers_bookstore_1 -f bookstore-pod-service.yaml

PS C:\Users\sjfke> podman kube generate --type deployment tomcat-containers_bookstoredb_1 -f bookstoredb-deployment.yaml
PS C:\Users\sjfke> podman kube generate --type pod tomcat-containers_bookstoredb_1 -f bookstoredb-pod.yaml
PS C:\Users\sjfke> podman kube generate --type deployment --service tomcat-containers_bookstoredb_1 -f bookstoredb-deployment-service.yaml
PS C:\Users\sjfke> podman kube generate --type pod --service tomcat-containers_bookstoredb_1 -f bookstoredb-pod-service.yaml

# Service information add using '--service' in 'pod' and 'deployment'
PS C:\Users\sjfke> podman kube generate --type service tomcat-containers_adminer_1 -f adminer-service.yaml # fails
Error: generating YAML: invalid generation type - only pods and deployments are currently supported

(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml down
```

The files in the [inspect](./wharf/Podman/inspect) folder were collected at the same time as the `podman kube generate` files were generated.

While this provides an informative starting point, it is cleaner to write the `podman kube play` YAML files from scratch using the output gathered here as a reference source.

Using `podman-compose` will create the `jspnet` but called `tomcat-containers_jspnet`, and this is not deleted by the `podman-compose -f .\compose.yaml down`, so it needs to be manually removed.

```console
PS C:\Users\sjfke> podman network rm tomcat-containers_jspnet
```

## Useful references

* [Overview - Containers, pods or volumes based on the input from YAML file](https://docs.podman.io/en/latest/markdown/podman-kube.1.html)
* [Apply - Kubernetes YAML for containers, pods, or volumes to a Kubernetes cluster](https://docs.podman.io/en/latest/markdown/podman-kube-apply.1.html)
* [Remove - containers and pods based on Kubernetes YAML](https://docs.podman.io/en/latest/markdown/podman-kube-down.1.html)
* [Generate - Kubernetes YAML containers, pods or volumes](https://docs.podman.io/en/latest/markdown/podman-kube-generate.1.html)
* [Create - containers, pods and volumes based on Kubernetes YAML](https://docs.podman.io/en/latest/markdown/podman-kube-play.1.html)
* [Openshift API Index](https://docs.openshift.com/container-platform/4.14/rest_api/index.html) may need to change `4.14` to a current Openshift version
* [Kubernetes API Overview](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/)
* [Kubernetes Deployment YAML: Learn by Example](https://codefresh.io/learn/kubernetes-deployment/kubernetes-deployment-yaml/)

## Base64 encode/decode

How to create a [base64](https://en.wikipedia.org/wiki/Base64) encoded string on Windows.

### Using Git Bash, any `wsl` UNIX shell or a `Busybox` container image

```console
$ echo -n r00tpa55 | base64
cjAwdHBhNTU=

$ echo -n cjAwdHBhNTU=| base64 -d
r00tpa55
```

### In Python, the string needs to be converted to ASCII then base64 bytes

```python
>>> import base64
>>> _ascii = "r00tpa55".encode("ascii")
>>> _b64bytes = base64.b64encode(_ascii)
>>> print(_b64bytes.decode("ascii"))
cjAwdHBhNTU=

>>> import base64
>>> _ascii = "cjAwdHBhNTU=".encode("ascii")
>>> _b64bytes = base64.b64decode(_ascii)
>>> print(_b64bytes.decode("ascii"))
r00tpa55
```

### In PowerShell the string needs to be converted to ASCII then base64 bytes

```console
# ASCII - UNIX compatible
PS C:\Users\sjfke> [Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("r00tpa55"))
cjAwdHBhNTU=
PS C:\Users\sjfke> [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String('cjAwdHBhNTU='))
r00tpa55

# UNICODE version, BE WARNED works on Windows only
PS C:\Users\sjfke> [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes("r00tpa55"))
cgAwADAAdABwAGEANQA1AA==
PS C:\Users\sjfke> [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String('cgAwADAAdABwAGEANQA1AA=='))
r00tpa55
```
