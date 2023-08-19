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

## 1. Creating MySQL Database

There are a number of errors in the SQL in the tutorial, and using `root` for an application is problematic.

> ***Note:***
>
> `price` should probably be a `decimal(9,2)` and not `float`, but the Java class code is using `float`.

Assuming you have `MariaDB` running in your chosen container environment.

### Create the `Bookstore.book` table

* `docker-desktop` open a terminal on the `tomcat-containers-bookstoredb-1` container
* `podman-desktop` open a terminal on the `bookstoredb-1` container

> ***Note:***
>
> Maria Database root password is in the `compose-mariadb.yaml` and `compose.yaml` files.

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

All of the above steps can be done and checked using through [adminer](http://localhost:8395/).

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

The remember to create a Java package name for the project, `net.codejava.javaee.bookstore`.

Eclipse: `Bookstore` > `Java Resources` > `New` > `Package`

Useful pom dependency references, unspecified `<scope>` is compile (see 2)

  1. [How To Find Maven Dependencies](https://www.baeldung.com/java-find-maven-dependencies)
  2. [Maven Dependency Scopes](https://www.baeldung.com/maven-dependency-scopes)

In setting up the project you need to install `tomcat` in the `tomcat` folder in `Eclipse` workspace as described in [Tomcat Server in Eclipse IDE](#tomcat-server-in-eclipse-ide)

### Tomcat Server in Eclipse IDE

1. [How to configure tomcat server in Eclipse IDE](https://www.javatpoint.com/how-to-configure-tomcat-server-in-eclipse-ide)
2. [Setup and Install Apache Tomcat Server in Eclipse IDE](https://crunchify.com/step-by-step-guide-to-setup-and-install-apache-tomcat-server-in-eclipse-development-environment-ide/)

Create a `tomcat` folder in the Eclipse workspace folder which is used in the `Download and install` step.

Follow the instructions but select the workspace `tomcat` folder, and then the `Download and install`

Eclipse will use this copy not the one installed earlier avoiding `Admin`, and `Deployment` configuration.

Look at *Step 5* onwards in reference (2) above, to ensure all is OK.

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
* Make `hard-coded` URL's, "/list" etc, `context directory` agnostic using JSTL `<c:url>` tag
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
* Make `hard-coded` URL's, "/new", "/list", `context directory` agnostic using JSTL `<c:url>` tag

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

Create `Bookstore/src/main/webapp/WEB-INF/web.xml`.

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

An example skeleton [web.xml for servlet 3.1](https://gist.github.com/darbyluv2code/dd3781d61c3db5476fbf05ee431ee917)

### 9. Writing Error JSP page

Create `Bookstore/src/main/webapp/Error.jsp`

Follow the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) with the following modifications.

* Make HTML-5
