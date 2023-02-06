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

Delete all traces of first attempt, containers, pods, and no bookstore *but* `localhost/docker2podman_bookstore` image reused.

```
$ podman-compose -f ./docker-compose-platform.yaml up --detach
'podman', '--version', '']
using podman version: 4.3.1
** excluding:  set()
['podman', 'inspect', '-t', 'image', '-f', '{{.Id}}', 'docker2podman_bookstore']
['podman', 'network', 'exists', 'docker2podman_jspnet']
podman run --name=docker2podman_bookstoredb_1 -d --label io.podman.compose.config-hash=123 --label io.podman.compose.project=docker2podman --label io.podman.compose.version=0.0.1 --label com.docker.compose.project=docker2podman --label com.docker.compose.project.working_dir=/home/gcollis/Sandbox/docker2podman --label com.docker.compose.project.config_files=./docker-compose-platform.yaml --label com.docker.compose.container-number=1 --label com.docker.compose.service=bookstoredb -e MARIADB_ROOT_PASSWORD=r00tpa55 -v docker2podman_jsp_bookstoredata:/var/lib/mysql --net docker2podman_jspnet --network-alias bookstoredb -p 3306:3306 --restart unless-stopped mariadb
40825164736afa7bbc1957f59126b77ab68d61917230ceb2e8ba7e460e2ba2f2
exit code: 0
['podman', 'network', 'exists', 'docker2podman_jspnet']
podman run --name=docker2podman_bookstore_1 -d --label io.podman.compose.config-hash=123 --label io.podman.compose.project=docker2podman --label io.podman.compose.version=0.0.1 --label com.docker.compose.project=docker2podman --label com.docker.compose.project.working_dir=/home/gcollis/Sandbox/docker2podman --label com.docker.compose.project.config_files=./docker-compose-platform.yaml --label com.docker.compose.container-number=1 --label com.docker.compose.service=bookstore --net docker2podman_jspnet --network-alias bookstore -p 8395:8080 docker2podman_bookstore
a3e75fce3a55b596e5858ad98fdefe51cace06f92102f631553230eccc2892dd
exit code: 0
['podman', 'network', 'exists', 'docker2podman_jspnet']
podman run --name=docker2podman_adminer_1 -d --label io.podman.compose.config-hash=123 --label io.podman.compose.project=docker2podman --label io.podman.compose.version=0.0.1 --label com.docker.compose.project=docker2podman --label com.docker.compose.project.working_dir=/home/gcollis/Sandbox/docker2podman --label com.docker.compose.project.config_files=./docker-compose-platform.yaml --label com.docker.compose.container-number=1 --label com.docker.compose.service=adminer --net docker2podman_jspnet --network-alias adminer -p 8397:8080 --restart unless-stopped adminer
3f99292a61274d3588b89767b6bfe2f43b395abf1606cc20ae7c3223cf10b610
exit code: 0
```

Deployment successful, `tomcat` accessible, but again `` volume created is `docker2podman_jsp_bookstoredata`.
Now populate `bookstoredb-1` MariaDB database.

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

## Create Podman Play version

Creating a single pod from the the Docker container, while it creates something in `podman`it does not work...
Everything goes to the `adminer-1-podified` and it is obvious something is wrong because everything is listening on ***all*** of the ports.
For completeness sake see the `bookstore-inspect-single-pod.json` and `bookstore-kube-single-pod.yaml`files.

What needs to be created is a `pod` per Docker `service` and a `container` to run them.

Had to delete everything and rerun `podman-compose -f ./docker-compose-platform.yaml up --detach`.
There are two volumes with shown below what is each being used for?

```
$ podman volume ls
DRIVER      VOLUME NAME
local       96390c62d58eac61395aceeb4307ea6676432d00d23c11aa0e7946a7cfbd49c2
local       docker2podman_jsp_bookstoredata

$ podman volume inspect docker2podman_jsp_bookstoredata
[
     {
          "Name": "docker2podman_jsp_bookstoredata",
          "Driver": "local",
          "Mountpoint": "/home/gcollis/.local/share/containers/storage/volumes/docker2podman_jsp_bookstoredata/_data",
          "CreatedAt": "2023-02-06T10:00:20.836576554+01:00",
          "Labels": {},
          "Scope": "local",
          "Options": {},
          "MountCount": 0,
          "NeedsCopyUp": true
     }
]
$ podman volume inspect 96390c62d58eac61395aceeb4307ea6676432d00d23c11aa0e7946a7cfbd49c2
[
     {
          "Name": "96390c62d58eac61395aceeb4307ea6676432d00d23c11aa0e7946a7cfbd49c2",
          "Driver": "local",
          "Mountpoint": "/home/gcollis/.local/share/containers/storage/volumes/96390c62d58eac61395aceeb4307ea6676432d00d23c11aa0e7946a7cfbd49c2/_data",
          "CreatedAt": "2023-02-06T11:34:51.439576262+01:00",
          "Labels": {},
          "Scope": "local",
          "Options": {},
          "Anonymous": true,
          "MountCount": 0,
          "NeedsCopyUp": true
     }
]
```

Could not make this work.. converted each Docker `service` into a pod for reference.

* `wharf/Podman/adminer-pod.yaml`;
* `wharf/Podman/bookstoredb-pod.yaml`;
* `wharf/Podman/bookstore-pod.yaml`;

Probably next step is to create a `deployment` which deploys these pods and connects them.
This is akin to building a `helm chart`, but could also look at 

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
$ podman machine start                     # Starting machine "podman-machine-default"
$ podman machine rm podman-machine-default # Delete it
$ podman machine inspect                   # Error: podman-machine-default: VM does not exist
```

