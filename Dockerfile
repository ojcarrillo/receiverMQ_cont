#imagen base
FROM ubuntu:16.04

#install java, vsftpd , supervisor
RUN apt-get update && \
        apt-get install -y openjdk-8-jdk && \
        apt-get install -y ant && \
        apt-get install -y vsftpd supervisor && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* && \
        rm -rf /var/cache/oracle-jdk8-installer && \
        mkdir -p /var/run/vsftpd/empty;

#set enviroment java path
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

ENV PATH $PATH:/usr/lib/jvm/java-8-openjdk-amd64/jre/bin:/usr/lib/jvm/java-1.8.0-openjdk-amd64/bin

#enviroment var for user and pass in ftp
ENV USER ftpuser
ENV PASS changeme

#dir for supervisor
RUN mkdir -p /var/log/supervisor

#copy / add files for java application and conf
COPY target/sandbox-cont-receiverMQ.jar app.jar
ADD conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD conf/start.sh /usr/local/bin/start.sh
ADD conf/vsftpd.conf /etc/vsftpd.conf

#dir ftp
RUN mkdir /ftp
VOLUME ["/ftp"]

#ports vsftpd
EXPOSE 20 21
EXPOSE 12020 12021 12022 12023 12024 12025

#entrypoint supervisor
ENTRYPOINT ["/usr/local/bin/start.sh"]

#command supervisor start
CMD ["/usr/bin/supervisord"]
