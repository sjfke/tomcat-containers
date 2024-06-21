# Setup of Podman for tomcat-containers

Podman set up for [Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) development.

> Installing `Podman` and `Docker` on the same computer is **unwise**

## Podman on various platforms

* MacOS `podman` is backed by a QEMU based virtual machine
* Windows `podman` is backed by a Windows Subsystem for Linux (WSLv2) distribution
* Linux distributions `podman` is supplied as an appropriate package

The `Windows` environment is the most complex to setup, so let's start with that.

## Windows Platform Setup

* [Podman for Windows](https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md), version 4.6.0
* [Podman-Desktop](https://podman-desktop.io/downloads), version v1.2.1
* [Windows 10 Home Version 22H2](https://learn.microsoft.com/en-us/windows/whats-new/whats-new-windows-10-version-22h2)
* [Windows 11 Home Version 22H2](https://learn.microsoft.com/en-us/windows/whats-new/whats-new-windows-11-version-22h2)
* [WSL version: 1.2.5.0](https://learn.microsoft.com/en-us/windows/wsl/install)

For this project `WSL` was installed manually, before `Podman` to ensure `WSL` was working correctly.
However installing `Podman` will also install `WSL` the process is simple, and straightforward.

The `Podman Desktop` installation is also straight forward and installs the required extensions.

* *Compose*, *Docker*, *Kind*, *Kube Context*, *Podman*, *Lima* and *Registries*

Installation sequence is:

1. Install and test `WSL`, either manually or part of the `podman` install
2. Install and test `Podman`
3. Install and test `Podman Desktop`

### Manual WSLv2 Installation

For platform `prerequisites` see [Install Linux on Windows with WSL](https://learn.microsoft.com/en-us/windows/wsl/install).

While this describes using  `wsl` command in an Administrative PowerShell, it is easier to install using the `Microsoft Store` as shown.

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

> #### Information
>
> `Podman` updates are frequent, so regularly check [podman releases](https://github.com/containers/podman/releases)
>
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
* [Microsoft Store - Python 3.12](https://apps.microsoft.com/detail/9NCVDN91XZQP?hl=en-gb&gl=US)

## Installing Podman-Desktop Windows

Download the Windows installer, [Podman-Desktop](https://podman-desktop.io/downloads) and follow the instructions on, [Podman-Desktop - Windows Install](https://podman-desktop.io/docs/Installation/windows-install)

Both applications, `Podman` and `Podman-Desktop` are listed correctly in `Settings` > `Apps` > `Installed apps`.

There is no evidence of any Windows services for `Redhat` or `Podman`.

## MacOS Platform (Intel)

> ### Warning
>> * `MacOS` `podman v5` is only supported on `macOS 13 (Ventura)` or later
>> * `MacOS` `podman v4` download and install `dmg` from [podman releases](https://github.com/containers/podman/releases)


The [Podman Installation Instructions](https://podman.io/docs/installation) **recommends** installing using the pre-build packages

* [podman-installer-macos-amd64.pkg](https://github.com/containers/podman/releases/download/v4.9.3/podman-installer-macos-amd64.pkg)
* [podman-desktop-1.8.0-universal.dmg](https://github.com/containers/podman-desktop/releases/download/v1.8.0/podman-desktop-1.8.0-universal.dmg)

However, it requires a manual uninstall `podman` because the `podman-installer-macos-amd64.pkg` has no `receipt` which limits the `pkgutil` commands that can be used. 
Everything appears to be installed in `/opt/podman` which make manual uninstall a little easier.

```zsh
# Manual clean-up
$ pkgutil --files com.redhat.podman
$ cd /opt
$ sudo rm -fr podman
$ sudo pkgutil --forget com.redhat.pod
```

But it is also possible to use [Homebrew](https://brew.sh/) making it easier to remove these applications.

* [Brew: podman](https://formulae.brew.sh/formula/podman) brew install podman
* [Brew: podman-desktop](https://formulae.brew.sh/cask/podman-desktop) brew install podman-desktop
* [Brew: podman-compose](https://formulae.brew.sh/formula/podman-compose) brew install podman-compose

```zsh
# Brew podman installation
$ brew install podman  # has a lot of dependencies, so takes some time
$ podman machine init  # downloads VM image fedora-coreos-39.20240309.2.0-qemu.x86.qcow2.xz
$ podman machine start # Waiting for VM ... couple of minutes...
$ podman info
$ podman ps --all
$ podman machine info
$ podman machine ssh
$ ps -ef | grep qemu

# Brew podman-compose installation
$ brew install podman-compose
$ podman compose --help

# Brew podman-desktop installation
$ brew install podman-desktop # creates a 'Podman Desktop' in Applications

```

## Fedora 39 Platform

Podman is installed by default.

```console
$ podman version
Client:       Podman Engine
Version:      4.8.3
API Version:  4.8.3
Go Version:   go1.21.5
Built:        Wed Jan  3 15:11:40 2024
OS/Arch:      linux/amd64
```

What other `Podman` related packages exist?

```console
$ sudo dnf search podman
Last metadata expiration check: 0:47:25 ago on Thu 18 Jan 2024 05:22:13 PM CET.
================================= Name Exactly Matched: podman =================================
podman.x86_64 : Manage Pods, Containers and Container Images
================================ Name & Summary Matched: podman ================================
ansible-collection-containers-podman.noarch : Podman Ansible collection for Podman containers
cockpit-podman.noarch : Cockpit component for Podman containers
pcp-pmda-podman.x86_64 : Performance Co-Pilot (PCP) metrics for podman containers
podman-compose.noarch : Run docker-compose.yml using podman
podman-docker.noarch : Emulate Docker CLI using podman
podman-plugins.x86_64 : Plugins for podman
podman-remote.x86_64 : (Experimental) Remote client for managing podman containers
podman-tests.x86_64 : Tests for podman
podman-tui.x86_64 : Podman Terminal User Interface
podmansh.x86_64 : Confined login and user shell using podman
prometheus-podman-exporter.x86_64 : Prometheus exporter for podman environment
python3-mrack-podman.noarch : Podman provider plugin for mrack
python3-podman.noarch : RESTful API for Podman
python3-podman+progress_bar.noarch : Metapackage for python3-podman: progress_bar extras
=================================== Summary Matched: podman ====================================
containers-common-extra.noarch : Extra dependencies for Podman and Buildah

$ sudo dnf search podman-desktop
Last metadata expiration check: 0:43:11 ago on Thu 18 Jan 2024 05:22:13 PM CET.
No matches found.
```

Install a minimal working set of packages

```console
$ sudo dnf install podman-compose.noarch              # Run docker-compose.yml using podman
$ sudo dnf install python3-podman.noarch              # RESTful API for Podman
$ sudo dnf install python3-podman+progress_bar.noarch # A library of bindings to use the RESTful API of Podman.

$ sudo dnf list *podman*
Installed Packages
cockpit-podman.noarch                                                   82-1.fc39                                  @updates
podman.x86_64                                                           5:4.8.3-1.fc39                             @updates
podman-compose.noarch                                                   1.0.6-3.fc39                               @fedora 
podman-plugins.x86_64                                                   5:4.8.3-1.fc39                             @updates
python3-podman.noarch                                                   3:4.8.2-1.fc39                             @updates
python3-podman+progress_bar.noarch                                      3:4.8.2-1.fc39                             @updates
Available Packages
ansible-collection-containers-podman.noarch                             1.10.1-3.fc39                              fedora  
pcp-pmda-podman.x86_64                                                  6.1.1-1.fc39                               updates 
podman-docker.noarch                                                    5:4.8.3-1.fc39                             updates 
podman-remote.x86_64                                                    5:4.8.3-1.fc39                             updates 
podman-tests.x86_64                                                     5:4.8.3-1.fc39                             updates 
podman-tui.x86_64                                                       0.15.0-1.fc39                              updates 
podmansh.x86_64                                                         5:4.8.3-1.fc39                             updates 
prometheus-podman-exporter.x86_64                                       1.6.0-1.fc39                               updates 
python3-mrack-podman.noarch                                             1.17.0-1.fc39                              updates 
```

Terminal UI looks interesting, but not installed for now.

## Podman-Desktop

* [Podman Desktop Downloads](https://podman-desktop.io/downloads) - download flatpack

In file manager, double-click on `podman-desktop-1.6.4.flatpak` and `flatpack` will install it.

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

* The docker compose command will take the folder name of as the **container** name, so the `compose-mariadb-simple.yaml` and `compose.yaml` files are not in `wharf` folder
* A permanent volume, `jsp_bookstoredata` must be created from `podman` command line, see [Create Volume for MariaDB](#create-volume-for-mariadb)

#### MariaDB Docker Compose file

Contents of `compose-mariadb-simple.yaml` file.

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
(venv) PS C:\Users\sjfke\Github\tomcat-containers> podman-compose -f .\compose-mariadb-simple.yaml up -d # Start MariaDB and Adminer
(venv) PS C:\Users\sjfke\Github\tomcat-containers> podman-compose -f .\compose-mariadb-simple.yaml down  # Stop MariaDB and Adminer
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
PS C:\Users\sjfke> podman build --tag localhost/bookstore:latest --squash -f .\Dockerfile
PS C:\Users\sjfke> podman image list --all
REPOSITORY                TAG                   IMAGE ID      CREATED        SIZE
localhost/bookstore       latest                f2bf9a0dea3b  8 minutes ago  489 MB
docker.io/library/tomcat  9.0.71-jdk17-temurin  b07e16b11088  11 months ago  482 MB

# 'podman-compose' is a Python script, using (venv) 'virtual environment'
PS C:\Users\sjfke> venv\Scripts\activate
(venv) pip install podman-compose

# Once compose.yaml is created, see references (3, 4) you can build just like with Docker
(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml build
(venv) PS C:\Users\sjfke> podman image list
REPOSITORY                             TAG                   IMAGE ID      CREATED             SIZE
localhost/tomcat-containers_bookstore  latest                e2ab689255e8  About a minute ago  489 MB
localhost/bookstore                    latest                f2bf9a0dea3b  28 hours ago        489 MB
docker.io/library/tomcat               9.0.71-jdk17-temurin  b07e16b11088  11 months ago       482 MB

(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml up -d
(venv) PS C:\Users\sjfke> podman image list
REPOSITORY                             TAG                   IMAGE ID      CREATED        SIZE
localhost/tomcat-containers_bookstore  latest                e2ab689255e8  4 minutes ago  489 MB
localhost/bookstore                    latest                f2bf9a0dea3b  28 hours ago   489 MB
docker.io/library/adminer              latest                fd3b195a8d79  2 days ago     258 MB
docker.io/library/mariadb              latest                3e87f8bfed4e  7 weeks ago    411 MB
docker.io/library/tomcat               9.0.71-jdk17-temurin  b07e16b11088  11 months ago  482 MB

(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml down  # deletes the containers

(venv) PS C:\Users\sjfke> podman image list --all       # man podman-images
(venv) PS C:\Users\sjfke> podman image prune            # prune dangling images, man podman-image-prune
(venv) PS C:\Users\sjfke> podman rmi --all              # Delete all images
(venv) PS C:\Users\sjfke> podman rmi localhost/myimage  
(venv) PS C:\Users\sjfke> podman rmi e80dffa4ea27
(venv) PS C:\Users\sjfke> podman image rm localhost/tomcat-containers_bookstore
(venv) PS C:\Users\sjfke> podman image rm docker.io/library/tomcat:9.0.71-jdk17-temurin

(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml stop
(venv) PS C:\Users\sjfke> podman-compose -f .\compose.yaml start

(venv) PS C:\Users\sjfke> podman-compose help
(venv) PS C:\Users\sjfke> podman help
```

1. [Podman: Commands](https://docs.podman.io/en/latest/Commands.html)
2. [Podman: Tutorials](https://docs.podman.io/en/latest/Tutorials.html)
3. [Podman: Python scripting for Podman services](https://podman-py.readthedocs.io/en/latest/index.html)
4. [Github: Containers/Podman](https://github.com/containers/podman/releases)
5. [Github: podman-compose](https://github.com/containers/podman-compose)
6. [Docker: Compose specification](https://docs.docker.com/compose/compose-file)
7. [Docker: Reference documentation](https://docs.docker.com/reference/)
8. [Docker: Overview of Docker Compose](https://docs.docker.com/compose/)
9. [Podman: podman play kube](https://docs.podman.io/en/v4.2/markdown/podman-play-kube.1.html)

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

## Podman Backend

* [Eclipse Docker Tooling](https://marketplace.eclipse.org/content/eclipse-docker-tooling)
* [run eclipse docker tooling with Podman backend on Windows](https://stackoverflow.com/questions/74291646/run-eclipse-docker-tooling-with-podman-backend-on-windows)
* [Re: Using Eclipse with Podman Engine on Linux](https://lists.podman.io/archives/list/podman@lists.podman.io/message/W26TZQLT5CA6XG5FGMWR7Z6CASTPFYDP/)