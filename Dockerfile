FROM tomcat:9.0.71-jdk17-temurin

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.name="Bookstore" \
      io.k8s.description="Tomcat JSP for Docker and Podman testing" \
      io.k8s.display-name="Bookstore" \
      io.k8s.version="0.0.1" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="Tomcat JSP,Bookstore,0.0.1,Docker,Podman"

# CATALINA_BASE:   /usr/local/tomcat
# CATALINA_HOME:   /usr/local/tomcat
# CATALINA_TMPDIR: /usr/local/tomcat/temp
# JRE_HOME:        /usr
# CLASSPATH:       /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar
# Tomcat configuration files are available in /usr/local/tomcat/conf/

ENV PORT=8080
WORKDIR /usr/local/tomcat

# Setup Tomcat in a development configuration
RUN mv webapps webapps.safe
RUN mv webapps.dist/ webapps
COPY ./wharf/Docker/webapps/manager/META-INF/context.xml /usr/local/tomcat/webapps/manager/META-INF/
COPY ./wharf/Docker/webapps/host-manager/META-INF/context.xml /usr/local/tomcat/webapps/host-manager/META-INF/
COPY ./wharf/Docker/conf/tomcat-users.xml /usr/local/tomcat/conf/
RUN chmod 644 /usr/local/tomcat/conf/tomcat-users.xml

# Deploy the Bookstore application, using the output of the Maven build
# Modified web.xml changes jdbc:mysql for Docker, 'jdbc:mysql://SERVICE-NAME:3306/DATABASE-NAME'
COPY ./Bookstore/target/Bookstore-0.0.1-SNAPSHOT/ /usr/local/tomcat/webapps/Bookstore
COPY ./wharf/Docker/webapps/Bookstore/WEB-INF/web.xml /usr/local/tomcat/webapps/Bookstore/WEB-INF/web.xml

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
# USER 1001
USER 1

# TODO: Set the default port for applications built using this image
# EXPOSE ${PORT}
CMD ["catalina.sh", "run"]
# CMD tail -F /dev/null # docker run -it flask-auth-web /bin/sh