FROM tomcat:latest
COPY ./target/SWE645HW2.war /usr/local/tomcat/webapps
EXPOSE 8080
CMD ["catalina.sh", "run"]
