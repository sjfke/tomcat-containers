# tomcat-containers - [edit on Github](https://github.com/sjfke/tomcat-containers/#readme)

Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB

## Project Objectives

The aim is to deploy a tomcat application that uses MariaDB in a containerized environment.

Separate containers will be used for the database, adminer tool, tomcat, and docker-compose will be used to deploy the containers.
The working docker-desktop implementation based on docker-compose with then be [migrated to podman-desktop](https://fedoramagazine.org/docker-and-fedora-37-migrating-to-podman/). 

The tomcat application is an implementation of [CodeJava Tutorial - JSP Servlet JDBC MySQL Create Read Update Delete (CRUD) Example](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example)

## Project Organization

### Wharf - where are the containerization information is stored

> Wharf
>> A platform along the side of a waterfront for docking, loading, and unloading ships

### Wharf Documentation Organization

* [BUILD](./wharf/BUILD.md)  - Setup and build within Eclipse, plus corrections to the `CodeJava Tutorial`.
* [CONTAINERS](./wharf/CONTAINERS.md) - How to build and deploy `Bookstore` container image to Quay.IO and DockerHub.
* [DOCKER](./wharf/DOCKER.md) - How to build and test `Bookstore` using Docker, Docker Compose.
* [MAVEN](./wharf/MAVEN.md)  - How to build and test `Bookstore` using Maven inside Eclipse.
* [PODMAN](./wharf/PODMAN.md)  - How to test `Bookstore` using Podman Kube Play and podman-compose.py

```text
C:\USERS\SJFKE\GITHUB\TOMCAT-CONTAINERS\WHARF
│   .classpath
│   .gitignore
│   .project
│   BUILD.md
│   DOCKER.md
│   ECLIPSE.md
│   MARIADB.md
│   MAVEN.md
│   PODMAN-KUBE.md
│   PODMAN.md
│   TOMCAT.md
│
├───.settings
│       .jsdtscope
│       org.eclipse.jdt.core.prefs
│       org.eclipse.wst.common.component
│       org.eclipse.wst.common.project.facet.core.xml
│       org.eclipse.wst.jsdt.ui.superType.container
│       org.eclipse.wst.jsdt.ui.superType.name
│
├───build
│   └───classes
├───Docker
│   ├───conf
│   │       tomcat-users.xml
│   │
│   └───webapps
│       ├───Bookstore
│       │   └───WEB-INF
│       │           web.xml
│       │
│       ├───host-manager
│       │   └───META-INF
│       │           context.xml
│       │
│       └───manager
│           └───META-INF
│                   context.xml
│
├───Podman
│   │   adminer-deployment.yaml
│   │   bookstore-deployment.yaml
│   │   bookstoredb-configmap-deployment.yaml
│   │   bookstoredb-deployment.yaml
│   │   bookstoredb-external-configmap-deployment.yaml
│   │   busybox-deployment.yaml
│   │   configmap.yaml
│   │   docker-compose.yaml
│   │   docker-podman-compose.yaml
│   │   Dockerfile
│   │   mariadb-deployment.yaml
│   │   Podman-basics-cheat-sheet-Red-Hat-Developer.pdf
│   │   podman-for-windows.html
│   │   secrets.yaml
│   │
│   ├───generated
│   │       adminer-deployment-service.yaml
│   │       adminer-deployment.yaml
│   │       adminer-pod-service.yaml
│   │       adminer-pod.yaml
│   │       bookstore-deployment-service.yaml
│   │       bookstore-deployment.yaml
│   │       bookstore-pod-service.yaml
│   │       bookstore-pod.yaml
│   │       bookstoredb-deployment-service.yaml
│   │       bookstoredb-deployment.yaml
│   │       bookstoredb-pod-service.yaml
│   │       bookstoredb-pod.yaml
│   │
│   └───inspect
│           adminer-inspect.json
│           bookstore-inspect.json
│           bookstoredb-inspect.json
│           tomcat-containers_jspnet.yaml
│
└───src
    └───main
        ├───java
        └───webapp
            ├───META-INF
            │       MANIFEST.MF
            │
            └───WEB-INF
                └───lib
```
