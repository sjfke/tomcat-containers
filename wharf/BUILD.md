# Building tomcat-containers

This document walks through each step in [Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) tutorial, updating the build instructions, where necessary to to deploy the application to a `Docker` container environment.

## Prerequisites

The following applications need to be available or installed.

* [Eclipse](./ECLIPSE.md)
* Install one of the following, but not both:
  * [Docker Desktop](./DOCKER.md)
  * [Podman and Podman Desktop](./PODMAN.md)
* Optionally install:
  * [Tomcat](./TOMCAT.md)
  * [MariaDB](./MARIADB)

> **Note:** *Fedora does not install the java compiler by default*

```console
$ sudo dnf list installed | grep openjdk
java-17-openjdk-headless.x86_64                      1:17.0.9.0.9-3.fc39                 @updates
$ sudo dnf install java-17-openjdk-devel.x86_64
```

## 1. Creating MySQL Database

There are a number of errors in the SQL in the tutorial, and using `root` for an application is problematic.

> ***Note:*** `price` should probably be a `decimal(9,2)` and not `float`, but the Java class code is using `float`.

Assuming you have `MariaDB` running in your chosen container environment.

### Create the `Bookstore.book` table

* `docker compose` open a terminal on the `tomcat-containers-bookstoredb-1` container, see [MariaDB in Docker](./DOCKER.md#mariadb-in-docker)

```powershell
PS C:\Users\sjfke> docker volume ls                                      # jsp_bookstoredata volume exists
PS C:\Users\sjfke> docker volume create jsp_bookstoredata                # create jsp_bookstoredata volume if DOES NOT exist
PS C:\Users\sjfke> docker compose -f .\compose-mariadb-simple.yaml up -d # adminer, mariadb using tomcat-containers_jspnet
PS C:\Users\sjfke> docker exec -it tomcat-containers-bookstoredb-1 sh    # container interactive shell
```

* `podman-compose` open a terminal on the `tomcat-containers-bookstoredb-1` container, volume see [Podman Kube prerequisites](PODMAN-KUBE.md#prerequisites-for-kubernetes-files)

```powershell
PS C:\Users\sjfke> podman volume ls                                             # jsp_bookstoredata volume exists
PS C:\Users\sjfke> podman volume create jsp_bookstoredata                       # create jsp_bookstoredata volume if DOES NOT exist
PS C:\Users\sjfke> .\venv\Scripts\activate
(venv) PS C:\Users\sjfke> podman-compose -f .\compose-mariadb-simple.yaml up -d # adminer, mariadb using tomcat-containers_jspnet
(venv) PS C:\Users\sjfke> podman exec -it tomcat-containers_bookstoredb_1 sh    # container interactive shell
```

* `podman play kube` open a terminal on the `bookstoredb-pod-bookstoredb` container, volume see [Podman Kube prerequisites](PODMAN-KUBE.md#prerequisites-for-kubernetes-files)

```powershell
PS C:\Users\sjfke> podman secret list                              # list podman cluster secrets
PS C:\Users\sjfke> podman kube play secrets.yaml                   # load secret if necessary
PS C:\Users\sjfke> podman volume ls                                # jsp_bookstoredata volume exists
PS C:\Users\sjfke> podman volume create jsp_bookstoredata          # create jsp_bookstoredata volume if DOES NOT exist
PS C:\Users\sjfke> podman play kube --start .\adminer-pod.yaml     # adminer using podman-default-kube-network
PS C:\Users\sjfke> podman play kube --start .\bookstoredb-pod.yaml # mariadb using podman-default-kube-network
PS C:\Users\sjfke> podman exec -it bookstoredb-pod-bookstoredb sh  # container interactive shell
```

> ***Note:***
>
> Maria Database root password is in the `compose-mariadb-simple.yaml`, `env\mariadb`, and `compose.yaml` files.

```sql
# mariadb -u root -p
Enter password:

MariaDB [(none)]> create database Bookstore;
MariaDB [(none)]> use Bookstore

MariaDB [Bookstore]> drop table if exists book;
MariaDB [Bookstore]> create table book(
  `book_id` int(11) auto_increment primary key not null,
  `title` varchar(128) unique key not null,
  `author` varchar(45) not null,
  `price` float not null
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

MariaDB [Bookstore]> insert into book (title, author, price) values ('Thinking in Java', 'Bruce Eckel', '25.69');
MariaDB [Bookstore]> select * from book;
MariaDB [Bookstore]> exit;
```

### Create an application account and grant access

```sql
# mariadb -u root -p
Enter password:
MariaDB [(none)]> use Bookstore;
MariaDB [Bookstore]> create user 'bsapp'@'%' identified by 'P@ssw0rd';
MariaDB [Bookstore]> grant all privileges on Bookstore.* to 'bsapp'@'%';
MariaDB [Bookstore]> flush privileges;
MariaDB [Bookstore]> show grants for 'bsapp'@'%';
MariaDB [Bookstore]> exit;
```

> #### Notice
>
> * The *bsapp* account is not IP access restricted, i.e. not 'bsapp'@'localhost'.
> * *Docker* will allocate a random RFC-1918 IP to the database when it is deployed.

## Verify application account access

```sql
# mariadb -u bsapp -p Bookstore
Enter password:
MariaDB [Bookstore]> select * from book;
MariaDB [Bookstore]> exit;
```

## Using *Adminer* Web Interface

All of the above steps can be done and checked using through [adminer](http://localhost:8081/).

```yaml
System: MySQL
Server: bookstoredb
Username: root
Password: r00tpa55
Database: <blank>
```

## 2. Creating Eclipse Project with Maven

Follow the instructions in the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example).

### Creating Eclipse Project with Maven

Eclipse: `File` > `New` > `Dynamic Web Project`

Using **Bookstore** as the project name, choosing `Apache Tomcat v9.0`with `tomcat` as the installation folder.

> ***Note***
>
> Cloning the `tomcat-containers` git repo should work
>
> If not you need to convert the `Dynamic Web Project` and `Convert to Maven Project`, see [Converting a Java Project to a Dynamic Web Project](https://stackoverflow.com/questions/838707/converting-a-java-project-to-a-dynamic-web-project)
>
> `Project` > `Properties` > `Project Facets` - check `Dynamic Web Module`
>
> Failing to do this will mean `Bookstore` cannot be added to the `Tomcat` server within `Eclipse`

You need to enter information to create Maven POM file, such as group ID, artifact ID, etc, for example.

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>Bookstore</groupId>
  <artifactId>Bookstore</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  <packaging>war</packaging>
  <build>
     ...
  </build>
```

Then add the following dependencies to the `pom.xml` file, after `</build>` and before `</project>`

```xml
<project>
<build>
  ...
</build>
<dependencies>
  ...
</dependencies>
</project>
```

Remember to create a Java package name for the project, `net.codejava.javaee.bookstore`.

Eclipse: `Bookstore` > `Java Resources` > `New` > `Package`

Useful pom dependency references, unspecified `<scope>` is compile (see 2)

  1. [How To Find Maven Dependencies](https://www.baeldung.com/java-find-maven-dependencies)
  2. [Maven Dependency Scopes](https://www.baeldung.com/maven-dependency-scopes)

In setting up the project you need to install `tomcat` in the `tomcat` folder in `Eclipse` workspace as described in [Tomcat Server in Eclipse IDE](#tomcat-server-in-eclipse-ide)

### Tomcat Server in Eclipse IDE

This process is ***confusing*** and may take several iterations.

Eventually the ***Tomcat Homepage*** will be displayed, using the `Tomcat application software` installed in the `Project Explorer` > `Tomcat` > `Tomcat v9 Server at localhost` folder.

These two references are helpful but illustrate using earlier version of `Eclipse` so are not 100% accurate.

1. [How to configure tomcat server in Eclipse IDE](https://www.javatpoint.com/how-to-configure-tomcat-server-in-eclipse-ide)
2. [Setup and Install Apache Tomcat Server in Eclipse IDE](https://crunchify.com/step-by-step-guide-to-setup-and-install-apache-tomcat-server-in-eclipse-development-environment-ide/)

Create a `Bookstore/tomcat` folder which will be used to store the desired `tomcat` server application.

If manually installing

* Download [Apache Tomcat 9.0.86 zip](https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.86/bin/apache-tomcat-9.0.86.zip) or later
* Unzip `apache-tomcat-9.0.86.zip` into `Bookstore\tomcat`

Configure `tomcat` server within `Eclipse`

* On the `Servers` tab, `No servers available. Click this link to create a new server...`.
* On the `Apache` > `Tomcat v9.0 Server`, set `Server name` then `Next` button.
* Select `apache-tomcat-9.0.82` (*maybe later version*) and select the `Project` folder.
* If not installed manually, click `Download and install` and then the `tomcat` folder.

Eclipse will be configured to use this copy, and not the one installed earlier.

> **Important:** the `tomcat server` needs configuring or it will now work.

* ***Double-click*** on `Tomcat v9.0 Server at localhost [Stopped, Republish]` and then follow [*Step-5 of reference (2)*](https://crunchify.com/step-by-step-guide-to-setup-and-install-apache-tomcat-server-in-eclipse-development-environment-ide/), ensuring

  * `Tomcat admin port` is `8005`
  * `HTTP/1.1` port is `8080`
  * If displayed `AJP port` is `8009`

* Under `Server Locations`
  * Check item, `Use Tomcat installation (takes control of Tomcat installation)`

* Check `Project Explorer` > `Tomcat` > `Tomcat v9 Server at localhost`, if the `tomcat-users.xsd` is missing
  * Download [tomcat-users.xsd](https://github.com/apache/tomcat/blob/main/conf/tomcat-users.xsd) and add it to the folder.

* Follow [*Step-6 of reference (2)*](https://crunchify.com/step-by-step-guide-to-setup-and-install-apache-tomcat-server-in-eclipse-development-environment-ide/)
* `Start` the `Tomcat server`, in a browser open `http:\\localhost:8080`

If it returns a `404 Error`, follow [Tomcat starts but Home Page does NOT open on browser with URL http://localhost:8080](https://crunchify.com/tomcat-starts-but-home-page-does-not-open-on-browser-with-url-http-localhost8080/)

### 3. Writing Model Class

Follow the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) but with the these modifications, because `this(title, author, price)` did not work.

```java
public Book(int id, String title, String author, float price) {
    // this(title, author, price);
    this.id = id;
    this.title = title;
    this.author = author;
    this.price = price;
}
```

### 4. Coding DAO class

Follow the instructions in the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example).

For additional help: [JDBC CRUD Operations Tutorial:](https://www.codejava.net/java-se/jdbc/jdbc-tutorial-sql-insert-select-update-and-delete-examples)

### 5. Writing Book Listing JSP Page

Create a JSP page for displaying all books from the database in `Bookstore\src\main\webapp`.

Follow the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) with the following modifications.

* Convert to HTML-5 conventions
* Make `hard-coded` URL's, **"/list"** etc, `context directory` agnostic using JSTL `<c:url>` tag
  * [Use relative paths without including the context rootname](https://stackoverflow.com/questions/4764405/how-to-use-relative-paths-without-including-the-context-root-name)

```jsp

    <%-- hard-coded --%>
    <%-- <a href="/new">Add New Book</a> &nbsp;&nbsp;&nbsp; <a href="/list">List All Books</a> --%>

    <h2>
        <c:url value="/new" var="newUrl" />
        <c:url value="/list" var="listUrl" />
        <a href="${newUrl}">Add New Book</a> &nbsp;&nbsp;&nbsp; <a href="${listUrl}">List All Books</a>         
    </h2>
```

```jsp

  <%-- hard-coded --%>
  <%-- <td> --%>
  <%-- <a href="/edit?id=<c:out value='${book.id}' />">Edit</a> --%>
  <%-- &nbsp;&nbsp;&nbsp;&nbsp; --%>
  <%-- <a href="/delete?id=<c:out value='${book.id}' />">Delete</a> --%>
  <%-- <td> --%>

  <c:url value="/edit" var="editUrl" />
  <c:url value="/delete" var="deleteUrl" />
  <c:forEach var="book" items="${listBook}">
    <tr>
      <td><c:out value="${book.id}" /></td>
      <td><c:out value="${book.title}" /></td>
      <td><c:out value="${book.author}" /></td>
      <td><c:out value="${book.price}" /></td>
      <td><a href="${editUrl}?id=<c:out value='${book.id}' />">Edit</a>
        &nbsp;&nbsp;&nbsp;&nbsp; 
        <a href="${deleteUrl}?id=<c:out value='${book.id}' />">Delete</a>                     
      </td>
    </tr>
  </c:forEach>
```

### 6. Writing Book Form JSP Page

Create a JSP page for creating a new book in `Bookstore\src\main\webapp`.

Follow the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) with the following modifications

* Convert to HTML-5 conventions
* Make `hard-coded` URL's, **"/new"**, **"/list"**, `context directory` agnostic using JSTL `<c:url>` tag

```jsp

  <%-- hard-coded --%>
  <%-- <a href="/new">Add New Book</a> &nbsp;&nbsp;&nbsp; <a href="/list">List All Books</a> --%>

  <h2>
    <c:url value="/new" var="newUrl" />
    <c:url value="/list" var="listUrl" />
    <a href="${newUrl}">Add New Book</a> &nbsp;&nbsp;&nbsp; <a href="${listUrl}">List All Books</a>         
  </h2>
```

### 7. Coding Controller Servlet Class

Create a ControllerServlet class in `Bookstore\src\main\java\net\codejava\javaee\bookstore`.

Follow the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example)

### 8. Configuring Web.xml

Create `Bookstore/src/main/webapp/WEB-INF/web.xml` using the example skeleton [web.xml for servlet 3.1](https://gist.github.com/darbyluv2code/dd3781d61c3db5476fbf05ee431ee917).

Follow the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) with the following modifications.

* change `<param-name>jdbcUsername</param-name>`
* change `<param-name>jdbcPassword</param-name>`

```xml
  <context-param>
    <param-name>jdbcUsername</param-name>
    <param-value>bsapp</param-value>
  </context-param>

  <context-param>
    <param-name>jdbcPassword</param-name>
    <param-value>P@ssw0rd</param-value>
  </context-param>
```

### 9. Writing Error JSP page

Create `Bookstore/src/main/webapp/Error.jsp`

Follow the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) with the following modifications.

* Make HTML-5

## 10. Deploying and Testing the Application

This section differs from the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) because the database server and the `Bookstore` application will also be deployed to `Docker` or `Podman`. Follow the [Docker](./DOCKER.md) or [Podman](./PODMAN.md) ReadMe's to setup your environment.

It permits debugging when following the steps in the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example)

The steps are as follows:

1. [Build the `Bookstore` war file](#building-a-maven-war-file)
2. [Deploy the `Bookstore` war file](#deploy-bookstore-war-file-to-tomcat-in-eclipse) to tomcat within eclipse
3. [Start the MariaDB](#starting-mariadb-server)
4. [Test the `Bookstore` application](#10-deploying-and-testing-the-application) using tomcat within eclipse

## Building a Maven war file

To function `Maven` requires a minimal `settings.xml` which may have to be manually created.

[Building With Maven](./MAVEN.md#building-with-maven) section, details how to create the `settings.xml` and general reference to the `Maven` build process.

### To execute Maven, create a Run Configuration

Eclipse: `Run` > `Run Configurations...` and select `Maven Build` and the `New launch configuration`, first icon above filter selector

Create, manage, and run configurations: `Maven Build` > `New_configuration`

```text
Main Tab:
  Name: Package Bookstore
  Base directory > Workspace > Bookstore #  Base directory: ${workspace_loc:/Bookstore}
  Goals: clean package
  User settings: C:\Users\sjfke\.m2\settings.xml (File System ...) # File System...

  * [x] Update Snapshots
  * [x] Resolve Workspace artifacts

Common Tab:
  Favorites menu
    * [x] Run
  Encoding
    * Other: UTF-8
```

This will generate `Bookstore\target\Bookstore-0.0.1-SNAPSHOT.war` which can be deployed manually if you locally installed and configured [Tomcat](./TOMCAT.md).

> ***Note*** a refresh of the `Bookstore\target` folder may be needed for `Bookstore-0.0.1-SNAPSHOT.war` to be visible

To rerun the `Bookstore` configuration it should appear under `Run` > `Run Configurations...` > `Maven Build`

### Build Using Maven outside of Eclipse

The [previous section](./to-execute-maven-create-a-run-configuration) will generate a `pom.xml` file like

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>Bookstore</groupId>
  <artifactId>Bookstore</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  <packaging>war</packaging>
  <build>
    <plugins>
      <plugin>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.8.1</version>
        <configuration>
          <release>17</release>
        </configuration>
      </plugin>
      <plugin>
        <artifactId>maven-war-plugin</artifactId>
        <version>3.2.3</version>
      </plugin>
    </plugins>
  </build>
  <dependencies>
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>javax.servlet-api</artifactId>
      <version>3.1.0</version>
      <scope>provided</scope>
    </dependency>
    <dependency>
      <groupId>javax.servlet.jsp</groupId>
      <artifactId>javax.servlet.jsp-api</artifactId>
      <version>2.3.1</version>
      <scope>provided</scope>
    </dependency>
  <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>jstl</artifactId>
      <version>1.2</version>
  </dependency>
  <dependency>
    <groupId>taglibs</groupId>
    <artifactId>standard</artifactId>
    <version>1.1.2</version>
  </dependency>
    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <version>5.1.30</version>
    </dependency>
  </dependencies>
</project>
```

On Windows building from the command line you may see a `File encoding has not been set, using platform encoding Cp1252`, the solution is explained on the *Apache Maven Website*, [**WARNING** Using platform encoding (Cp1252 actually) to copy filtered resources](https://maven.apache.org/general.html#encoding-warning).

For `Bookstore` add the following prior to the `<build>` tag, then command line `mvn package` will build cleanly.

```xml
  <packaging>war</packaging>
  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
  </properties>
  <build>
    ...
  </build>
```

Build the `Bookstore-0.0.1-SNAPSHOT.war` file and then containerize it.

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> mvn -f .\Bookstore\pom.xml clean package

# Docker
PS C:\Users\sjfke> docker build --tag localhost/bookstore:latest -f .\Dockerfile $PWD

# Podman
PS C:\Users\sjfke> podman build --tag localhost/bookstore:latest --squash -f .\Dockerfile
```

### Deploy `Bookstore` war file to Tomcat in Eclipse

On the `Servers` tab, *right-click* on the `Tomcat v9 Server at localhost`, and select `Add and Remove...`

Select `Bookstore` from `Available:` and `Add >` to `Configured:`

### Testing the `Bookstore` application in Eclipse

First the start the database

***Podman-Compose*** from within the `Python` virtual environment.

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
(venv) PS C:\Users\sjfke> podman-compose -f .\compose-mariadb-simple.yaml up -d  # Start MariaDB and Adminer
(venv) PS C:\Users\sjfke> Test-NetConnection localhost -Port 3306                # Check MariDB is up and accessible
sjfke@unix $ nc -i 5 localhost 3306                                              # Check MariDB is up and accessible
```

***Docker***

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> docker compose -f .\compose-mariadb-simple.yaml up -d  # Start MariaDB and Adminer
PS C:\Users\sjfke> Test-NetConnection localhost -Port 3306                # Check MariDB is up and accessible
sjfke@unix$ nc -i 5 localhost 3306                                        # Check MariDB is up and accessible
```

***Podman Kube***

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers\wharf\Podman
PS C:\Users\sjfke> podman secret list                              # check secrets are loaded
PS C:\Users\sjfke> podman volume list                              # check volume exists
PS C:\Users\sjfke> podman network ls                               # check `jspnet` network exists
PS C:\Users\sjfke> podman play kube --start .\adminer-pod.yaml     # Start Adminer
PS C:\Users\sjfke> podman play kube --start .\bookstoredb-pod.yaml # Start MariaDB
PS C:\Users\sjfke> Test-NetConnection localhost -Port 3306         # Check MariDB is up and accessible
sjfke@unix$ nc -i 5 localhost 3306                                 # Check MariDB is up and accessible
```

On the `Servers` tab, *right-click* on the `Tomcat v9 Server at localhost`, and select `Start`

Test using your browser or from `Powershell` or `UNIX` command line as shown

```console
PS C:\Users\sjfke> start http://localhost:8081           # Check Adminer is working
PS C:\Users\sjfke> start http://localhost:8080           # Check Tomcat Server is working
PS C:\Users\sjfke> start http://localhost:8080/Bookstore # Check application is working

sjfke@unix$ firefox http://localhost:8081                # Check Adminer is working
sjfke@unix$ firefox http://localhost:8080                # Check Tomcat Server is working
sjfke@unix$ firefox http://localhost:8080/Bookstore      # Check application is working
```

Stopping and removing the database deployment

***Podman-Compose*** from within the `Python` virtual environment.

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
(venv) PS C:\Users\sjfke> podman-compose -f .\compose-mariadb.yaml down # Ensure MariaDB and Adminer are stopped
```

***Docker***

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> docker compose -f .\compose-mariadb.yaml down        # Ensure MariaDB and Adminer are stopped
```

***Podman Kube***

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers\wharf\Podman
PS C:\Users\sjfke> podman play kube --down .\adminer-pod.yaml           # Ensure Adminer is stopped
PS C:\Users\sjfke> podman play kube --down .\bookstoredb-pod.yaml       # Ensure MariaDB is stopped
```

### Testing the `Bookstore` application using `compose`

Using the `compose-bookstore.yaml` file

***Podman-Compose*** from within the `Python` virtual environment.

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
(venv) PS C:\Users\sjfke> podman-compose -f .\compose-bookstore.yaml up -d # Start Bookstore, MariaDB and Adminer
PS C:\Users\sjfke> start http://localhost:8081                             # Check Adminer is working
PS C:\Users\sjfke> start http://localhost:8080                             # Check Tomcat Server is working
PS C:\Users\sjfke> start http://localhost:8080/Bookstore                   # Check application is working
(venv) PS C:\Users\sjfke> podman-compose -f .\compose-bookstore.yaml down  # Start Bookstore, MariaDB and Adminer
```

***Docker***

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> docker compose -f .\compose-bookstore.yaml up -d        # Start Bookstore, MariaDB and Adminer
PS C:\Users\sjfke> start http://localhost:8081                             # Check Adminer is working
PS C:\Users\sjfke> start http://localhost:8080                             # Check Tomcat Server is working
PS C:\Users\sjfke> start http://localhost:8080/Bookstore                   # Check application is working
PS C:\Users\sjfke> docker compose -f .\compose-bookstore.yaml down         # Start Bookstore, MariaDB and Adminer
```

### Testing the `Bookstore` application using `Podman Kube`

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> podman secret list                                               # check secrets are loaded
PS C:\Users\sjfke> podman volume list                                               # check volume exists
PS C:\Users\sjfke> podman network ls                                                # check `jspnet` network exists
PS C:\Users\sjfke> podman play kube --start --network jspnet .\adminer-pod.yaml     # Deploy and start Adminer
PS C:\Users\sjfke> podman play kube --start --network jspnet .\bookstoredb-pod.yaml # Deploy and start MariaDB
PS C:\Users\sjfke> Test-NetConnection localhost -Port 3306                          # Check MariDB is up and accessible
sjfke@unix$ nc -i 5 localhost 3306                                                  # Check MariDB is up and accessible

PS C:\Users\sjfke> podman play kube --start --network jspnet .\bookstore-pod.yaml   # Deploy and start Bookstore

PS C:\Users\sjfke> start http://localhost:8081                                      # Check Adminer is working
PS C:\Users\sjfke> start http://localhost:8080                                      # Check Tomcat Server is working
PS C:\Users\sjfke> start http://localhost:8080/Bookstore                            # Check application is working

PS C:\Users\sjfke> podman play kube --down .\bookstore-pod.yaml                     # Stop and remove Bookstore
PS C:\Users\sjfke> podman play kube --down .\adminer-pod.yaml                       # Stop and remove Adminer
PS C:\Users\sjfke> podman play kube --down .\bookstoredb-pod.yaml                   # Stop and remove MariaDB
```
