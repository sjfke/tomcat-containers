# tomcat-containers
Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB

# Creating MariaDB (MySQL) Database

There are a number of errors in the SQL in the tutorial, and using `root` for an application is problematic.

***Aside:*** `price` should probably be a `decimal(9,2)` and not `float`, but the Java class code is using `float`.

## Create the `Bookstore.book` table.

From `docker-desktop` open a terminal on the `tomcat-containers-bookstoredb-1` container.

***Note:*** Maria Database root password is in the `compose.yaml` file.

```shell
# mysql -u root -p
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

## Create an application account and grant access.

```
# mysql -u root -p
Enter password:
MariaDB [(none)]> use Bookstore;
MariaDB [Bookstore]> create user 'bsapp'@'%' identified by 'P@ssw0rd';
MariaDB [Bookstore]> grant all privileges on Bookstore.* to 'bsapp'@'%';
MariaDB [Bookstore]> flush privileges;
MariaDB [Bookstore]> show grants for 'bsapp'@'%';
MariaDB [Bookstore]> exit;
```
> #### Notice: 
>
> - The *bsapp* account is not IP access restricted, i.e. not 'bsapp'@'localhost'.
> - *Docker* will allocate a random RFC-1918 IP to the database when it is deployed.

## Verify application account access.

```
# mysql -u bsapp -p Bookstore
Enter password:
MariaDB [Bookstore]> select * from book;
MariaDB [Bookstore]> exit;
```

## Using Adminer Web Interface

All of the above steps can be done and checked using through [adminer](http://localhost:8395/).

```
System: MySQL
Server: bookstoredb
Username: root
Password: r00tpa55
Database: <blank>
```

# Application Preparation (Windows-11 Home)

## Apache Tomcat Preparation (Windows-11 Home)

* [Temurin™ for Windows x64 Prebuilt OpenJDK Binaries for Free!](https://adoptium.net/)
  * Install Temurin™ for Windows https://adoptium.net/ 
  * Using defaults, and enabled everything, it needed by tomcat (same JRE is bundled in Eclipse JEE)
  * Installs into "C:\Program Files\Eclipse Adoptium\jdk-17.0.6.10-hotspot", enabled everything

* [Tomcat 9 Software Downloads](https://tomcat.apache.org/download-90.cgi)
  * Install Tomcat installation required to start 'Dynamic Web Project' (KISS and not force to Docker)
  * Install everything, including `docs`, `examples`, `host-manager`, and `manager`
  * Installation propmpts for tomcat users, `user:admin`, `password: admin` for roles `manager-gui,admin-gui`
  * Installation "C:\Program Files\Apache Software Foundation\Tomcat 9.0"
  * Creates a service that requires manual starting `Service "Apache Tomcat 9.0 Tomcat9"`
  
## Eclipse JEE preparation (Windows-11 Home)

Download and install

* [Eclipse Installer 2022-12 R](https://www.eclipse.org/downloads/packages/installer)
* [Eclipse IDE for Enterprise Java and Web Developers](https://www.eclipse.org/downloads/packages/release/2022-12/r/eclipse-ide-enterprise-java-and-web-developers)

Under `Window` > `Preferences` > `General` > `Appearence` you can enable `theming` like `Dark Mode`

## MariaDB preparation

For this project a local MariaDB installation was not installed, downloads and instructions:  

* [MariaDB Community Downloads](https://mariadb.com/downloads)

# Creating Eclipse Project

Follow the instructions in the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example).

## Creating Eclipse Project with Maven

Eclipse: `File` > `New` > `Dynamic Web Project`

For tomcat installation folder select `tomcat`

The POM.XML update stanza goes between `</build>` and `</project>`

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

Useful pom dependency references, unspecified <scope> is compile (see 2)
  1. [How To Find Maven Dependencies](https://www.baeldung.com/java-find-maven-dependencies)
  2. [Maven Dependency Scopes](https://www.baeldung.com/maven-dependency-scopes)

## Writing Model Class

Modification to the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example).

```java
public Book(int id, String title, String author, float price) {
	// this(title, author, price);
	this.id = id;
	this.title = title;
	this.author = author;
	this.price = price;
}
```

## Coding DAO class

Follow the instructions in the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example).

For additional help: [JDBC CRUD Operations Tutorial:](https://www.codejava.net/java-se/jdbc/jdbc-tutorial-sql-insert-select-update-and-delete-examples)

## Writing Book Listing JSP Page

Create a JSP page for displaying all books from the database in `Bookstore\src\main\webapp`.

Modifications to the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example).

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
	<%-- 	<a href="/edit?id=<c:out value='${book.id}' />">Edit</a> --%>
	<%-- 	&nbsp;&nbsp;&nbsp;&nbsp; --%>	
	<%-- 	<a href="/delete?id=<c:out value='${book.id}' />">Delete</a> --%>
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

## Writing Book Form JSP Page

Create a JSP page for creating a new book in `Bookstore\src\main\webapp`.

Modification to the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example)

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

## Coding Controller Servlet Class

Create a ControllerServlet class in `Bookstore\src\main\java\net\codejava\javaee\bookstore`.

Follow the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example)

## Configuring Web.xml

Create `Bookstore/src/main/webapp/WEB-INF/web.xml`.

Modification to the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example).

* change `<param-name>jdbcUsername</param-name>`
* change `<param-name>jdbcPassword</param-name>`

An example skeleton [web.xml for servlet 3.1](https://gist.github.com/darbyluv2code/dd3781d61c3db5476fbf05ee431ee917)

## Writing Error JSP page

Create `Bookstore/src/main/webapp/Error.jsp`

Modification to the [tutorial](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example).

* Make HTML-5


