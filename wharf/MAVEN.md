# Eclipse and Maven for tomcat-containers

Configuring Maven for [Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) development.

## Building with Maven

To function `Maven` requires a minimal `settings.xml` which may have to be manually created, see example below:

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

1. [Maven plugin in Eclipse - Settings.xml file is missing](https://stackoverflow.com/questions/4626609/maven-plugin-in-eclipse-settings-xml-file-is-missing) very old reference *but* still works!
2. [Apache Maven Project - Settings Reference](https://maven.apache.org/settings.html)

> ***Note***
>
> Easiest way to create the file is using `Eclipse`, but note that opening the file in `Eclipse` will perform a syntax check.

### General Maven Packaging questions

* [Using Maven within the Eclipse IDE - Tutorial](https://www.vogella.com/tutorials/EclipseMaven/article.html)
* [Apache Maven Project - Introduction to the Build Lifecycle](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)
* [Apache Maven Project - WAR Plugin Usage](https://maven.apache.org/plugins/maven-war-plugin/usage.html)
* [Apache Maven Project - WAR Plugin Documentation](https://maven.apache.org/plugins/maven-war-plugin/plugin-info.html)
* [How to Deploy a WAR File to Tomcat](https://www.baeldung.com/tomcat-deploy-war)
* [10 best practices to build a Java container with Docker](https://snyk.io/blog/best-practices-to-build-java-containers-with-docker/)

### Installing Maven

* [Installing Apache Maven](https://maven.apache.org/install.html)

Follow [How to Install Maven on Windows](https://phoenixnap.com/kb/install-maven-windows) instructions

* [Download latest Maven](https://maven.apache.org/download.cgi), such as `apache-maven-3.9.6`
* Create `System` environment `MAVEN_HOME` = `C:\Program Files\Maven\apache-maven-3.9.6`
* Update `Path`, add `%MAVEN_HOME%\bin`

```console
PS C:\Users\sjfke>  mvn -version
Apache Maven 3.9.6 (bc0240f3c744dd6b6ec2920b3cd08dcc295161ae)
Maven home: C:\Program Files\Maven\apache-maven-3.9.6
Java version: 17.0.7, vendor: Eclipse Adoptium, runtime: C:\Program Files\Eclipse Adoptium\jdk-17.0.7.7-hotspot
Default locale: en_GB, platform encoding: Cp1252
OS name: "windows 11", version: "10.0", arch: "amd64", family: "windows"
```
