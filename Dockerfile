FROM java

MAINTAINER Pavel Popov <schmooser@gmail.com>

# TeamCity environment variables
ENV TEAMCITY_DATA_PATH /data/teamcity
ENV TEAMCITY_SERVER_MEM_OPTS -Xmx750m -XX:MaxPermSize=270m
ENV TEAMCITY_SERVER_OPTS -Dteamcity.git.fetch.separate.process=false

# TeamCity version
ENV TC_PACKAGE TeamCity-9.1.3
ENV TC_PATH /opt/${TC_PACKAGE}
ENV TC_URL http://download.jetbrains.com/teamcity/${TC_PACKAGE}.tar.gz

# Postgres JDBC drivers
ENV PG_JDBC=postgresql-9.4-1205.jdbc4.jar
RUN mkdir -p ${TEAMCITY_DATA_PATH}/lib/jdbc && \
    curl -vL --output ${TEAMCITY_DATA_PATH}/lib/jdbc https://jdbc.postgresql.org/download/${PG_JDBC}

VOLUME ${TEAMCITY_DATA_PATH}
EXPOSE 8111

RUN curl -vL --output ${TC_PATH} ${TC_URL} && \
    tar xvf ${TC_PATH} -C /opt/ && \
    rm -fv ${TC_PATH}

ENTRYPOINT ["/opt/TeamCity/bin/teamcity-server.sh"]
CMD  ["run"]
