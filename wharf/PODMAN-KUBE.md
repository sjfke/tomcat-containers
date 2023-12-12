# Podman Kube for tomcat-containers

The `podman-compose` command is a Python script, which for me is installed in a `virtualenv`.

* [Podman Commands](https://docs.podman.io/en/v4.2/Commands.html)
* [Podman: Tutorials](https://docs.podman.io/en/latest/Tutorials.html)
* [Podman: Python scripting for Podman services](https://podman-py.readthedocs.io/en/latest/index.html)

Some useful commands

```console
PS C:\Users\sjfke> podman image list [-a]       # list all images (alias: podman images)
PS C:\Users\sjfke> podman image prune           # remove all 'dangling' images
PS C:\Users\sjfke> podman image rm 720ca5299f68 # delete image by id (alias: podman rmi)
PS C:\Users\sjfke> podman build --tag localhost/tomcat-containers_bookstore --squash -f .\Dockerfile

(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml up -d
(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml down
```

## Using Docker compose file

* Deprecated [Compose file version 1](https://docs.docker.com/compose/compose-file/compose-versioning/#version-1-deprecated)
* [Compose file version 2 reference](https://docs.docker.com/compose/compose-file/compose-file-v2/)
* [Compose file version 3 reference](https://docs.docker.com/compose/compose-file/compose-file-v3/)
* [Github: podman-compose](https://github.com/containers/podman-compose)

The `podman-compose` command is a Python script, which supports a subset of [docker compose](https://docs.docker.com/compose/compose-file/03-compose-file/) files, but is not intended as a *plug-in* replacement. It is better to use `podman kube generate` and `podman kube play`, for more details see [Podman Compose or Docker Compose: Which should you use in Podman?](https://www.redhat.com/sysadmin/podman-compose-docker-compose)

The results of running `podman kube generate` are stored in [generated](./wharf/Podman/generated) folder.
To be able to use, some manual editing of the *label* and *name* attributes is needed.

Like `docker compose`, `podman-compose` will generate missing images from the `Dockerfile` or `Containerfile` in the current folder.
To illustrate this two example `podman-compose` are shown, the first manually build the `Bookstore` image, using `--tag` to supply the name and `--squash` to merge the image’s new layers into a single new layer.

### Manual build

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

### Compose build

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

To demonstrate the `podman kube generate` all the files in the [generated](./wharf/Podman/generated) folder where created as show below.

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

## Using Kubernetes files

* [How to deploy a Flask API in Kubernetes](https://www.vantage-ai.com/blog/deploy-a-flask-api-in-kubernetes)

```console
PS C:\Users\sjfke> podman network ls

PS C:\Users\sjfke> podman network inspect podman-default-kube-network
PS C:\Users\sjfke> podman inspect podman-default-kube-network

PS C:\Users\sjfke> podman network inspect podman


```

### Base64 encode/decode 

To convert the database password to be used in a secret you need Base64 encode/decode.

Using Git Bash or any `wsl` installed UNIX shell

```console
$ echo -n r00tpa55 | base64
cjAwdHBhNTU=

$ echo -n cjAwdHBhNTU=| base64 -d
r00tpa55
```

In Python, the string needs to be converted to bytes then base64 bytes.

```python
>>> import base64
>>> _bites = "r00tpa55".encode("ascii")
>>> _b64bytes = base64.b64encode(_bites)
>>> print(_b64bytes.decode("ascii"))
cjAwdHBhNTU=

>>> import base64
>>> _bites = "cjAwdHBhNTU=".encode("ascii")
>>> _b64bytes = base64.b64decode(_bites)
>>> print(_b64bytes.decode("ascii"))
r00tpa55
```

***NEED TO CHECK*** Using PowerShell will not provide a UNIX compatible string.

```console
PS C:\Users\sjfke> [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes("r00tpa55"))
cgAwADAAdABwAGEANQA1AA==

PS C:\Users\sjfke> [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String('cgAwADAAdABwAGEANQA1AA=='))
r00tpa55
```

### Deploying

```console
PS C:\Users\sjfke> podman play kube --start .\adminer-deployment.yaml
PS C:\Users\sjfke> podman play kube --start .\bookstoredb-deployment.yaml

PS C:\Users\sjfke> podman play kube --start --network tomcat-containers_jspnet .\adminer-deployment.yaml
PS C:\Users\sjfke> podman play kube --start --network tomcat-containers_jspnet .\bookstoredb-deployment.yaml

PS C:\Users\sjfke> podman play kube --down .\bookstoredb-deployment.yaml
PS C:\Users\sjfke> podman play kube --down .\adminer-deployment.yaml
```

## Useful references

* [Overview - Containers, pods or volumes based on the input from YAML file](https://docs.podman.io/en/latest/markdown/podman-kube.1.html)
* [Apply - Kubernetes YAML for containers, pods, or volumes to a Kubernetes cluster](https://docs.podman.io/en/latest/markdown/podman-kube-apply.1.html)
* [Remove - containers and pods based on Kubernetes YAML](https://docs.podman.io/en/latest/markdown/podman-kube-down.1.html)
* [Generate - Kubernetes YAML containers, pods or volumes](https://docs.podman.io/en/latest/markdown/podman-kube-generate.1.html)
* [Create - containers, pods and volumes based on Kubernetes YAML](https://docs.podman.io/en/latest/markdown/podman-kube-play.1.html)
* [Kubernetes Deployment YAML: Learn by Example](https://codefresh.io/learn/kubernetes-deployment/kubernetes-deployment-yaml/)