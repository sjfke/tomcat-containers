# Eclipse and Maven for tomcat-containers

Configuring Maven for [Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) development.

## Building a Maven war file

To function `Maven` requires a minimal `settings.xml` which may have to be manually created, see:

```console
PS C:\Users\sjfke> new-item C:\Users\sjfke\.m2\settings.xml
PS C:\Users\sjfke> get-content C:\Users\sjfke\.m2\settings.xml
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

1. [Maven plugin in Eclipse - Settings.xml file is missing](https://stackoverflow.com/questions/4626609/maven-plugin-in-eclipse-settings-xml-file-is-missing) very old reference *but* works!
2. [Apache Maven Project - Settings Reference](https://maven.apache.org/settings.html)

Check syntax by opening the file in Eclipse.

### To execute Maven, create a Run Configuration

Eclipse: `Run` > `Run Configurations...`

Create, manage, and run configurations: `Maven Build` > `New_configuration`

```text
Main Tab:
  Base directory > Workspace > Bookstore #  Base directory: ${workspace_loc:/Bookstore}
  Goals: clean package
  User settings: C:\Users\sjfke\.m2\settings.xml

  * [x] Update Snapshots
  * [x] Resolve Workspace artifacts

Common Tab:
  Favorites menu
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
