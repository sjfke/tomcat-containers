# Setup of Tomcat for tomcat-containers

Tomcat set up for [Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) development.

## Windows Platform Setup

A standalone `Tomcat` installation is optional because everything can be done within `Eclipse`.

However, it permits debugging and testing outside of `Eclipse` and provides the documentation for the `Tomcat 9` release.

### Apache Tomcat Preparation

`Tomcat` requires a `Java JDK`, the project used `Temurin` because this is the one bundled with `Eclipse`.

* [Temurin™ for Windows x64 Prebuilt OpenJDK Binaries for Free!](https://adoptium.net/) it is needed by tomcat
  * [Install Temurin™ for Windows](https://adoptium.net/), using defaults, and with everything enabled
  * Installs into `C:\Program Files\Eclipse Adoptium\jdk-17.0.7.7-hotspot`

* [Tomcat 9 Software Downloads](https://tomcat.apache.org/download-90.cgi)
  * Install Tomcat installation required to start 'Dynamic Web Project' in Eclipse, ([KISS](https://slang.net/meaning/kiss))
  * Install everything, including `docs`, `examples`, `host-manager`, and `manager`
  * Installation prompts for tomcat users, `user:admin`, `password: admin` for roles `manager-gui,admin-gui`
  * JRE path `C:\Program Files\Eclipse Adoptium\jdk-17.0.7.7-hotspot`
  * Installation `C:\Program Files\Apache Software Foundation\Tomcat 9.0`
  * Creates a service that may require manual starting `Service "Apache Tomcat 9.0 Tomcat9"`

To test if Tomcat is working:

```console
PS> start "http://127.0.0.1:8080"
```

## MacOS Platform (Intel) Setup

> ### MacOS Notes
>
> Needs to be written.

## Fedora Platform Setup

> ### Fedora Notes
>
> Needs to be written.
>
Java JDK installation

```console
# is a JDK installed?
$ which javac
/usr/bin/javac
$ javac -version
javac 21.0.3

# install OpenJDK Java-21
$ sudo dnf install java-21-openjdk-devel.x86_64
$ javac -version
javac 21.0.3
```

Tomcat installation

```console
$ sudo dnf install tomcat tomcat-admin-webapps.noarch tomcat-docs-webapp.noarch

# start/stop
$ sudo systemctl start tomcat
$ sudo systemctl status tomcat # sudo is optional

$ firefox "http://127.0.0.1:8080/docs/"

$ sudo systemctl stop tomcat
```
