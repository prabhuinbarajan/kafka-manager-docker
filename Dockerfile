#FROM centos:7

FROM anapsix/alpine-java:jdk8
#MAINTAINER Clement Laforet <sheepkiller@cultdeadsheep.org>
MAINTAINER Prabhu Inbarajan <inbarajan.prabhu@gmail.com>
RUN apk add --no-cache git
#RUN yum update -y && \
#    yum install -y git wget unzip which && \
#    yum clean all

ENV JAVA_MAJOR=8 \
    JAVA_UPDATE=77 \
    JAVA_BUILD=03 

#RUN wget --no-cookies --no-check-certificate \
#    --header "Cookie: oraclelicense=accept-securebackup-cookie" \
#    "http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR}u${JAVA_UPDATE}-b${JAVA_BUILD}/jdk-${JAVA_MAJOR}u${JAVA_UPDATE}-linux-x64.rpm" -O /tmp/jdk-${JAVA_MAJOR}u${JAVA_UPDATE}-linux-x64.rpm && \
#     yum localinstall -y /tmp/jdk-${JAVA_MAJOR}u${JAVA_UPDATE}-linux-x64.rpm && \
#     rm -f /tmp/jdk-${JAVA_MAJOR}u${JAVA_UPDATE}-linux-x64.rpm

#ENV JAVA_HOME=/usr/java/jdk1.8.0_${JAVA_UPDATE} \
ENV JAVA_HOME=/opt/jdk1.${JAVA_MAJOR}.0_${JAVA_UPDATE} \
    ZK_HOSTS=localhost:2181 \
    KM_VERSION=1.3.0.7 \
    KM_REVISION=4b57fc9b65e6f9ac88fff4391994fd06bb782663

RUN mkdir -p /tmp && \
    cd /tmp && \
    git clone https://github.com/yahoo/kafka-manager && \
    cd /tmp/kafka-manager && \
    git checkout ${KM_REVISION} && \
    echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
    ./sbt clean dist && \
    unzip  -d / ./target/universal/kafka-manager-${KM_VERSION}.zip && \
    rm -fr /tmp/* /root/.sbt /root/.ivy2

WORKDIR /kafka-manager-${KM_VERSION}

EXPOSE 9000
ENTRYPOINT ["./bin/kafka-manager","-Dconfig.file=conf/application.conf"]
