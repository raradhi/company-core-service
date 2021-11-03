FROM amazoncorretto:11-alpine-jdk
LABEL maintainer="Luma Financial Technologies DevOps"
RUN adduser -s /bin/sh -h /app appuser -D
RUN mkdir -p /app/logs/
ADD ca.jks /app/ca.jks
ADD target/app.jar /app/app.jar
RUN chown appuser:appuser /app/ -R
RUN apk update && apk upgrade
USER appuser
WORKDIR /app/
ENV JAVA_OPTS="-server -Xms128m -Xmx128m -XX:+UseG1GC -XX:+HeapDumpOnOutOfMemoryError -Djava.security.egd=file:/dev/./urandom -Dspring.jmx.enabled=false -Djavax.net.ssl.trustStore=/app/ca.jks -Djavax.net.ssl.trustStoreType=jks -Djavax.net.ssl.trustStorePassword=changeit"
EXPOSE 8080
CMD exec java $JAVA_OPTS -jar /app/app.jar