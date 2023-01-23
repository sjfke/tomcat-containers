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

```bash
$ docker image prune # clean up dangling images
$ docker system prune 
$ docker rmi $(docker images -f 'dangling=true' -q) # bash only, images with no tags
```