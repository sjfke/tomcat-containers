# tomcat-containers - [edit on Github](https://github.com/sjfke/tomcat-containers/#readme)

Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB

## Project Objectives

The aim is to deploy a tomcat application that uses MariaDB in a containerized environment.

Separate containers will be used for:

* `bookstore` the tomcat application
* `bookstoredb` the database
* `adminer` the web interface used for database administration

The containers can be deployed using

* [Docker](https://www.docker.com/) and [docker compose](https://docs.docker.com/compose/compose-file/)
* [Podman](https://podman.io/) and the Python script [podman-compose](https://github.com/containers/podman-compose)
* [Kubernetes Pods](https://kubernetes.io/docs/concepts/workloads/pods/) with [podman kube play](https://docs.podman.io/en/latest/markdown/podman-kube-play.1.html)

The tomcat application is an implementation of [CodeJava Tutorial - JSP Servlet JDBC MySQL Create Read Update Delete (CRUD) Example](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example)

### Walk Through Sequence

To do the project yourself

1. First [git clone](https://git-scm.com/docs/git-clone) the [tomcat-containers repository](https://github.com/sjfke/tomcat-containers)
2. Setup Development Environment
    * Install [Eclipse](https://www.eclipse.org/downloads/) following [Eclipse HOW-TO](./wharf/ECLIPSE.md)
    * Install [Tomcat](https://tomcat.apache.org/) following [Tomcat HOW-TO](./wharf/TOMCAT.md)
    * Install [Maven](https://maven.apache.org/index.html) following [Maven HOW-TO](./wharf/MAVEN.md)
3. Install Container Environment and Build the Application
    * [Build HOW-TO](./wharf/BUILD.md)
    * [Docker HOW-TO](./wharf/DOCKER.md) to install and use [Docker](https://www.docker.com/)
    * [Podman HOW-TO](./wharf/PODMAN.md) to install and use [Podman](https://podman.io/)
    * [MariaDB HOW-TO](./wharf/MARIADB.md)
4. Containerize and Publish `Bookstore`
    * [Containers HOW-TO](./wharf/CONTAINERS.md)

## Project Organization

### Application

The folder organization is an `Eclipse` project, with the following key folders.

* [Bookstore](./Bookstore/) - Folder for Java and JSP source code
* [Servers](./Servers/) - Folder for Tomcat servers available within Eclipse
* [tomcat](./tomcat/) - Folder for Tomcat downloaded and installed by Eclipse
* [wharf](./wharf) - Folder for all the documentation, howto's and working notes

### Wharf - where are the containerization information is stored

> Wharf: a platform along the side of a waterfront for docking, loading, and unloading ships

### Wharf Folder

#### HOW-TO Documentation

* [`BUILD.md`](./wharf/BUILD.md)  - Setup and build within Eclipse, plus corrections to the `CodeJava Tutorial`
* [`CONTAINERS.md`](./wharf/CONTAINERS.md) - How to build and deploy `Bookstore` container image to Quay.IO and DockerHub.
* [`DOCKER.md`](./wharf/DOCKER.md) - How to build and test `Bookstore` using Docker, Docker Compose
* [`ECLIPSE.md`](./wharf/ECLIPSE.md) - Eclipse setup
* [`MARIADB.md`](./wharf/MARIADB.md)  - Install `MariaDB` container
* [`MAVEN.md`](./wharf/MAVEN.md)  - Installing `maven` and configuring the version included with `Eclipse`
* [`TOMCAT.md`](./wharf/TOMCAT.md) - How to setup standalone Tomcat to test `Bookstore` maven builds
* [`PODMAN-KUBE.md`](./wharf/PODMAN-KUBE.md) - How to create and use `podman play kube` to test `Bookstore`
* [`PODMAN.md`](./wharf/PODMAN.md)  - How to test `Bookstore` using Podman Kube Play and podman-compose.py

#### Folders

* [Docker](./wharf/DOCKER) - updates used to deploy `Bookstore` using Docker
* [Podman](./wharf/Podman/) - Podman build and deployment
* [Podman/generated](./wharf/Podman/generated) - `podman kube generate` files from `podman-compose.py` deployment
* [Podman/inspect](./wharf/Podman/inspect) - `podman inspect` from `podman-compose.py` deployment
* [Registry](./wharf/Registry/) - rough notes on a local `registry` using [GitHub - Distribution](https://github.com/distribution/distribution)

#### Podman Files in [Podman](./wharf/Podman/)

Working folder of all the manifest files used in testing `podman play kube`, which provides, sometimes limited, support for the following Kubernetes API's

* [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
* [Pods](https://kubernetes.io/docs/concepts/workloads/pods/)
* [configMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
* [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
* [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)

##### Kubernetes files

> Note: The most important Kubernetes files are copied to the application folder, and are referenced in the [Containers HOW-TO](./wharf/CONTAINERS.md)

* [adminer-deployment.yaml](./wharf/Podman/adminer-deployment.yaml) `adminer` deployment
* [adminer-pod.yaml](./wharf/Podman/adminer-pod.yaml) `adminer` pod
* [bookstore-deployment.yaml](./wharf/Podman/bookstore-deployment.yaml) `bookstore` deployment
* [bookstore-no-image-pod.yaml](./wharf/Podman/bookstore-no-image-pod.yaml) replaceable `IMAGE_NAME` to test multiple container images, see [Containers HOW-TO](./wharf/CONTAINERS.md)
* [bookstore-pod.yaml](./wharf/Podman/bookstore-pod.yaml) `bookstore` using a pod

* [bookstoredb-configmap-pod.yaml](./wharf/Podman/bookstoredb-configmap-pod.yaml) `bookstoredb` pod containing its own `configMap`
* [bookstoredb-deployment.yaml](./wharf/Podman/bookstoredb-deployment.yaml) `bookstoredb` deployment using predefined `volume`, `configMap` and `secret`
* [bookstoredb-external-configmap-pod.yaml](./wharf/Podman/bookstoredb-external-configmap-pod.yaml) `bookstoredb` pod using an external `configMap` file
* [bookstoredb-pod.yaml](./wharf/Podman/bookstoredb-pod.yaml) `bookstoredb` pod using predefined `volume`, `configMap` and `secret`

* [busybox-deployment.yaml](./wharf/Podman/busybox-deployment.yaml) example `busybox` deployment
* [configmap.yaml](./wharf/Podman/configmap.yaml) the predefined `configMap` file

* [mariadb-deployment.yaml](./wharf/Podman/mariadb-deployment.yaml) `mariadb` deployment used for testing within Eclipse
* [docker-bookstore-deployment.yaml](./wharf/Podman/docker-bookstore-deployment.yaml) deploys `docker/sjfke/bookstore:1.0`
* [quay-io-bookstore-deployment.yaml](./wharf/Podman/quay-io-bookstore-deployment.yaml) `bookstore` deployment, deploys `quay.io/sjfke/bookstore:1.0`
* [secrets.yaml](./wharf/Podman/secrets.yaml) the predefined `secrets` file

Only work from application folder

* [docker-compose.yaml](./wharf/Podman/docker-compose.yaml) `docker compose` file
* [docker-podman-compose.yaml](./wharf/Podman/docker-podman-compose.yaml) modified `docker compose` file, deploys `localhost/tomcat-containers_bookstore`
* [Dockerfile](./wharf/Podman/Dockerfile) `docker` file (or `Containerfile`)

##### Useful references

* [podman kube play](https://docs.podman.io/en/latest/markdown/podman-kube-play.1.html)
* [Podman Basics Cheat-Sheet](./wharf/Podman/Podman-basics-cheat-sheet-Red-Hat-Developer.pdf)
* [Podman for Windows](./wharf/Podman/podman-for-windows.html)