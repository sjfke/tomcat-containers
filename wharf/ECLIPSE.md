# Setup of Eclipse for tomcat-containers

Eclipse set up for [Containerized Tomcat JSP Servlet JDBC C.R.U.D Example using MariaDB](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) development.

## Windows Platform Setup

### Eclipse JEE preparation

Download and install

* [Eclipse Installer 2023-12 R](https://www.eclipse.org/downloads/packages/installer)
* [Eclipse IDE for Enterprise Java and Web Developers](https://www.eclipse.org/downloads/packages/release/2022-12/r/eclipse-ide-enterprise-java-and-web-developers)

Install Eclipse Marketplace plugins

* Java and Web Developer Tools 3.31, accepting the defaults, restart
`Help` > `Eclipse Marketplace` > `Popular` > `Eclipse Java and Web Developer Tools 3.31`

* LiClipseText 2.5.0, accepting the defaults, restart
`Help` > `Eclipse Marketplace` > `Search` > `LiClipseText`

* Markdown Text Editor 1.2.0, accepting the defaults, restart
`Help` > `Eclipse Marketplace` > `Search` > `Markdown Text Editor`

* Eclipse Docker Tooling 5.12.0.202309052024
`Help` > `Eclipse Marketplace` > `Search` > `Docker Tooling`

Appearance Preferences

Under `Window` > `Preferences` > `General` > `Appearance` you can enable `Dark Mode` theme

## MacOS Platform (Intel) Setup

### `brew` installation

```zsh
# Install Java
$ brew search temurin
$ brew install temurin21 # or your chosen 
$ java -version          # list the version you installed

# Install Eclipse
$ brew install eclipse-installer # warns needs Java, suggests 'brew install --cask temurin'
```

`Double-click` on the `Eclipse Installer` in the `Applications` folder

### Manual installation

* [Eclipse Installer 2024-03 R](https://www.eclipse.org/downloads/packages/installer) - download the installer
* [Prebuilt OpenJDK Binaries for Free](https://adoptium.net/) - download the "Latest LTS Release"

Install `Eclipse` choosing an appropriate JRE or JDK, JRE 21.0.2 for this install.

Also install `Temurin` as it will be need to run `tomcat` and is needed by `maven`

Having installed `eclipse` now install the `Eclipse Marketplace plugins`

### Install Eclipse Marketplace plugins

* Java and Web Developer Tools 3.31, accepting the defaults, restart
`Help` > `Eclipse Marketplace` > `Popular` > `Eclipse Java and Web Developer Tools 3.31`

* LiClipseText 2.5.0, accepting the defaults, restart
`Help` > `Eclipse Marketplace` > `Search` > `LiClipseText`

* Markdown Text Editor 1.2.0, accepting the defaults, restart
`Help` > `Eclipse Marketplace` > `Search` > `Markdown Text Editor`

* Eclipse Docker Tooling 5.12.0.202309052024
`Help` > `Eclipse Marketplace` > `Search` > `Docker Tooling`

Appearance Preferences

Under `Window` > `Preferences` > `General` > `Appearance` you can enable `Dark Mode` theme

## Fedora Platform Setup

While possible to use Fedora spin, it has too many dependencies, so manually download and install

Download and install

* [Eclipse Installer 2023-12 R](https://www.eclipse.org/downloads/download.php?file=/oomph/epp/2023-12/R/eclipse-inst-jre-linux64.tar.gz)

Install Eclipse Marketplace plugins

* Java and Web Developer Tools 3.31, accepting the defaults, restart
`Help` > `Eclipse Marketplace` > `Popular` > `Eclipse Java and Web Developer Tools 3.31`

* LiClipseText 2.5.0, accepting the defaults, restart
`Help` > `Eclipse Marketplace` > `Search` > `LiClipseText`

* Markdown Text Editor 1.2.0, accepting the defaults, restart
`Help` > `Eclipse Marketplace` > `Search` > `Markdown Text Editor`

* Eclipse Docker Tooling 5.12.0.202309052024
`Help` > `Eclipse Marketplace` > `Search` > `Docker Tooling`

Appearance Preferences

Under `Window` > `Preferences` > `General` > `Appearance` you can enable `Dark Mode` theme
