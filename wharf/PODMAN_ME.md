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

# Podman-Desktop installation

***Note:*** with [Docker-Desktop](https://www.docker.com/products/docker-desktop/) running.

* Download and install [Podman-Desktop](https://podman-desktop.io/downloads/Windows) version 0.11.0

[Podman for Windows](file:///C:/Program%20Files/RedHat/Podman/welcome-podman.html)

```
Podman Desktop was not able to find an installation of Podman.
To start working with containers, Podman needs to be detected/installed.
```
Click on `Install`

```
Podman is installed but not ready
To start working with containers, Podman needs to be initialized.
```
Slide `Initialize Podman`

```
Podman v4.3.1 is stopped
To start working with containers, Podman v4.3.1 needs to be started.
```
Slide `Run Podman`

Installation successful? ![Podman-Desktop](./Podman/podman-docker-running.png "Podman and Docker Desktops")

Installed in `C:\Program Files\RedHat\Podman`, but `C:\Program Files\RedHat\Podman\podman.exe` not in $path and does not run.

Reading [Podman for Windows](./Podman/welcome-podman.html) looks like Podman needs to be installed first!

## Installing Podman

* [Podman for Windows](https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md)

Download and install [`podman-4.3.1-setup.exe`](https://github.com/containers/podman/releases/download/v4.3.1/podman-4.3.1-setup.exe)

Ran `Repair` option which completed successfully but requires a computer restart!

All now seems good and `podman` is working from the command-line, and the `podman-desktop` works, but there are no containers.
Both applications are listed correctly in `Settings` > `Apps` > `Installed apps`, no evidence of any `Redhat` or `Podman` services.

The `Podman-Desktop` does not see any other the `Docker-Desktop` containers or volumes.

Starting `docker-desktop` to see what happens, it starts but `docker compose` errors with exit status 1.

## Next steps

1. Installation should have been done the other way around... `Podman` then `Podman-Desktop`.
2. Clean up documentation to reflect this...
3. Build out MariaDB, Adminer in podman
4. Convert compose file as per the article. 
