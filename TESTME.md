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
IP network, and `Windows` does not handle NAT of `localhost`, using a recent Fedora release will local MariaDB installation works.

Testing this way avoids `<a href="/new">Add New Book</a>` issues, because the `context directory` is not included in the URL.


## Maven war file build.

Maven requires a minimal `settings.xml` which has to be manually created.
Check syntax by opening the file in Eclipse.

```
$ new-item C:\Users\sjfke\.m2\settings.xml
$ get-content C:\Users\sjfke\.m2\settings.xml
```

```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                      http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <localRepository/>
  <interactiveMode/>
  <usePluginRegistry/>
  <offline/>
  <pluginGroups/>
  <servers/>
  <mirrors/>
  <proxies/>
  <profiles/>
  <activeProfiles/>
</settings>
```

* [Maven plugin in Eclipse - Settings.xml file is missing](https://stackoverflow.com/questions/4626609/maven-plugin-in-eclipse-settings-xml-file-is-missing) very old reference *but* works!
* [Apache Maven Project - Settings Reference](https://maven.apache.org/settings.html)

### Run Configuration to execute Maven

Eclipse: run > Run Configurations..

Creates m2 Maven Build > New_configuration

Main Tab:
	Base directory > Workspace > Bookstore #  Base directory: ${workspace_loc:/Bookstore}
	Goals: clean package
	User settings: C:\Users\sjfke\.m2\settings.xml

	* [x] Update Snapshots
	* [x] Resolve Workspace artifacts
	
Common Tab:
	Favourites menu
		* [x] Run
	Encoding
		* Other: UTF-8

This will generate `Bookstore\target\Bookstore-0.0.1-SNAPSHOT.war` which can be deploed manually.


### General Maven Packaging questions

* [Using Maven within the Eclipse IDE - Tutorial](https://www.vogella.com/tutorials/EclipseMaven/article.html)
* [Apache Maven Project - Introduction to the Build Lifecycle](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)
* [Apache Maven Project - WAR Plugin Usage](https://maven.apache.org/plugins/maven-war-plugin/usage.html)
* [Apache Maven Project - WAR Plugin Documentation](https://maven.apache.org/plugins/maven-war-plugin/plugin-info.html)
* [How to Deploy a WAR File to Tomcat](https://www.baeldung.com/tomcat-deploy-war)

