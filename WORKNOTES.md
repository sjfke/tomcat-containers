# tomcat-containers
Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB

# Creating MariaDB (MySQL) Database

There are a number of errors in the SQL in the tutorial, and using `root` for an application is problematic.

Aside: the `price` should probably be a `decimal(9,2)` and not `float`.

## Create the `Bookstore.book` table.

From `docker-desktop` open a terminal on the `tomcat-containers-bookstoredb-1` container.

```bash
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

```bash
# mysql -u root -p
Enter password:
MariaDB [(none)]> use Bookstore;
MariaDB [Bookstore]> create user 'user1'@'localhost' identified by 'P@ssw0rd';
MariaDB [Bookstore]> grant all privileges on Bookstore.* to 'user1'@'localhost';
MariaDB [Bookstore]> flush privileges;
MariaDB [Bookstore]> show grants for 'user1'@'localhost';
MariaDB [Bookstore]> exit;
```
## Verify application account access.

```bash
# mysql -u user1 -p Bookstore
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


# Project Apache Tomcat Preperation

* [Temurin™ for Windows x64 Prebuilt OpenJDK Binaries for Free!](https://adoptium.net/)
* [Tomcat 9 Software Downloads](https://tomcat.apache.org/download-90.cgi)
