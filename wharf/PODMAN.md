# Setup of Podman for tomcat-containers

Podman set up for [Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) development.

> Installing `Podman` and `Docker` on the same computer is **unwise**

## Podman on various platforms

* MacOS `podman` is backed by a QEMU based virtual machine
* Windows `podman` is backed by a Windows Subsystem for Linux (WSLv2) distribution,
* Linux distributions `podman` is supplied as an appropriate package.

The `Windows` environment is the most complex to setup, so let's start with that.

## Windows Platform Setup

* [Podman for Windows](https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md), version 4.6.0
* [Podman-Desktop](https://podman-desktop.io/downloads), version v1.2.1
* [Windows 10 Home Version 22H2](https://learn.microsoft.com/en-us/windows/whats-new/whats-new-windows-10-version-22h2)
* [Windows 11 Home Version 22H2](https://learn.microsoft.com/en-us/windows/whats-new/whats-new-windows-11-version-22h2)
* [WSL version: 1.2.5.0](https://learn.microsoft.com/en-us/windows/wsl/install)

For this project `WSL` was installed manually, before `Podman` to ensure `WSL` was working correctly.
However installing `Podman` will also install `WSL` the process is simple, and straighforward.

The `Podman Desktop` installation is also straight forward and installs the required extensions.

* *Compose*, *Docker*, *Kind*, *Kube Context*, *Podman*, *Lima* and *Registries*

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

Checking the `WSL` is installed and working, example uses `PowerShell` but `CMD` also works.

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

> #### Warning
>
> Do not `podman machine set --rootful` because this breaks `podman build`

Initialize, start, stop and restart `podman machine`.

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

Test `podman` is working by running some simple examples

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
* [Containers - Open Repository for Container Tools](https://github.com/containers)

### Installing Podman Compose

Install the Community [Podman Compose](https://github.com/containers/podman-compose) Python script to get `Docker Compose` style support.

There are several ways to install `python` on Windows, see [Python on Windows References](#python-on-windows-references), the author used a `Microsoft Store` installation.

```console
PS C:\Users\sjfke\Github\tomcat-containers> python -m venv venv
PS C:\Users\sjfke\Github\tomcat-containers> .\venv\Scripts\activate
(venv) PS C:\Users\sjfke\Github\tomcat-containers> pip3 install podman-compose
```

#### Python on Windows References

* [RealPython - Your Python Coding Environment on Windows: Setup Guide](https://realpython.com/python-coding-setup-windows/)
* [Python - Using Python on Windows](https://docs.python.org/3/using/windows.html)
* [Microsoft - Get started using Python on Windows for beginners](https://learn.microsoft.com/en-us/windows/python/beginners)
* [Microsoft Store - Python 3.11](https://apps.microsoft.com/store/detail/python-311/9NRWMJP3717K)

## Installing Podman-Desktop Windows

Download the Windows installer, [Podman-Desktop](https://podman-desktop.io/downloads) and follow the instructions on, [Podman-Desktop - Windows Install](https://podman-desktop.io/docs/Installation/windows-install)

Both applications, `Podman` and `Podman-Desktop` are listed correctly in `Settings` > `Apps` > `Installed apps`.

There is no evidence of any Windows services for `Redhat` or `Podman`.

## MacOS Platform (Intel)

> ### Section needs a rewrite
>
> * [Docker-Desktop](https://www.docker.com/products/docker-desktop/) version v4.16.2
> * [Podman-Desktop](https://github.com/containers/podman-desktop/releases/download/v0.11.0/podman-desktop-0.11.0-x64.dmg) version 0.11.0 or `$ brew install podman-desktop`
> * MacOS
> * Kubernetes

## Fedora 37 Platform

> ### Section needs updating
>
> * [Podman-Desktop](https://github.com/containers/podman-desktop/releases/download/v0.11.0/podman-desktop-0.11.0.flatpak) version 0.11.0
>
>```console
>gcollis@morpheus docker2podman]$ sudo dnf list installed | grep podman
>podman.x86_64                                        4:4.3.1-1.fc37                      @updates                  
>podman-compose.noarch                                1.0.3-6.fc37                        @fedora                   
>podman-gvproxy.x86_64                                4:4.3.1-1.fc37                      @updates                  
>podman-plugins.x86_64                                4:4.3.1-1.fc37                      @updates                
>```

## Notes on using Podman and Podman Destop

### Updates

* `Podman Desktop` task bar will show if a `Podman Desktop` update is available
* `Podman Desktop` main panel will show if a `Podman` update is available

## Application Specific Setup

The following additional steps are required for the [Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) development.

### Create Volume for MariaDB

Creating the `jsp_bookstoredata` volume.

[podman-volume - Simple management tool for volumes](https://docs.podman.io/en/latest/markdown/podman-volume.1.html)

```console
PS C:\Users\sjfke\Github\tomcat-containers> podman volume # errors out with mini-help

PS C:\Users\sjfke\Github\tomcat-containers> podman volume ls

PS C:\Users\sjfke\Github\tomcat-containers> podman volume create jsp_bookstoredata
jsp_bookstoredata

PS C:\Users\sjfke\Github\tomcat-containers> podman volume ls
DRIVER      VOLUME NAME
local       jsp_bookstoredata

PS C:\Users\sjfke\Github\tomcat-containers> podman volume inspect jsp_bookstoredata
[
     {
          "Name": "jsp_bookstoredata",
          "Driver": "local",
          "Mountpoint": "/var/lib/containers/storage/volumes/jsp_bookstoredata/_data",
          "CreatedAt": "2023-08-12T17:01:37.100446362+02:00",
          "Labels": {},
          "Scope": "local",
          "Options": {},
          "MountCount": 0,
          "NeedsCopyUp": true,
          "NeedsChown": true,
          "LockNumber": 0
     }
]
```

## Docker and Docker Configuration Files

### MariaDB in Docker

* The docker compose command will take the folder name of as the **container** name, so the `compose-mariadb.yaml` and `compose.yaml` files are not in `wharf` folder
* A permanent volume, `jsp_bookstoredata` must be created from `podman` command line, see [Create Volume for MariaDB](#create-volume-for-mariadb)

#### MariaDB Docker Compose file

Contents of `compose-mariadb.yaml` file.

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
    environment:
      ADMINER_DEFAULT_SERVER: bookstoredb
      ADMINER_DESIGN: dracula # hever
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

Create the containers, from inside the `python` virtual environment.

```console
(venv) PS C:\Users\sjfke\Github\tomcat-containers> podman-compose -f .\compose-mariadb.yaml up -d # Start MariaDB and Adminer
(venv) PS C:\Users\sjfke\Github\tomcat-containers> podman-compose -f .\compose-mariadb.yaml down  # Stop MariaDB and Adminer
```

## Tomcat and Bookstore application in Podman

With `MariaDB` and `Adminer` running, follow all the steps in, [Build](../BUILD) to build the `Bookstore` application.

Consult the [Dockerfile](../Dockerfile) and for details of the deployment.

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

To keep the Docker file simple, the output of the `maven` build within Eclipse is copied to the `Bookstore` webapp, and the `web.xml` file is replaced with one that has the correct `jdbcURL`.

```text
# Deploy the Bookstore application, using the output of the Maven build
# Modified web.xml changes jdbc:mysql for Docker, 'jdbc:mysql://SERVICE-NAME:3306/DATABASE-NAME'
COPY ./Bookstore/target/Bookstore-0.0.1-SNAPSHOT/ /usr/local/tomcat/webapps/Bookstore
COPY ./wharf/Docker/webapps/Bookstore/WEB-INF/web.xml /usr/local/tomcat/webapps/Bookstore/WEB-INF/web.xml
```

## General Docker and Docker Compose Notes

### Typical command usage

```console
PS C:\Users\sjfke> podman build -f .\Dockerfile
PS C:\Users\sjfke> podman images
REPOSITORY                             TAG                   IMAGE ID      CREATED         SIZE
localhost/tomcat-containers_bookstore  latest                f75bce11f066  11 seconds ago  489 MB

# 'podman-compose' is a Python script, using (venv) 'virtual environment'
PS C:\Users\sjfke> venv\Scripts\activate
(venv) pip install podman-compose

# Once compose.yaml is created, see references (3, 4) you can build just like with Docker
(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml build
(venv) PS C:\Users\sjfke> podman images
REPOSITORY                             TAG                   IMAGE ID      CREATED         SIZE
localhost/tomcat-containers_bookstore  latest                f75bce11f066   5 minutes ago  489 MB
docker.io/library/tomcat               9.0.71-jdk17-temurin  b07e16b11088  8 months ago    482 MB

(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml up -d
(venv) PS C:\Users\sjfke> podman images
REPOSITORY                             TAG                   IMAGE ID      CREATED       SIZE
localhost/tomcat-containers_bookstore  latest                f75bce11f066  3 hours ago   489 MB
docker.io/library/adminer              latest                9b672f480fc7  12 days ago   258 MB
docker.io/library/mariadb              latest                871a9153c184  4 weeks ago   410 MB
docker.io/library/tomcat               9.0.71-jdk17-temurin  b07e16b11088  8 months ago  482 MB

(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml down  # deletes the containers

(venv) PS C:\Users\sjfke> podman images                 # man podman-images
(venv) PS C:\Users\sjfke> podman image prune            # prune dangling images, man podman-image-prune
(venv) PS C:\Users\sjfke> podman rmi --all              # Delete all images
(venv) PS C:\Users\sjfke> podman rmi localhost/myimage  
(venv) PS C:\Users\sjfke> podman rmi e80dffa4ea27

(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml stop
(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml start

(venv) PS C:\Users\sjfke> podman-compose help
(venv) PS C:\Users\sjfke> podman help
```

1. [Podman: Commands](https://docs.podman.io/en/latest/Commands.html)
2. [Podman: Tutorials](https://docs.podman.io/en/latest/Tutorials.html)
3. [Github: podman-compose](https://github.com/containers/podman-compose)
4. [Docker: Compose specification](https://docs.docker.com/compose/compose-file)
5. [Docker: Reference documentation](https://docs.docker.com/reference/)
6. [Docker: Overview of Docker Compose](https://docs.docker.com/compose/)
7. [Podman: podman play kube](https://docs.podman.io/en/v4.2/markdown/podman-play-kube.1.html)

***

## Issues found with a `rootful` `podman machine`

### Troubleshooting

`podman build .` fails if `podman machine set --rootful`

```console
PS C:\Users\sjfke\Github\tomcat-containers> podman machine stop
PS C:\Users\sjfke\Github\tomcat-containers> podman machine set --rootful=false

PS C:\Users\sjfke\Github\tomcat-containers> podman machine start
PS C:\Users\sjfke\Github\tomcat-containers> podman system connection list
Name                         URI                                                          Identity                                    Default
podman-machine-default       ssh://user@127.0.0.1:51252/run/user/1000/podman/podman.sock  C:\Users\sjfke\.ssh\podman-machine-default  false
podman-machine-default-root  ssh://root@127.0.0.1:51252/run/podman/podman.sock            C:\Users\sjfke\.ssh\podman-machine-default  true

PS C:\Users\sjfke\Github\tomcat-containers> podman build .
STEP 1/15: FROM tomcat:9.0.71-jdk17-temurin
Resolving "tomcat" using unqualified-search registries (/etc/containers/registries.conf.d/999-podman-machine.conf)
Trying to pull docker.io/library/tomcat:9.0.71-jdk17-temurin...
Getting image source signatures
```

* [Rootful & Rootless](https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md#rootful--rootless)

> Another case in which you may wish to use rootful execution is binding a port less than 1024.
> However, future versions of podman will likely drop this to a lower number to improve compatibility with
> defaults on system port services (such as MySQL)

### Cleaning Up A Podman + Docker Installation

Accidentally installed `Podman` and `Docker` on Windows, the following additional steps were used to remove `Podman` installation.

```console
PS C:\Users\sjfke> podman machine info                      # Details of "podman-machine-default"
PS C:\Users\sjfke> podman machine inspect                   # Status "podman-machine-default" as JSON
PS C:\Users\sjfke> podman machine stop                      # Stop "podman-machine-default"
PS C:\Users\sjfke> podman machine rm podman-machine-default # Delete it
PS C:\Users\sjfke> podman machine inspect                   # Error: podman-machine-default: VM does not exist
```

```console
PS C:\Users\sjfke> wsl --list --verbose
  NAME                      STATE           VERSION
* Ubuntu                    Stopped         2
  AlmaLinux-8               Stopped         2
  docker-desktop            Stopped         2
  podman-machine-default    Stopped         2
  docker-desktop-data       Stopped         2
```

```console
PS C:\Users\sjfke> wsl --unregister  podman-machine-default
Unregistering.
The operation completed successfully.
PS C:\Users\sjfke> wsl --list --verbose
  NAME                   STATE           VERSION
* Ubuntu                 Stopped         2
  AlmaLinux-8            Stopped         2
  docker-desktop         Stopped         2
  docker-desktop-data    Stopped         2
```
