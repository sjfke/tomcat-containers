# tomcat-containers
Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB

# Migrating the Bookstore Application

Based on the article [Docker-Desktop to Podman-Desktop migration](https://fedoramagazine.org/docker-and-fedora-37-migrating-to-podman/).

## Windows Platform

* [Docker-Desktop](https://www.docker.com/products/docker-desktop/) version v4.16.3
* [Podman-Desktop](https://podman-desktop.io/downloads/Windows) version 0.11.0
* [Windows 11 Home Version 22H2](https://learn.microsoft.com/en-us/windows/whats-new/whats-new-windows-11-version-22h2)
* [WSL version: 1.0.3.0](https://learn.microsoft.com/en-us/windows/wsl/install)

## MacOS Platform

* [Docker-Desktop](https://www.docker.com/products/docker-desktop/) version v4.16.2
* [Podman-Desktop](https://podman-desktop.io/downloads/Windows) version 0.11.0
* MacOS
* Kubernetes

## Docker Setup

See [DOCKER_ME.md](./DOCKER_ME.md) for docker notes and how to redeploy the docker containers.

# Podman and Podman-Desktop installation

First install `podman` and once it is working then install `podman-desktop`.

## Installing Podman

Follow the `GitHub` instructions.

* [Podman for Windows](https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md)

Download and install [`podman-4.3.1-setup.exe`](https://github.com/containers/podman/releases/download/v4.3.1/podman-4.3.1-setup.exe)

After a computer restart, `podman` should be working from the command-line, and is installed in `C:\Program Files\RedHat\Podman`.

```
$ podman version
$ podman help
$ podman run quay.io/podman/hello
```
## Installing Podman-Desktop

Follow the instructions on [Containers and Kubernetes for application developers](https://podman-desktop.io/).

* Download and install [Podman-Desktop](https://podman-desktop.io/downloads/Windows) version 0.11.0

The installation will prompt for any additional steps.

Both applications are listed correctly in `Settings` > `Apps` > `Installed apps`, and there is no evidence of any `Redhat` or `Podman` services.

> Note:
>
>> `Podman-Desktop` does not see any other the `Docker-Desktop` containers or volumes.
>
>> `Docker-Desktop` can be started but `docker compose` errors with exit status 1.

## Next steps

1. Build out MariaDB, Adminer in podman
2. Convert compose file as per the article. 
