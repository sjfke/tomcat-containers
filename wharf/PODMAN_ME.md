# tomcat-containers
Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB

# Migrating the Bookstore Application

Based on the article [Docker-Desktop to Podman-Desktop migration](https://fedoramagazine.org/docker-and-fedora-37-migrating-to-podman/).

## Windows Platform

* [Docker-Desktop](https://www.docker.com/products/docker-desktop/) version v4.16.3
* [Podman-Desktop](https://github.com/containers/podman-desktop/releases/download/v0.11.0/podman-desktop-0.11.0-setup.exe) version 0.11.0 or `winget install -e --id RedHat.Podman-Desktop`
* [Windows 11 Home Version 22H2](https://learn.microsoft.com/en-us/windows/whats-new/whats-new-windows-11-version-22h2)
* [WSL version: 1.0.3.0](https://learn.microsoft.com/en-us/windows/wsl/install)

## MacOS Platform (Intel)

* [Docker-Desktop](https://www.docker.com/products/docker-desktop/) version v4.16.2
* [Podman-Desktop](https://github.com/containers/podman-desktop/releases/download/v0.11.0/podman-desktop-0.11.0-x64.dmg) version 0.11.0 or `$ brew install podman-desktop`
* MacOS
* Kubernetes

## Fedora 37 Platform

* [Podman-Desktop](https://github.com/containers/podman-desktop/releases/download/v0.11.0/podman-desktop-0.11.0.flatpak) version 0.11.0

```
gcollis@morpheus docker2podman]$ sudo dnf list installed | grep podman
podman.x86_64                                        4:4.3.1-1.fc37                      @updates                  
podman-compose.noarch                                1.0.3-6.fc37                        @fedora                   
podman-gvproxy.x86_64                                4:4.3.1-1.fc37                      @updates                  
podman-plugins.x86_64                                4:4.3.1-1.fc37                      @updates                
```

## Docker Setup

See [DOCKER_ME.md](./DOCKER_ME.md) for docker notes and how to redeploy the docker containers.

# Podman and Podman-Desktop Windows installation

First install `podman` and once it is working then install `podman-desktop`.

## Installing Podman

Follow the `GitHub` instructions.

* [Podman for Windows](https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md)

Download and install [`podman-4.3.1-setup.exe`](https://github.com/containers/podman/releases/download/v4.3.1/podman-4.3.1-setup.exe)

After install `Close & Open Guide` and follow [Podman for Windows](./Podman/podman-for-windows.html) instructions.

```
$ podman machine init   # Downloading VM image: fedora-podman-v36.0.117.tar.xz: done

$ podman machine start  # Starting machine "podman-machine-default"

This machine is currently configured in rootless mode. If your containers
require root permissions (e.g. ports < 1024), or if you run into compatibility
issues with non-podman clients, you can switch using the following command:

        podman machine set --rootful

API forwarding listening on: npipe:////./pipe/docker_engine

Docker API clients default to this address. You do not need to set DOCKER_HOST.
Machine "podman-machine-default" started successfully

$ wsl --list --verbose
  NAME                      STATE           VERSION
* Ubuntu                    Stopped         2
  AlmaLinux-8               Stopped         2
  docker-desktop            Stopped         2
  docker-desktop-data       Stopped         2
  podman-machine-default    Running         2

$ podman run ubi8-micro date
Thu Feb  2 16:13:06 UTC 2023

$ podman run --rm -d -p 8080:80 --name httpd docker.io/library/httpd
$ curl http://localhost:8080/ -UseBasicParsing

$ docker run -it fedora echo "Hello Podman!"
Hello Podman!

$ podman run -it fedora echo "Hello Podman!"
Hello Podman!

$ get-command docker # C:\Program Files\Docker\Docker\resources\bin\docker.exe
$ get-command podman # C:\Program Files\RedHat\Podman\podman.exe
```

> #### Note
>
> - There is no **podman-compose** command, on *Fedora* it is an extension that needs to be installed.
 
## Podman References

* [Podman Introduction](https://docs.podman.io/en/latest/Introduction.html)
* [Podman Tutorials](https://docs.podman.io/en/latest/Tutorials.html)
* [Podman for Windows](./Podman/podman-for-windows.html) installation instructions


## Installing Podman-Desktop Windows

Follow the instructions on [Containers and Kubernetes for application developers](https://podman-desktop.io/).

* Download and install [Podman-Desktop](https://podman-desktop.io/downloads/Windows) version 0.11.0

The installation will prompt for any additional steps.

Both applications, `Podman` and `Podman-Desktop` are listed correctly in `Settings` > `Apps` > `Installed apps`.

There is no evidence of any Windows services for `Redhat` or `Podman`.

> Note:
>
> Different WSL virtual machines are being used, and the `docker` command is using the API to the `podman` virtual machine.
>
>> So `Podman-Desktop` does not see any other the `Docker-Desktop` containers or volumes.
>
>> So `Docker-Desktop` sees it's containers or volumes but cannot start them, `docker compose` errors with exit status 1.

## Create MariaDB `jsp_bookstoredata` Volume

[podman-volume - Simple management tool for volumes](https://docs.podman.io/en/latest/markdown/podman-volume.1.html)

```shell
# Fedora-37

$ podman volume create jsp_bookstoredata
$ podman volume exists jsp_bookstoredata # not visible in output but visible in Podman-Desktop?

$ podman volume ls
DRIVER      VOLUME NAME
local       jsp_bookstoredata

$ podman volume inspect jsp_bookstoredata 
[
     {
          "Name": "jsp_bookstoredata",
          "Driver": "local",
          "Mountpoint": "/home/gcollis/.local/share/containers/storage/volumes/jsp_bookstoredata/_data",
          "CreatedAt": "2023-02-03T16:43:34.039774242+01:00",
          "Labels": {},
          "Scope": "local",
          "Options": {},
          "MountCount": 0,
          "NeedsCopyUp": true,
          "NeedsChown": true
     }
]

## Podman Compose Fedora 37

$ podman-compose -f ./docker-compose-platform.yaml up --detach
# Note: `podman-compose`
# Have to select which hub-repos, docker.io, etc
# Fails to deploy bookstore application, trying deploy image, need to build?
```

It deployed the `bookstore-1` MariaDB container, and the `adminer-1` container.
The `podman-desktop` is unstable, keeps becoming unresponsive, copy-n-paste does not work so delete it and use the `flatpack` version.
Using the `podman-desktop (flatpack)` version, build out the MariaDB.

```sql
# mysql -u root -p
create database Bookstore;
use Bookstore

drop table if exists book;
create table book(
  `book_id` int(11) auto_increment primary key not null,
  `title` varchar(128) unique key not null,
  `author` varchar(45) not null,
  `price` float not null
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

insert into book (title, author, price) values ('Thinking in Java', 'Bruce Eckel', '25.69');
select * from book;

create user 'bsapp'@'%' identified by 'P@ssw0rd';
grant all privileges on Bookstore.* to 'bsapp'@'%';
flush privileges;
show grants for 'bsapp'@'%';
exit;

# mysql -u bsapp -p Bookstore
select * from book;
exit;
```

However it did not use the `jsp_bookstoredata` volume but created a new one?

```
$ podman volume ls
DRIVER      VOLUME NAME
local       docker2podman_jsp_bookstoredata
local       jsp_bookstoredata
```

Try the `docker-compose` again and this time it deploys...

```
$ podman-compose -f ./docker-compose-platform.yaml up --detach
['podman', '--version', '']
using podman version: 4.3.1
** excluding:  set()
['podman', 'inspect', '-t', 'image', '-f', '{{.Id}}', 'docker2podman_bookstore']
Error: inspecting object: docker2podman_bookstore: image not known
podman build -t docker2podman_bookstore -f ././Dockerfile .
STEP 1/15: FROM tomcat:9.0.71-jdk17-temurin
✔ docker.io/library/tomcat:9.0.71-jdk17-temurin
Trying to pull docker.io/library/tomcat:9.0.71-jdk17-temurin...
Getting image source signatures
Copying blob 10ac4908093d skipped: already exists  
Copying blob 1f8839e6ed79 done  
Copying blob 8fa912900627 done  
Copying blob f8fe20946c04 done  
Copying blob 6df15e605e38 done  
Copying blob 2db012dd504c done  
Copying blob 0839ea5a8b1a done  
Copying config b07e16b110 done  
Writing manifest to image destination
Storing signatures
STEP 2/15: ENV BUILDER_VERSION 1.0
--> 3cee1b57e6d
STEP 3/15: LABEL io.k8s.name="Bookstore"       io.k8s.description="Tomcat JSP for Docker and Podman testing"       io.k8s.display-name="Bookstore"       io.k8s.version="0.0.1"       io.openshift.expose-services="8080:http"       io.openshift.tags="Tomcat JSP,Bookstore,0.0.1,Docker,Podman"
--> 88f4bb90471
STEP 4/15: ENV PORT=8080
--> 5c3089aa6e6
STEP 5/15: WORKDIR /usr/local/tomcat
--> 0ffe8a8a689
STEP 6/15: RUN mv webapps webapps.safe
--> c109a3f21aa
STEP 7/15: RUN mv webapps.dist/ webapps
--> d56ee3c0acd
STEP 8/15: COPY ./wharf/Docker/webapps/manager/META-INF/context.xml /usr/local/tomcat/webapps/manager/META-INF/
--> 57d16dff3df
STEP 9/15: COPY ./wharf/Docker/webapps/host-manager/META-INF/context.xml /usr/local/tomcat/webapps/host-manager/META-INF/
--> a686dc17907
STEP 10/15: COPY ./wharf/Docker/conf/tomcat-users.xml /usr/local/tomcat/conf/
--> a3507e60bc3
STEP 11/15: RUN chmod 644 /usr/local/tomcat/conf/tomcat-users.xml
--> d1091904213
STEP 12/15: COPY ./Bookstore/target/Bookstore-0.0.1-SNAPSHOT/ /usr/local/tomcat/webapps/Bookstore
--> 090999dc515
STEP 13/15: COPY ./wharf/Docker/webapps/Bookstore/WEB-INF/web.xml /usr/local/tomcat/webapps/Bookstore/WEB-INF/web.xml
--> 07ae33c17eb
STEP 14/15: USER 1
--> 987e3dfdc6e
STEP 15/15: CMD ["catalina.sh", "run"]
COMMIT docker2podman_bookstore
--> 7f051cd00bc
Successfully tagged localhost/docker2podman_bookstore:latest
7f051cd00bc6e2c68b343c844fc596408827667687c545a4b1d4326ce18653e8
exit code: 0
['podman', 'network', 'exists', 'docker2podman_jspnet']
podman run --name=docker2podman_bookstoredb_1 -d --label io.podman.compose.config-hash=123 --label io.podman.compose.project=docker2podman --label io.podman.compose.version=0.0.1 --label com.docker.compose.project=docker2podman --label com.docker.compose.project.working_dir=/home/gcollis/Sandbox/docker2podman --label com.docker.compose.project.config_files=./docker-compose-platform.yaml --label com.docker.compose.container-number=1 --label com.docker.compose.service=bookstoredb -e MARIADB_ROOT_PASSWORD=r00tpa55 -v docker2podman_jsp_bookstoredata:/var/lib/mysql --net docker2podman_jspnet --network-alias bookstoredb -p 3306:3306 --restart unless-stopped mariadb
9bc656b6e253d71ffbcf01c06a0f0f0e15538fd38a42171fd5765a766ad1a1de
exit code: 0
['podman', 'network', 'exists', 'docker2podman_jspnet']
podman run --name=docker2podman_bookstore_1 -d --label io.podman.compose.config-hash=123 --label io.podman.compose.project=docker2podman --label io.podman.compose.version=0.0.1 --label com.docker.compose.project=docker2podman --label com.docker.compose.project.working_dir=/home/gcollis/Sandbox/docker2podman --label com.docker.compose.project.config_files=./docker-compose-platform.yaml --label com.docker.compose.container-number=1 --label com.docker.compose.service=bookstore --net docker2podman_jspnet --network-alias bookstore -p 8395:8080 docker2podman_bookstore
4505638e1f469189c387f7a896484122f5ba0589d69321d6030a9536264caa90
exit code: 0
['podman', 'network', 'exists', 'docker2podman_jspnet']
podman run --name=docker2podman_adminer_1 -d --label io.podman.compose.config-hash=123 --label io.podman.compose.project=docker2podman --label io.podman.compose.version=0.0.1 --label com.docker.compose.project=docker2podman --label com.docker.compose.project.working_dir=/home/gcollis/Sandbox/docker2podman --label com.docker.compose.project.config_files=./docker-compose-platform.yaml --label com.docker.compose.container-number=1 --label com.docker.compose.service=adminer --net docker2podman_jspnet --network-alias adminer -p 8397:8080 --restart unless-stopped adminer
d85c5f1b28298f13c44a72ea6144903a325747c76a14d116b719fa6a0702157f
exit code: 0
```

Next steps work through POD's and create a podman compose file?

## Windows 11 cruft to clean
 
```
# Windows-11

PS1> podman volume create jsp_bookstoredata
PS1> podman volume exists jsp_bookstoredata # not visible in output nor in Podman-Desktop?

$ podman volume create jsp_bookstoredata
$ podman volume exists jsp_bookstoredata # not visible in output but visible in Podman-Desktop?

$ podman volume ls
DRIVER      VOLUME NAME
local       jsp_bookstoredata

$ podman volume inspect jsp_bookstoredata
[
     {
          "Name": "jsp_bookstoredata",
          "Driver": "local",
          "Mountpoint": "/home/user/.local/share/containers/storage/volumes/jsp_bookstoredata/_data",
          "CreatedAt": "2023-02-03T09:51:33.113178179+01:00",
          "Labels": {},
          "Scope": "local",
          "Options": {},
          "MountCount": 0,
          "NeedsCopyUp": true,
          "NeedsChown": true
     }
]
```

## Docker-Compose files

Compose files are Docker specific and they can’t be used with Podman.

```
$ podman-compose -f ./docker-compose-platform.yaml up --detach # no podman-compose command
$ podman compose -f ./docker-compose-platform.yaml up --detach # no podman-compose command
Error: unrecognized command `podman.exe compose`

# on F37 had to install the extension `podman-compose`
```

[How to Run Podman and Docker-Compose on Windows] (https://hackernoon.com/how-to-run-podman-and-docker-compose-on-windows)

```
$ docker compose up
[+] Running 2/19
 - adminer     Pulled 33.0s
 - bookstoredb Pulled 22.3s
[+] Building 25.2s (1/1) FINISHED
 => ERROR [internal] booting buildkit                                                                                                                            25.2s
 => => pulling image moby/buildkit:buildx-stable-1                                                                                                               23.6s
 => => creating container buildx_buildkit_default                                                                                                                 1.6s
------
 > [internal] booting buildkit:
------
Error response from daemon: crun: creating cgroup directory `/sys/fs/cgroup/misc/docker/buildx/libpod-aa4302be3367c5679f58fa53e27fab324f1c824240bb230e48cf7754548602a3`: No such file or directory: OCI runtime attempted to invoke a command that was not found
```

## Next steps

1. Build out MariaDB, Adminer in podman
2. Convert compose file as per the article. 

# Clean Up Previous Install.

```
$ wsl --list --verbose
  NAME                      STATE           VERSION
* Ubuntu                    Stopped         2
  AlmaLinux-8               Stopped         2
  docker-desktop            Stopped         2
  podman-machine-default    Stopped         2
  docker-desktop-data       Stopped         2
```

```
$ wsl --unregister  podman-machine-default
Unregistering.
The operation completed successfully.
$ wsl --list --verbose
  NAME                   STATE           VERSION
* Ubuntu                 Stopped         2
  AlmaLinux-8            Stopped         2
  docker-desktop         Stopped         2
  docker-desktop-data    Stopped         2
```

Reboot to clean up everything... but still broken, needed the following steps to clean up.

```
$ podman machine info                      # Still see's podman-machine-default
$ podman machine init                      # Error: podman-machine-default: VM already exists
$ podman machine inspect                   # podman-machine-default as stopped
$ podman machine start                     # Starting machine "podman-machine-default", no distribution with the supplied name.
$ podman machine rm podman-machine-default # Delete it
$ podman machine inspect                   # Error: podman-machine-default: VM does not exist
```

