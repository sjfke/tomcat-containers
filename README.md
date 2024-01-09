# tomcat-containers - [edit on Github](https://github.com/sjfke/tomcat-containers/#readme)

Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB

## Project Objectives

The aim is to deploy a tomcat application that uses MariaDB in a containerized environment.

Separate containers will be used for the database, adminer tool, tomcat, and docker-compose will be used to deploy the containers.
The working docker-desktop implementation based on docker-compose with then be [migrated to podman-desktop](https://fedoramagazine.org/docker-and-fedora-37-migrating-to-podman/). 

The tomcat application is an implementation of [CodeJava Tutorial - JSP Servlet JDBC MySQL Create Read Update Delete (CRUD) Example](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example)

## Project Organization

### Application

Folders

* [Bookstore](./Bookstore/) - Folder for Java and JSP source code
* [Servers](./Servers/) - Folder for Tomcat servers available within Eclipse
* [tomcat](./tomcat/) - Folder for Tomcat downloaded and installed by Eclipse
* [wharf](./wharf) - Folder for all the documentation and howto's

### Wharf - where are the containerization information is stored

> Wharf
>> A platform along the side of a waterfront for docking, loading, and unloading ships

### Wharf Folder

#### HOW-TO Documentation

* [BUILD](./wharf/BUILD.md)  - Setup and build within Eclipse, plus corrections to the `CodeJava Tutorial`.
* [CONTAINERS](./wharf/CONTAINERS.md) - How to build and deploy `Bookstore` container image to Quay.IO and DockerHub.
* [DOCKER](./wharf/DOCKER.md) - How to build and test `Bookstore` using Docker, Docker Compose.
* [MAVEN](./wharf/MAVEN.md)  - How to build and test `Bookstore` using Maven inside Eclipse.
* [PODMAN](./wharf/PODMAN.md)  - How to test `Bookstore` using Podman Kube Play and podman-compose.py
* [PODMAN-KUBE](./wharf/PODMAN-KUBE.md) - How to create and use `podman play kube` to test `Bookstore`
* [TOMCAT](./wharf/TOMCAT.md) - How to setup standalone Tomcat to test `Bokkstore` maven builds

##### Folders

* [DOCKER](./wharf/DOCKER) - updates used to deploy `Bookstore` using Docker
* [PODMAN](./wharf/Podman/) - Podman build and deployment
* [PODMAN/generated](./wharf/Podman/generated) - `podman kube generate` files from `podman-compose.py` deployment
* [PODMAN/inspect](./wharf/Podman/inspect) - `podman inspect` from `podman-compose.py` deployment

##### Podman Files

* [adminer-deployment.yaml](./wharf/Podman/adminer-deployment.yaml)
* [bookstore-deployment.yaml](./wharf/Podman/bookstore-deployment.yaml)
* [bookstoredb-configmap-deployment.yaml](./wharf/Podman/bookstoredb-configmap-deployment.yaml)
* [bookstoredb-deployment.yaml](./wharf/Podman/bookstoredb-deployment.yaml)
* [bookstoredb-external-configmap-deployment.yaml](./wharf/Podman/bookstoredb-external-configmap-deployment.yaml)
* [busybox-deployment.yaml](./wharf/Podman/busybox-deployment.yaml)
* [configmap.yaml](./wharf/Podman/configmap.yaml)
* [docker-bookstore-deployment.yaml](./wharf/Podman/docker-bookstore-deployment.yaml)
* [docker-compose.yaml](./wharf/Podman/docker-compose.yaml)
* [docker-podman-compose.yaml](./wharf/Podman/docker-podman-compose.yaml)
* [mariadb-deployment.yaml](./wharf/Podman/mariadb-deployment.yaml)
* [quay-io-bookstore-deployment.yaml](./wharf/Podman/quay-io-bookstore-deployment.yaml)
* [secrets.yaml](./wharf/Podman/secrets.yaml)
