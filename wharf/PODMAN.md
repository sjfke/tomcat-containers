# Setup for tomcat-containers

Podman set up for [Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) development.

> Installing `Podman` and `Docker` on the same computer is **unwise**

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

## Application Specific Setup

The following additional steps are required for the [Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) development.

### Create Volume for MariaDB `jsp_bookstoredata`

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

## Cleaning Up A Podman + Docker Installation

Accidentally installed `Podman` and `Docker` on Windows, the following steps were used to remove `Podman` installation.

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
