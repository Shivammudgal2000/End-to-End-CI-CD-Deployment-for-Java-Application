# Step 1: Secure, lightweight base environment containing the Java 11 runtime environment
FROM tomcat:9.0-jre11-slim

# Elite Edge: Purge standard pre-installed web applications to eliminate known attack vectors
RUN rm -rf /usr/local/tomcat/webapps/*

# Step 2: Inject your compiled artifact into the absolute root deployment path
COPY target/java-app.war /usr/local/tomcat/webapps/ROOT.war

# Step 3: Define the explicit network entrance point inside the container isolation zone
EXPOSE 8080

# Step 4: Define the runtime execution target to initiate the server lifecycle
CMD ["catalina.sh", "run"]