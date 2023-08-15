# Setup for tomcat-containers

Docker set up for [Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) development.

## Project Preperation

The project uses `Docker` and `Docker Compose` configuration files.

## Docker Desktop Installation on various platforms

On Windows `Docker Desktop` can use Hyper-V and Windows containers or Windows Subsystem for Linux (WSLv2) and Linux containers.

On MacOS `Docker Desktop` can also be installed using `brew` rather than the *official* way. A `brew` install is a better solution and probably more consistent with your developer setup on MacOS

```console
sjfke> brew install --cask docker    # install
# Start via 'launchpad'              # or sjfke> open /Applications/Docker.app
sjfke> brew uninstall --cask docker  # uninstall
```

* [Install Docker Desktop on Mac](https://docs.docker.com/desktop/install/mac-install/)
* [Install Docker Desktop on Windows](https://docs.docker.com/desktop/install/windows-install/)
* [Install Docker Desktop on Linux](https://docs.docker.com/desktop/install/linux-install/)

## Windows Platform Setup

Follow the instructions in [Install Docker Desktop on Windows](https://docs.docker.com/desktop/install/windows-install/), the author uses 'WSL' which does not require a `Windows Pro` installation.

## Docker and Docker Configuration Files

### MariaDB in Docker

* The docker compose command will take the folder name of as the **_container__** name, so `compose.yaml` is not in `wharf` folder.
* A permenant volume, `jsp_bookstoredata` is created using `Docker-Desktop` > `Volumes` tab.

#### MariaDB Docker Compose file

```yaml
version: "3.9"
services:
  # Use root/r00tpa55 as user/password credentials
  bookstoredb:
    image: mariadb
    restart: unless-stopped
    ports:
      - 3306:3306
    environment:
      MARIADB_ROOT_PASSWORD: r00tpa55
    networks:
      - jspnet
    volumes:
      - jsp_bookstoredata:/var/lib/mysql

  adminer:
    image: adminer
    restart: unless-stopped
    ports:
      - 8395:8080
    networks:
      - jspnet

networks:
  jspnet:
    driver: bridge

volumes:
  jsp_bookstoredata:
    external: true
```

Create the containers

```console
PS C:\Users\sjfke> docker compose down --rmi local; docker compose build; docker compose up -d
```

## Tomcat and Bookstore application in Docker

Consult the [Dockerfile](../Dockerfile) for details of the deployment.

Any files which need to be replaced for Docker to work are in the `Docker` folder.

### Docker Folder

It contains all the modified files to set up `Tomcat` and deploying the `Bookstore` the application.

The [Official Tomcat Docker](https://hub.docker.com/_/tomcat) container, disables pretty much everything so all you see is a '403' or '404' error response once it is deployed.

This is a development environment, so `Dockerfile` restores much of this functionality, key extracts follow:

```text
# Setup Tomcat in a development configuration
RUN mv webapps webapps.safe
RUN mv webapps.dist/ webapps
COPY ./wharf/Docker/webapps/manager/META-INF/context.xml /usr/local/tomcat/webapps/manager/META-INF/
COPY ./wharf/Docker/webapps/host-manager/META-INF/context.xml /usr/local/tomcat/webapps/host-manager/META-INF/
COPY ./wharf/Docker/conf/tomcat-users.xml /usr/local/tomcat/conf/
RUN chmod 644 /usr/local/tomcat/conf/tomcat-users.xml
```

* `webapps/manager/META-INF/context.xml` grants access to the localhost and the RFC-1918 space used by Docker networking;
* `webapps/host-manager/META-INF/context.xml` grants access to the localhost and the RFC-1918 space used by Docker networking;
* `conf/tomcat-users.xml` grants access to the roles="manager-gui,admin-gui" to username="admin";
* `webapps/Bookstore/WEB-INF/web.xml` to access the MySQL database in docker-compose network;

> #### Note
>
> The container file system is read-only, so some `tomcat manager` and `tomcat host-manager` actions fail.

The docker deployment of `Bookstore` needs to connect to the `bookstoredb` container, not `localhost`, so different `web.xml` is used.

```text
# Deploy the Bookstore application, using the output of the Maven build
# Modified web.xml changes jdbc:mysql for Docker, 'jdbc:mysql://SERVICE-NAME:3306/DATABASE-NAME'
COPY ./Bookstore/target/Bookstore-0.0.1-SNAPSHOT/ /usr/local/tomcat/webapps/Bookstore
COPY ./wharf/Docker/webapps/Bookstore/WEB-INF/web.xml /usr/local/tomcat/webapps/Bookstore/WEB-INF/web.xml
```

### Docker MySQL connection

```xml
jdbc:mysql://SERVICE-NAME:3306/DATABASE-NAME
```

Change to `webapps/Bookstore/WEB-INF/web.xml`

```xml
  <context-param>
    <param-name>jdbcURL</param-name>
    <param-value>jdbc:mysql://bookstoredb:3306/Bookstore</param-value>
  </context-param>
```

## Deploying Bookstore using Docker

To keep the Docker file simple, the output of the `maven` build within Eclipse is copied to the `Bookstore` webapp, 
and the `web.xml` file is replaced with one that has the correct `jdbcURL`.

```text
# Deploy the Bookstore application, using the output of the Maven build
# Modified web.xml changes jdbc:mysql for Docker, 'jdbc:mysql://SERVICE-NAME:3306/DATABASE-NAME'
COPY ./Bookstore/target/Bookstore-0.0.1-SNAPSHOT/ /usr/local/tomcat/webapps/Bookstore
COPY ./wharf/Docker/webapps/Bookstore/WEB-INF/web.xml /usr/local/tomcat/webapps/Bookstore/WEB-INF/web.xml
```

> #### Note
>
> * It is possible to install `maven` locally and execute the build using Docker.
> * There is also a [Dockerhub maven official image](https://hub.docker.com/_/maven) if you want to containerize the `maven` build.

## General Docker and Docker Compose Notes

### Typical command usage

```console
# Once compose.yaml is created, see references (ii, iii)
PS C:\Users\sjfke> docker compose build
PS C:\Users\sjfke> docker compose up -d 
PS C:\Users\sjfke> docker compose down

# Either of the following is more compact
PS C:\Users\sjfke> docker compose down --rmi local; docker compose build; docker compose up -d
PS C:\Users\sjfke> docker compose down --rmi local; docker compose up -d --build
```

* [Docker: Reference documentation](https://docs.docker.com/reference/)
* [Docker: Overview of Docker Compose](https://docs.docker.com/compose/)
* [Docker: Compose specification](https://docs.docker.com/compose/compose-file)

## Docker Image Maintenance

```console
PS C:\Users\sjfke> docker image prune    # clean up dangling images
PS C:\Users\sjfke> docker system prune 
PS C:\Users\sjfke> docker rmi $(docker images -f 'dangling=true' -q) # bash only, images with no tags
```

## Docker Compose Networking

Unless explicitly configured otherwise `docker compose` will choose a subnet from the [RFC-1918 IP Space](https://www.ietf.org/rfc/rfc1918.txt), i.e 172.16/12, 192.168/16 or 10.0/8.

```console
PS C:\Users\sjfke> docker network ls              # list docker networks by name
PS C:\Users\sjfke> docker inspect <network-name>  # details of network.
```

A good introduction [Docker-compose bridge network subnet](https://bobcares.com/blog/docker-compose-bridge-network-subnet/).

[One compose file solution](https://stackoverflow.com/questions/53949616/networks-created-by-docker-compose-do-not-respect-dockers-subnet-settings), 
becareful about IP range clashes.

```yaml
networks:
  default:
    driver: bridge
    ipam:
      driver: default
      config:
      - subnet:  10.103.0.1/16
```

## Docker Reference Documentation

* [Docker Reference documentation](https://docs.docker.com/reference/);
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/);
* [Docker Compose file build reference](https://docs.docker.com/compose/compose-file/build/)
