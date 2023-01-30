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
See `wharf/DOCKER_ME.md` for docker notes.

```
$ docker compose down --rmi local; docker compose build; docker compose up -d
```

See `wharf/DOCKER_ME.md` for how to redeploy the docker containers.

## How to add Tomcat server in Eclipse IDE

Follow [How to add Tomcat server in Eclipse IDE](https://www.codejava.net/servers/tomcat/how-to-add-tomcat-server-in-eclipse-ide) tutorial.

Aside: the project used ***Apache Tomcat v9.0***.

The Tomcat server should be installed see "Apache Tomcat Preparation" in `BUILD_ME.md` but not running.

Creating a new local server and Eclipse does not create `tomcat-users.xsd`, so the `tomcat-users.xml` in the `Servers` folder will show errors.

  * [Download and install ](https://github.com/apache/tomcat/blob/main/conf/tomcat-users.xsd) 

The next `Tomcat` error maybe be encountered is something like:
>
> The server cannot be started because one or more of the ports are invalid. 
> Open the server editor and correct the invalid ports.

Most likely this because the `Tomcat admin port` is not configured, see [Can't start tomcatv9.0 in Eclipse](https://stackoverflow.com/questions/59471438/cant-start-tomcatv9-0-in-eclipse)

You can now drag and drop a project into this server in order to deploy and run the project.

So now `http://localhost:8080/Bookstore/` should now connect.

If it errors out again, displays the `Error.jsp` page, this is ok.
>
> Error
> Access denied for user 'bsapp'@'172.22.0.1' (using password: YES)

> #### Notice:
> - IP is not the `localhost` this is because the `MariaDB` server is inside a *Docker Environment*.
> - Docker is using it's own `jspnet` IP (RFC-1918) network. 
> - Unlike `Linux`, `Windows` does not always handle NAT of `localhost`.


***Aside:*** Testing the application from within Eclipse and the `context directory` is not included 
in the URL, so hard-coded URL's such as `<a href="/new">Add New Book</a>` work. 

## Building a Maven war file.

To function `Maven` requires a minimal `settings.xml` which may have to be manually created, see:

```
$ new-item C:\Users\sjfke\.m2\settings.xml
$ get-content C:\Users\sjfke\.m2\settings.xml
```

1. [Maven plugin in Eclipse - Settings.xml file is missing](https://stackoverflow.com/questions/4626609/maven-plugin-in-eclipse-settings-xml-file-is-missing) very old reference *but* works!
2. [Apache Maven Project - Settings Reference](https://maven.apache.org/settings.html)

Check syntax by opening the file in Eclipse.

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

### To execute Maven, create a Run Configuration 

Eclipse: run > Run Configurations..

Creates m2 Maven Build > New_configuration

```
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
```

This will generate `Bookstore\target\Bookstore-0.0.1-SNAPSHOT.war` which can be deployed manually.

### General Maven Packaging questions

* [Using Maven within the Eclipse IDE - Tutorial](https://www.vogella.com/tutorials/EclipseMaven/article.html)
* [Apache Maven Project - Introduction to the Build Lifecycle](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)
* [Apache Maven Project - WAR Plugin Usage](https://maven.apache.org/plugins/maven-war-plugin/usage.html)
* [Apache Maven Project - WAR Plugin Documentation](https://maven.apache.org/plugins/maven-war-plugin/plugin-info.html)
* [How to Deploy a WAR File to Tomcat](https://www.baeldung.com/tomcat-deploy-war)

