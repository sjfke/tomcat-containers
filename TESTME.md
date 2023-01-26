# tomcat-containers
Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB

# Deploying and Testing the Application

## Exposing MariaDB (MySQL) Database on localhost:3306

* Modify compose.yaml to expose Mariadb on localhost:3306

```diff
   bookstoredb:
    image: mariadb
    restart: unless-stopped
+   ports:
+     - 3306:3306
    environment:
      MARIADB_ROOT_PASSWORD: r00tpa55
    networks:
```
See `wharf/README.md` for docker notes.

```shell
$ docker compose down --rmi local; docker compose build; docker compose up -d
```

See `wharf/README.md` for how to redeploy the docker containers.

## How to add Tomcat server in Eclipse IDE

Follow [How to add Tomcat server in Eclipse IDE](https://www.codejava.net/servers/tomcat/how-to-add-tomcat-server-in-eclipse-ide) instructions,

Aside: I used ***Apache Tomcat v9.0***.

The Tomcat server should be installed see "Apache Tomcat Preperation" in `BUILDME.md` but not running.

Creating a new local server does not create `tomcat-users.xsd`, so the `tomcat-users.xml` in the `Servers` folder will show errors.

  * [Download and install ](https://github.com/apache/tomcat/blob/main/conf/tomcat-users.xsd) 

The next error is `Tomcat` with something like:
> The server cannot be started because one or more of the ports are invalid. 
> Open the server editor and correct the invalid ports.

See, [Can't start tomcatv9.0 in Eclipse](https://stackoverflow.com/questions/59471438/cant-start-tomcatv9-0-in-eclipse)

You can now drag and drop a project into this server in order to deploy and run the project.

So now `http://localhost:8080/Bookstore/` will connect but will again error out, using the `Error.jsp` page if running on 'Windows'.

> Error
> Access denied for user 'user1'@'172.22.0.1' (using password: YES)

Notice the IP is not the `localhost` this is because the `MariaDB` server is inside a ***Docker Environment*** which has it's own `jspnet` 
IP network, and `Windows` does not handle NAT of `localhost`, a recent Fedora release will work.

Testing this way avoids `<a href="/new">Add New Book</a>` issues, because the `context directory` is not included in the URL.


## Maven war file build.

Eclipse: run -> Run Configurations.. M2 Bookstore


## Maven Packaging
https://www.vogella.com/tutorials/EclipseMaven/article.html
https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html

https://maven.apache.org/plugins/maven-war-plugin/usage.html
https://maven.apache.org/plugins/maven-war-plugin/plugin-info.html

https://stackoverflow.com/questions/4764405/how-to-use-relative-paths-without-including-the-context-root-name
https://www.oreilly.com/library/view/javaserver-pages-3rd/0596005636/re39.html
 
https://www.baeldung.com/tomcat-deploy-war



