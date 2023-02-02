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

## Installing Podman-Desktop

Follow the instructions on [Containers and Kubernetes for application developers](https://podman-desktop.io/).

* Download and install [Podman-Desktop](https://podman-desktop.io/downloads/Windows) version 0.11.0

The installation will prompt for any additional steps.

Both applications, `Podman` and `Podman-Desktop` are listed correctly in `Settings` > `Apps` > `Installed apps`.

There is no evidence of any Windows services for `Redhat` or `Podman`.

> Note:
>
>> `Podman-Desktop` does not see any other the `Docker-Desktop` containers or volumes.
>
>> `Docker-Desktop` sees it's containers or volumes but they cannot be started `docker compose` errors with exit status 1.

## Next steps

1. Build out MariaDB, Adminer in podman
2. Convert compose file as per the article. 

# Clean Up Previous Install.

```
wsl --list --verbose
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

