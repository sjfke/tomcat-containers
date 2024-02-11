# Building Containers for tomcat-containers

Set up for building containers for [Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) development.

## Project Preparation

* [Eclipse Setup](./ECLIPSE.md)
* [Docker Setup](./DOCKER.md)
* [Podman Setup](./PODMAN.md)
* [Build the `Bookstore` application](./BUILD.md)

## Building the Application Container Image

Having [built and tested](./BUILD.md) the `Bookstore` application, it is time to focus on creating and publishing the container image.

### Podman and Quay.IO

Instructions using `podman`, `podman play kube` and [Quay IO](https://quay.io/)

#### Podman Start MariaDB and Adminer

From the `C:\Users\sjfke\Github\tomcat-containers\wharf\Podman` folder, start MariaDB and Adminer so the container image can be tested.

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers\wharf\Podman
PS C:\Users\sjfke> podman play kube --start .\adminer-pod.yaml     # Start Adminer
PS C:\Users\sjfke> podman play kube --start .\bookstoredb-pod.yaml # Start MariaDB
PS C:\Users\sjfke> Test-NetConnection localhost -Port 3306         # Check MariDB is up and accessible
PS C:\Users\sjfke> start http://localhost:8081                     # Check Adminer is working
```

#### Podman Build and Test Local Quay.IO container

> ***Note:*** use your login name on quay.io/<user>, not sjfke :-) in the `tag`

From the `C:\Users\sjfke\Github\tomcat-containers` folder, build and push the image.

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> podman image list --all
REPOSITORY  TAG         IMAGE ID    CREATED     SIZE
localhost/bookstore       latest                0143f578fd61  26 hours ago    489 MB
docker.io/library/tomcat  9.0.71-jdk17-temurin  b07e16b11088  11 months ago   482 MB

PS C:\Users\sjfke> podman build --tag quay.io/sjfke/bookstore:1.0 --squash -f .\Dockerfile $PWD

PS C:\Users\sjfke> podman image list --all
REPOSITORY                TAG                   IMAGE ID      CREATED         SIZE
quay.io/sjfke/bookstore   1.0                   9d6959dace40  20 seconds ago  489 MB
localhost/bookstore       latest                0143f578fd61  26 hours ago    489 MB
docker.io/library/tomcat  9.0.71-jdk17-temurin  b07e16b11088  11 months ago   482 MB
```

From the `C:\Users\sjfke\Github\tomcat-containers\wharf\Podman` folder start `Bookstore`

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers\wharf\Podman
PS C:\Users\sjfke> podman play kube --start .\quay-io-bookstore-pod.yaml # Deploy local Bookstore image
PS C:\Users\sjfke> start http://localhost:8080                           # Check Tomcat Server
PS C:\Users\sjfke> start http://localhost:8080/Bookstore                 # Check application

PS C:\Users\sjfke> podman play kube --down .\quay-io-bookstore-pod.yaml  # Delete Bookstore deployment
```

#### Podman Push and Test Hosted Quay.IO container

```console
PS C:\Users\sjfke> podman login quay.io  # using your username and password :-)
PS C:\Users\sjfke> start https://quay.io # login using your credentials and create a bookstore repo

PS C:\Users\sjfke> podman push quay.io/sjfke/bookstore:1.0               # Push container
PS C:\Users\sjfke> podman image rm quay.io/sjfke/bookstore:1.0           # Remove local container
PS C:\Users\sjfke> podman pull quay.io/sjfke/bookstore:1.0               # Redundant

# Folder: C:\Users\sjfke\Github\tomcat-containers\wharf\Podman
PS C:\Users\sjfke> podman play kube --start .\quay-io-bookstore-pod.yaml # Deploy Remote Bookstore image
PS C:\Users\sjfke> start http://localhost:8080                           # Check Tomcat Server
PS C:\Users\sjfke> start http://localhost:8080/Bookstore                 # Check application

PS C:\Users\sjfke> podman play kube --down .\quay-io-bookstore-pod.yaml  # Delete Bookstore deployment
```

#### Podman Cleanup

Pods and container clean up

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers\wharf\Podman
PS C:\Users\sjfke> podman play kube --down .\adminer-pod.yaml     # Delete Adminer deployment
PS C:\Users\sjfke> podman play kube --down .\bookstoredb-pod.yaml # Delete MariaDB deployment
PS C:\Users\sjfke> podman play kube --down .\bookstore-pod.yaml   # Delete Bookstore deployment
```

Image clean up

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers\wharf\Podman
PS C:\Users\sjfke> podman image rm quay.io/sjfke/bookstore:1.0
PS C:\Users\sjfke> podman image rm localhost/bookstore 
PS C:\Users\sjfke> podman image rm docker.io/library/adminer
PS C:\Users\sjfke> podman image rm docker.io/library/mariadb
PS C:\Users\sjfke> podman image rm docker.io/library/tomcat:9.0.71-jdk17-temurin
```

### Docker and DockerHub

Instructions using [`Docker`](https://docs.docker.com/engine/reference/commandline/cli/), [`Docker Compose`](https://docs.docker.com/compose/compose-file/) and [Dockerhub](https://hub.docker.com/)

#### Docker Build and Test Local DockerHub container

```console
# Folder: C:\Users\sjfke\github\tomcat-containers
PS C:\Users\sjfke> docker image list --all
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
adminer      latest    fd3b195a8d79   2 weeks ago    250MB
mariadb      latest    2b54778e06a3   2 months ago   404MB

PS C:\Users\sjfke> docker build --tag bookstore -f .\Dockerfile $PWD # Build the image
PS C:\Users\sjfke> docker scout quickview                            # Optional vulnerabilities check
PS C:\Users\sjfke> docker image list --all
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
bookstore    latest    d20191c70a54   5 days ago     482MB
adminer      latest    fd3b195a8d79   2 weeks ago    250MB
mariadb      latest    2b54778e06a3   2 months ago   404MB

PS C:\Users\sjfke> get-content .\.env         
APP=localhost/bookstore
TAG=latest
PS C:\Users\sjfke> docker compose -f .\compose-bookstore.yaml up -d

PS C:\Users\sjfke> start http://localhost:8080                       # Check Tomcat Server
PS C:\Users\sjfke> start http://localhost:8080/Bookstore             # Check application

PS C:\Users\sjfke> docker compose -f .\compose-bookstore.yaml down   # Delete all containers
```

Assuming the test was successful so `tag` the image

> ***Note:*** in the `docker tag` command use your login name 'docker.io/\<user\>', not 'docker.io/sjfke' :-) 

```console
PS C:\Users\sjfke> docker tag bookstore:latest docker.io/sjfke/bookstore:1.0
PS C:\Users\sjfke> docker image list --all
REPOSITORY        TAG       IMAGE ID       CREATED        SIZE
sjfke/bookstore   1.0       d20191c70a54   5 days ago     482MB
bookstore         latest    d20191c70a54   5 days ago     482MB
adminer           latest    fd3b195a8d79   2 weeks ago    250MB
mariadb           latest    2b54778e06a3   2 months ago   404MB
```

#### Docker Push and Test Hosted DockerHub container

> ***Note:*** use your login name 'docker.io/\<user\>', not 'docker.io/sjfke' :-)

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> docker login docker.io  # using your username and password :-)
PS C:\Users\sjfke> start https://docker.io # login using your credentials and create a bookstore repo

PS C:\Users\sjfke> docker push docker.io/sjfke/bookstore:1.0         # Push container
PS C:\Users\sjfke> docker image remove docker.io/sjfke/bookstore:1.0 # Remove local container
PS C:\Users\sjfke> docker image list --all
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
bookstore    latest    d20191c70a54   5 days ago     482MB
adminer      latest    fd3b195a8d79   2 weeks ago    250MB
mariadb      latest    2b54778e06a3   2 months ago   404MB

PS C:\Users\sjfke> docker pull docker.io/sjfke/bookstore:1.0         # Redundant 'pull'

# Deploy Remote Bookstore image
PS C:\Users\sjfke> get-content .\docker-io.env
APP=docker.io/sjfke/bookstore
TAG=1.0
PS C:\Users\sjfke> docker compose --env-file .\docker-io.env -f .\compose-bookstore.yaml up -d

PS C:\Users\sjfke> start http://localhost:8080                       # Check Tomcat Server
PS C:\Users\sjfke> start http://localhost:8080/Bookstore             # Check Bookstore application

# Delete all containers
PS C:\Users\sjfke> docker compose --env-file .\docker-io.env -f .\compose-bookstore.yaml down
```

#### Docker Cleanup

Image clean up needs to be done manually

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> docker image list --all
REPOSITORY        TAG       IMAGE ID       CREATED        SIZE
adminer           latest    fd3b195a8d79   8 hours ago    250MB
bookstore         latest    cbf18a39836f   18 hours ago   482MB
sjfke/bookstore   1.0       cbf18a39836f   18 hours ago   482MB
mariadb           latest    3e87f8bfed4e   7 weeks ago    404MB

PS C:\Users\sjfke> docker image rm bookstore adminer mariadb
PS C:\Users\sjfke> docker image rm sjfke/bookstore:1.0

PS C:\Users\sjfke> docker image list --all
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
```

### Own Image Distribution Registry

* [Distribution Registry](https://distribution.github.io/distribution/) a local container image repository.
* [How to Use Your Own Registry](https://www.docker.com/blog/how-to-use-your-own-registry-2/)
* [GitHub - Distribution](https://github.com/distribution/distribution)
* [Registry - Distribution implementation for storing and distributing of container images and artifacts](https://hub.docker.com/_/registry)

Although this permits working locally the `registry` there is no easy way to manage the images. In fact the `/etc/docker/registry/config.yml` does not permit deleting images. 
Suggest running the container using a `docker volume`, so contents are preserved but can be cleared and reset by deleting and recreating `docker volume`.

There are rough notes in the [Registry](./Registry/) folder, for deploying with a persistent volume using `podman` and `docker` to avoid having to repopulate each time it is started.

#### Podman Start local registry

While is is possible to use `--tls-verify=False` on `podman push`, `podman pull` and `podman search` commands, it is easier to define an `insecure registry` which is mandatory with `docker`.

```console
PS C:\Users\sjfke> podman machine ssh
$ sudo vi /etc/containers/registries.conf.d/007-localhost.conf
$ cat /etc/containers/registries.conf.d/007-localhost.conf
[[registry]]
location = "localhost:5000"
insecure = true
$ exit

PS C:\Users\sjfke> podman machine stop
PS C:\Users\sjfke> podman machine start
```

Having added an `insecure-registry` and restarted `podman machine`, start the local registry

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> podman run -d -p 5000:5000 --name registry registry:2.8.3
PS C:\Users\sjfke> podman images
REPOSITORY                  TAG         IMAGE ID      CREATED      SIZE
docker.io/library/registry  2.8.3                 909c3ff012b7  8 weeks ago    26 MB
```

#### Podman Build for local registry

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> podman image list --all
REPOSITORY                  TAG         IMAGE ID      CREATED      SIZE
docker.io/library/registry  2.8.3       909c3ff012b7  8 weeks ago  26 MB

PS C:\Users\sjfke> mvn -f .\Bookstore\pom.xml clean package
PS C:\Users\sjfke> podman build --tag localhost/bookstore --squash -f .\Dockerfile

PS C:\Users\sjfke> podman image list --all
REPOSITORY                  TAG                   IMAGE ID      CREATED        SIZE
localhost/bookstore         latest                430a257cdc4b  7 seconds ago  489 MB
docker.io/library/registry  2.8.3                 909c3ff012b7  8 weeks ago    26 MB
docker.io/library/tomcat    9.0.71-jdk17-temurin  b07e16b11088  11 months ago  482 MB

PS C:\Users\sjfke> podman tag localhost/bookstore localhost:5000/bookstore:1.0
PS C:\Users\sjfke> podman image list --all
REPOSITORY                  TAG                   IMAGE ID      CREATED        SIZE
localhost:5000/bookstore    1.0                   430a257cdc4b  2 minutes ago  489 MB
localhost/bookstore         latest                430a257cdc4b  2 minutes ago  489 MB
docker.io/library/registry  2.8.3                 909c3ff012b7  8 weeks ago    26 MB
docker.io/library/tomcat    9.0.71-jdk17-temurin  b07e16b11088  11 months ago  482 MB

PS C:\Users\sjfke> podman push localhost:5000/bookstore:1.0
PS C:\Users\sjfke> podman search localhost:5000/
NAME                      DESCRIPTION
localhost:5000/bookstore

PS C:\Users\sjfke> podman image rm localhost:5000/bookstore:1.0
```

#### Podman Start database for local registry test

```console
PS C:\Users\sjfke> podman secret list                                               # check `bookstore-secrets` exists
PS C:\Users\sjfke> podman volume list                                               # check `jsp_bookstoredata` exists
PS C:\Users\sjfke> podman network ls                                                # check `jspnet` network exists
PS C:\Users\sjfke> podman play kube --start --network jspnet .\adminer-pod.yaml     # Deploy and start Adminer
PS C:\Users\sjfke> podman play kube --start --network jspnet .\bookstoredb-pod.yaml # Deploy and start MariaDB
PS C:\Users\sjfke> Test-NetConnection localhost -Port 3306                          # Check MariDB is up and accessible
PS C:\Users\sjfke> start http://localhost:8081                                      # Check Adminer
```

#### Podman Pull and test local registry

```console
PS C:\Users\sjfke> podman pull localhost:5000/bookstore:1.0
PS C:\Users\sjfke> podman play kube --start --network jspnet .\bookstore-registry-pod.yaml
PS C:\Users\sjfke> start http://localhost:8080
PS C:\Users\sjfke> start http://localhost:8080/Bookstore

PS C:\Users\sjfke> podman play kube --down .\bookstore-registry-pod.yaml  # Delete Bookstore deployment
PS C:\Users\sjfke> podman play kube --down .\adminer-pod.yaml             # Delete Adminer deployment
PS C:\Users\sjfke> podman play kube --down .\bookstoredb-pod.yaml         # Delete Bookstore database deployment
```

#### Podman Stop and clean-up local registry

```console
PS C:\Users\sjfke> podman rm --force registry
PS C:\Users\sjfke> podman image rm localhost:5000/bookstore:1.0
PS C:\Users\sjfke> podman image rm localhost/bookstore
PS C:\Users\sjfke> podman rmi --all
# Clean up `registry` volume, whatever `podman` called it
PS C:\Users\sjfke> podman volume remove f6b0980061b2291dc0ac2a3bbcc114d44faceba989b2304a72b647863ab91b75
```

#### Docker Start local registry

With `Docker Desktop` you have to define `insecure-registries` and restart the `Docker Desktop`.

For `Docker Desktop` on Windows, select `Settings` > `Docker Engine` add the `insecure-registries` entry as shown, and then `Apply & restart`

> **Warning:** syntax errors can cause `Docker Desktop` to lock up and require a `factory reset`

```json
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false,
  "insecure-registries": [
    "localhost:5000"
  ]
}
```

Having added the `insecure-registries` and restarted `Docker Desktop`, start the local registry

```console
# Folder: C:\Users\geoff\Github\tomcat-containers
PS C:\Users\sjfke> docker compose -f .\wharf\Registry\compose-registry.yaml up -d
PS C:\Users\sjfke> docker image list --all
REPOSITORY   TAG       IMAGE ID       CREATED      SIZE
registry     2.8.3     a8781fe3b7a2   2 days ago   25.4MB
```

##### Docker Build for local registry

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> docker image list --all
REPOSITORY   TAG       IMAGE ID       CREATED      SIZE
registry     2.8.3     a8781fe3b7a2   2 days ago   25.4MB

PS C:\Users\sjfke> mvn -f .\Bookstore\pom.xml clean package
PS C:\Users\sjfke> docker build --tag localhost/bookstore -f .\Dockerfile $PWD
PS C:\Users\sjfke> docker scout quickview  # optionally check image vulnerabilities and recommendations

PS C:\Users\sjfke> docker image list --all
REPOSITORY            TAG       IMAGE ID       CREATED         SIZE
localhost/bookstore   latest    39b2c55040c3   2 minutes ago   482MB
registry              2.8.3     a8781fe3b7a2   2 days ago      25.4MB

PS C:\Users\sjfke> docker tag localhost/bookstore localhost:5000/bookstore:1.0
PS C:\Users\sjfke> docker image list --all
REPOSITORY                 TAG       IMAGE ID       CREATED          SIZE
localhost:5000/bookstore   1.0       39b2c55040c3   10 minutes ago   482MB
localhost/bookstore        latest    39b2c55040c3   10 minutes ago   482MB
registry                   2.8.3     a8781fe3b7a2   2 days ago       25.4MB

PS C:\Users\sjfke> docker push localhost:5000/bookstore:1.0
PS C:\Users\sjfke> docker search localhost:5000/             # returns a 404

PS C:\Users\sjfke> docker image rm localhost:5000/bookstore:1.0
```

##### Docker Pull and test local registry

```console
PS C:\Users\sjfke> docker pull localhost:5000/bookstore:1.0   # Redundant 'pull'

# Deploy MariaDB, Adminer and remote Bookstore image
PS C:\Users\sjfke> docker compose --env-file .\local-registry.env -f .\compose-bookstore up -d 

PS C:\Users\sjfke> Test-NetConnection localhost -Port 3306   # Check MariDB is up and accessible
PS C:\Users\sjfke> start http://localhost:8081               # Check Adminer is working

PS C:\Users\sjfke> start http://localhost:8080               # Check Tomcat Server
PS C:\Users\sjfke> start http://localhost:8080/Bookstore     # Check application

# Delete All containers
PS C:\Users\sjfke> docker compose --env-file .\local-registry.env -f .\compose-bookstore down  
```

##### Docker Stop and clean-up local registry

```consoler
PS C:\Users\sjfke> docker remove --force registry-registry-1
PS C:\Users\sjfke> docker image remove adminer mariadb
PS C:\Users\sjfke> docker image remove localhost/bookstore
PS C:\Users\sjfke> docker image remove localhost:5000/bookstore:1.0
PS C:\Users\sjfke> docker image remove registry:2.8.3
```
