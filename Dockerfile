FROM tomcat:latest
COPY SWE645.war /usr/local/tomcat/webapps
EXPOSE 8080
CMD ["catalina.sh", "run"]