# Setup of Tomcat for tomcat-containers

Podman set up for [Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) development.

## Windows Platform Setup

Tested on `Windows-10 Home` and `Windows-11 Home` editions.

This is optional but was used to provide the documntation for the `Tomcat 9` release, and to debug, test `Tomcat` issues.

### Apache Tomcat Preparation

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

Test Tomcat is working

```console
PS> start "http://127.0.0.1:8080"
```

## MacOS Platform (Intel) Setup

> ### MacOS Note
>
> Needs to be written.

## Fedora Platform Setup

> ### Fedora Note
>
> Needs to be written.
