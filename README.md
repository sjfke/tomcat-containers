# tomcat-containers
Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB

# Project Objectives

The aim is to deploy a tomcat application that uses MariaDB in a containerized environment.

Separate containers will be used for the database, adminer tool, tomcat, and docker-compose will be used to deploy the containers.
The working docker-desktop implementation based on docker-compose with then be [migrated to podman-desktop](https://fedoramagazine.org/docker-and-fedora-37-migrating-to-podman/). 

The tomcat application is an implementation of [CodeJava Tutorial - JSP Servlet JDBC MySQL Create Read Update Delete (CRUD) Example](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example)

# Project Organization

## Wharf - where are the containerization information is stored.

> Wharf
>> A platform along the side of a waterfront for docking, loading, and unloading ships

## Wharf Documentation Organization

* `BUILD_ME`  - Notes on setup and build within Eclipse, plus corrections to the `CodeJava Tutorial`.
* `DOCKER_ME` - Notes on how to build and deploy using Docker, Docker Compose.
* `MAVEN_ME`  - Notes on how to build using Maven inside Eclipse and deploy.

```
C:\USERS\SJFKE\TOMCAT-CONTAINERS\WHARF
│   BUILD_ME.md
│   DOCKER_ME.md
│   MAVEN_ME.md
│
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
└───Podman
```
