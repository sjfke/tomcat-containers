# tomcat-containers
Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB

# Project Preperation

## MariaDB in Docker

* The docker compose command will take the folder name of as the **_container__** name, so `compose.yaml` is not in `wharf` folder.
* A permenant volume, `jsp_bookstoredata` is created using `docker-desktop Volumes` tab

### MariaDB Docker Compose file
```yaml
version: "3.9"
services:
  # Use root/r00tpa55 as user/password credentials
  bookstoredb:
    image: mariadb
    restart: unless-stopped
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
```bash
$ docker compose down --rmi local; docker compose build; docker compose up -d
```

# General Docker Compose Notes

## Typical command usage

```bash
# Once compose.yaml is created, see references (ii, iii)
$ docker compose build
$ docker compose up -d 
$ docker compose down

# Either of the following is more compact
$ docker compose down --rmi local; docker compose build; docker compose up -d
$ docker compose down --rmi local; docker compose up -d --build
```

1. [Docker: Overview of Docker Compose](https://docs.docker.com/compose/)
2. [Docker: Compose specification](https://docs.docker.com/compose/compose-file)
3. [Docker: Compose specification - ports](https://docs.docker.com/compose/compose-file/#ports)

## Docker Image Maintenance

```
$ docker image prune # clean up dangling images
$ docker system prune 
$ docker rmi $(docker images -f 'dangling=true' -q) # bash only, images with no tags
```

## Docker Compose Networking

Unless configured otherwise choose a subnet from the [172.16/12 (172.16.0.0 - 172.31.255.255)](https://www.ietf.org/rfc/rfc1918.txt) IP space.

```
$ docker network ls              # list docker networks by name
$ docker inspect <network-name>  # details of network.
```

A good introduction [Docker-compose bridge network subnet](https://bobcares.com/blog/docker-compose-bridge-network-subnet/), and 
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

# Project Documentation Organization

```
C:\USERS\SJFKE\TOMCAT-CONTAINERS\WHARF
├───Docker
│   ├───conf
│   └───webapps
│       └───manager
│           └───META-INF
└───Podman
```

# Docker Folder

Contains files and notes relating to setting up `Tomcat` and deploying the `Booktore` the application.

The `Official Tomcat Docker` container, disables pretty much everything so all you see is a '403' or '404' error response once it is deployed.
This is a development example, so `Dockerfile` restores much of this functionality.

## Docker MySQL connection

```
jdbc:mysql://SERVICE-NAME:3306/DATABASE-NAME
```
Change to `webapps/Bookstore/WEB-INF/web.xml`

```xml
	<context-param>
		<param-name>jdbcURL</param-name>
		<param-value>jdbc:mysql://bookstoredb:3306/Bookstore</param-value>
	</context-param>
```

## Docker configuration files

* `conf/tomcat-users.xml` grants access to the roles="manager-gui,admin-gui";
* `webapps/manager/META-INF/context.xml` grants access to the localhost network and the 172 RFC-1918 space used by Docker networking;
* `webapps/Bookstore/WEB-INF/web.xml` to access the MySQL database in docker-compose network;

  