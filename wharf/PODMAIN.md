# tomcat-containers

Podman set up for [Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) development.

## Podman on various platforms

* MacOS `podman` is backed by a QEMU based virtual machine
* Windows `podman` is backed by a Windows Subsystem for Linux (WSLv2) distribution, 
* Linux distributions `podman` is supplied as an appropriate package.

The `Windows` environment is the most complex to setup, so let's start with that.

## Windows Platform Setup

* [Podman for Windows](https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md), version 4.6.0
* [Podman-Desktop](https://podman-desktop.io/downloads), Desktop version v1.2.1
* [Windows 10 Home Version 22H2](https://learn.microsoft.com/en-us/windows/whats-new/whats-new-windows-10-version-22h2)
* [Windows 11 Home Version 22H2](https://learn.microsoft.com/en-us/windows/whats-new/whats-new-windows-11-version-22h2)
* [WSL version: 1.2.5.0](https://learn.microsoft.com/en-us/windows/wsl/install)

For this project `WSL` was installed manually, before `Podman` to ensure `WSL` was working correctly.
However installing `Podman` will also install `WSL` the process is simple, and straighforward.

The `Podman Desktop` installation is also straight forward and installs the required extensions.

* *Compose*, *Docker*, *Kind*, *Kube Context*, *Podman*, *Lima* and *Registeries*

Installation sequence is:

1. Install and test `WSL`, either manually or part of the `podman` install
2. Install and test `Podman`
3. Install and test `Podman Desktop`

### Manual WSLv2 Installation

For platform `prerequisites` see [Install Linux on Windows with WSL](https://learn.microsoft.com/en-us/windows/wsl/install).
While this describes using  `wsl` command in an Administrative PowerShell, it is easier to install using the `Microsoft Store`.

```text
1. Windows -> Settings -> Optional Features -> More Windows Features
  - [x] Virtual Machine Platform
  - [x] Windows Subsystem for Linux
2. Reboot
3. Install WSL from Microsoft Store
4. Reboot
5. Install Ubuntu (20.04.6 LTS) from Microsoft Store
```

Checking the `WSL` is installed and working, example assumes `PowerShell` but `CMD` also works.

```console
PS C:\Users\sjfke> wsl --status
PS C:\Users\sjfke> wsl --help

PS C:\Users\sjfke> wsl --list
Windows Subsystem for Linux Distributions:
Ubuntu-20.04 (Default)

PS C:\Users\sjfke> wsl
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.90.1-microsoft-standard-WSL2 x86_64)

    * Documentation:  https://help.ubuntu.com
    * Management:     https://landscape.canonical.com
    * Support:        https://ubuntu.com/advantage

sjfke@host:/mnt/c/Users/sjfke$ exit
```

### Installing Podman

* [Podman for Windows](https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md)
* [GitHub containers/podman](https://github.com/containers/podman/releases)

```text
1. Download the 'podman-v4.6.0.msi' (or whatever the latest version is)
2. Run the setup.
3. Reboot (otherwise 'podman' is not in your path)
```

Initialize, start, stop and (re)start `podman machine`.

```console
C:\Users\sjfke> podman machine init
C:\Users\sjfke> podman machine start

C:\Users\sjfke> wsl --list --verbose
    NAME                      STATE           VERSION
  * Ubuntu-20.04              Running         2
    podman-machine-default    Running         2

C:\Users\sjfke> podman machine --help

C:\Users\sjfke> podman machine stop
C:\Users\sjfke> wsl --list --verbose
    NAME                      STATE           VERSION
  * Ubuntu-20.04              Stopped         2
    podman-machine-default    Stopped         2

C:\Users\sjfke> podman machine start # only starts 'podman-machine-default'
C:\Users\sjfke> wsl                  # will restart 'Ubuntu-20.04'
sjfke@host:/mnt/c/Users/sjfke$ exit

C:\Users\sjfke> wsl --list --verbose
    NAME                      STATE           VERSION
  * Ubuntu-20.04              Running         2
    podman-machine-default    Running         2
```

Test `podman` is working by running so simple examples

```console
PS C:\Users\sjfke> podman images
REPOSITORY  TAG         IMAGE ID    CREATED     SIZE  
PS C:\Users\sjfke> podman run ubi8-micro date
Mon Aug  7 16:04:30 UTC 2023
PS C:\Users\sjfke> podman images
REPOSITORY                             TAG         IMAGE ID      CREATED      SIZE
registry.access.redhat.com/ubi8-micro  latest      1de8feb0720b  6 weeks ago  28.4 MB

PS C:\Users\sjfke> podman run --rm -d -p 8080:80 --name httpd docker.io/library/httpd
PS C:\Users\sjfke> curl http://localhost:8080/ -UseBasicParsing

PS C:\Users\sjfke> podman run -it fedora echo "Hello Podman!"
Hello Podman!

PS C:\Users\sjfke> get-command podman | format-list -Property Path
Path : C:\Program Files\RedHat\Podman\podman.exe
```

#### Podman References

* [Podman Introduction](https://docs.podman.io/en/latest/Introduction.html)
* [Podman Tutorials](https://docs.podman.io/en/latest/Tutorials.html)
* [Podman for Windows](./Podman/podman-for-windows.html) installation instructions

## Installing Podman-Desktop Windows

Download the Windows installer,[Podman-Desktop](https://podman-desktop.io/downloads) and follow the instructions on, [Podman-Desktop - Windows Install](https://podman-desktop.io/docs/Installation/windows-install)

Both applications, `Podman` and `Podman-Desktop` are listed correctly in `Settings` > `Apps` > `Installed apps`.

There is no evidence of any Windows services for `Redhat` or `Podman`.

## MacOS Platform (Intel)

==Section needs a rewrite==

* [Docker-Desktop](https://www.docker.com/products/docker-desktop/) version v4.16.2
* [Podman-Desktop](https://github.com/containers/podman-desktop/releases/download/v0.11.0/podman-desktop-0.11.0-x64.dmg) version 0.11.0 or `$ brew install podman-desktop`
* MacOS
* Kubernetes

## Fedora 37 Platform

* [Podman-Desktop](https://github.com/containers/podman-desktop/releases/download/v0.11.0/podman-desktop-0.11.0.flatpak) version 0.11.0

```console
gcollis@morpheus docker2podman]$ sudo dnf list installed | grep podman
podman.x86_64                                        4:4.3.1-1.fc37                      @updates                  
podman-compose.noarch                                1.0.3-6.fc37                        @fedora                   
podman-gvproxy.x86_64                                4:4.3.1-1.fc37                      @updates                  
podman-plugins.x86_64                                4:4.3.1-1.fc37                      @updates                
```

## Application specific Podman Setup

### Create Volume for MariaDB `jsp_bookstoredata`

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

