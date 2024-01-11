# Building Containers for tomcat-containers

Set up for building containers for [Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) development.

## Project Preparation

* [Eclipse Setup](./ECLIPSE.md)
* [Docker Setup](./DOCKER.md)
* [Podman Setup](./PODMAN.md)
* [Build the `Bookstore` application](./BUILD.md)

## Building the Application Container Image

Having [built and tested](./BUILD.md) the `Bookstore` application, it is time to focus on creating and publishing the container image.

> ***Note:*** section needs rewriting to cover creating and publishing the Container image with `Docker` and `Podman`

### Podman and Quay.IO

Instructions using `Podman` and [Quay IO](https://quay.io/)

#### Podman Start MariaDB and Adminer

From the `C:\Users\sjfke\Github\tomcat-containers\wharf\Podman` folder, start MariaDB and Adminer so the container image can be tested.

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers\wharf\Podman
PS C:\Users\sjfke> podman play kube --start .\adminer-deployment.yaml     # Start Adminer
PS C:\Users\sjfke> podman play kube --start .\bookstoredb-deployment.yaml # Start MariaDB
PS C:\Users\sjfke> Test-NetConnection localhost -Port 3306                # Check MariDB is up and accessible
PS C:\Users\sjfke> start http://localhost:8081                            # Check Adminer is working
```

#### Podman Build and Test Local Quay.IO container

> ***Note:*** use your login name on quay.io/<user>, not sjfke :-) in the `tag`

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
PS C:\Users\sjfke> podman play kube --start .\quay-io-bookstore-deployment.yaml # Deploy local Bookstore image
PS C:\Users\sjfke> start http://localhost:8080                                  # Check Tomcat Server
PS C:\Users\sjfke> start http://localhost:8080/Bookstore                        # Check application

PS C:\Users\sjfke> podman play kube --down .\quay-io-bookstore-deployment.yaml  # delete Bookstore deployment
```

#### Podman Push and Test Hosted Quay.IO container

```console
PS C:\Users\sjfke> podman login quay.io  # using your username and password :-)
PS C:\Users\sjfke> start https://quay.io # login using your credentials and create a bookstore repo

PS C:\Users\sjfke> podman push quay.io/sjfke/bookstore:1.0                      # Push container
PS C:\Users\sjfke> podman image rm quay.io/sjfke/bookstore:1.0                  # Remove local container
PS C:\Users\sjfke> podman pull quay.io/sjfke/bookstore:1.0                      # Redundant

# Folder: C:\Users\sjfke\Github\tomcat-containers\wharf\Podman
PS C:\Users\sjfke> podman play kube --start .\quay-io-bookstore-deployment.yaml # Deploy Remote Bookstore image
PS C:\Users\sjfke> start http://localhost:8080                                  # Check Tomcat Server
PS C:\Users\sjfke> start http://localhost:8080/Bookstore                        # Check application

PS C:\Users\sjfke> podman play kube --down .\quay-io-bookstore-deployment.yaml  # Delete Bookstore deployment
```

#### Podman Cleanup

Pods and container clean up

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers\wharf\Podman
PS C:\Users\sjfke> podman play kube --down .\adminer-deployment.yaml     # Delete Adminer deployment
PS C:\Users\sjfke> podman play kube --down .\bookstoredb-deployment.yaml # Delete MariaDB deployment
PS C:\Users\sjfke> podman play kube --down .\bookstore-deployment.yaml   # Delete Bookstore deployment
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

#### Docker Start MariaDB and Adminer

```console
# using compose-mariadb.yaml
PS C:\Users\sjfke> docker compose -f .\compose-mariadb.yaml up -d # Start Adminer and MariaDB
PS C:\Users\sjfke> Test-NetConnection localhost -Port 3306        # Check MariDB is up and accessible
PS C:\Users\sjfke> start http://localhost:8081                    # Check Adminer is working
```

#### Docker Build and Test Local DockerHub container

> ***Note:*** use your login name on docker.io/<user>, not sjfke :-) in the `tag`

```console
# Folder: C:\Users\sjfke\github\tomcat-containers

PS C:\Users\sjfke> docker image list --all
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
adminer      latest    fd3b195a8d79   8 hours ago   250MB
mariadb      latest    3e87f8bfed4e   7 weeks ago   404MB

PS C:\Users\sjfke> docker build --tag bookstore -f .\Dockerfile $PWD
PS C:\Users\sjfke> docker image list --all
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
adminer      latest    fd3b195a8d79   8 hours ago    250MB
bookstore    latest    cbf18a39836f   18 hours ago   482MB
mariadb      latest    3e87f8bfed4e   7 weeks ago    404MB


PS C:\Users\sjfke> docker tag bookstore:latest docker.io/sjfke/bookstore:1.0
PS C:\Users\sjfke> docker image list --all
REPOSITORY        TAG       IMAGE ID       CREATED        SIZE
adminer           latest    fd3b195a8d79   8 hours ago    250MB
bookstore         latest    cbf18a39836f   18 hours ago   482MB
sjfke/bookstore   1.0       cbf18a39836f   18 hours ago   482MB
mariadb           latest    3e87f8bfed4e   7 weeks ago    404MB
```

#### Docker Push and Test Hosted DockerHub container

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> docker login docker.io  # using your username and password :-)
PS C:\Users\sjfke> start https://docker.io # login using your credentials and create a bookstore repo

PS C:\Users\sjfke> docker push docker.io/sjfke/bookstore:1.0                    # Push container
PS C:\Users\sjfke> docker image rm docker.io/sjfke/bookstore:1.0                # Remove local container
PS C:\Users\sjfke> docker image list --all
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
adminer      latest    fd3b195a8d79   8 hours ago    250MB
bookstore    latest    cbf18a39836f   18 hours ago   482MB
mariadb      latest    3e87f8bfed4e   7 weeks ago    404MB

PS C:\Users\sjfke> docker pull docker.io/sjfke/bookstore:1.0                    # Redundant
PS C:\Users\sjfke> docker compose -f .\compose-docker-io.yaml up -d             # Deploy Remote Bookstore image

PS C:\Users\sjfke> start http://localhost:8080                                  # Check Tomcat Server
PS C:\Users\sjfke> start http://localhost:8080/Bookstore                        # Check application

PS C:\Users\sjfke> docker compose -f .\compose-docker-io.yaml down              # Delete Bookstore container
```

#### Docker Cleanup

Container clean up should not be done by `docker compose -f .\compose-docker-io.yaml down`

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> docker compose -f .\compose-mariadb.yaml down                # Delete Adminer and MariaDB containers
```

Image clean up needs to be done manually

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> docker image list --all
REPOSITORY        TAG       IMAGE ID       CREATED        SIZE
adminer           latest    fd3b195a8d79   8 hours ago    250MB
bookstore         latest    cbf18a39836f   18 hours ago   482MB
sjfke/bookstore   1.0       cbf18a39836f   18 hours ago   482MB
mariadb           latest    3e87f8bfed4e   7 weeks ago    404MB

PS C:\Users\sjfke> docker image rm adminer 
PS C:\Users\sjfke> docker image rm bookstore
PS C:\Users\sjfke> docker image rm sjfke/bookstore:1.0
PS C:\Users\sjfke> docker image rm mariadb

docker image list --all
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
```
