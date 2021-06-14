FROM ubuntu:18.04
MAINTAINER aaronfand <aaron.fand@gmail.com>

# fork from https://github.com/tobilg/docker-livy

# Overall ENV vars
ENV SPARK_VERSION 3.0.2
ENV SPARK_VERSION_STRING spark-$SPARK_VERSION-bin-hadoop2.7
ENV LIVY_BUILD_VERSION livy-server-0.3.0-SNAPSHOT
ENV DEBIAN_FRONTEND noninteractive

# Set paths
ENV LIVY_APP_PATH /apps/livy
ENV SPARK_HOME /usr/local/spark
#ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so

# packages
RUN apt-get update && apt-get install -yq --no-install-recommends --force-yes \
    wget \
    git \
    openjdk-8-jdk \
    maven \
    libjansi-java \
    libsvn1 \
    libcurl3 \
    libsasl2-modules && \
    rm -rf /var/lib/apt/lists/*
    

# R List Install
RUN apt update -qq
RUN apt install --no-install-recommends --yes software-properties-common dirmngr gpg-agent
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
RUN apt install --no-install-recommends --yes r-base


# Mesos install
RUN apt-get install -yq --no-install-recommends --force-yes \
	build-essential \
	python-dev \
	python-six \
	python-virtualenv \
	libcurl4-nss-dev \
	libsasl2-dev \
	libsasl2-modules \
	libapr1-dev \
	zlib1g-dev \
	iputils-ping
RUN wget https://downloads.apache.org/mesos/1.11.0/mesos-1.11.0.tar.gz  && \
	tar -zxf mesos-1.11.0.tar.gz && \
    mv mesos-1.11.0/ /usr/local/mesos  && \
    rm -rf mesos-1.11.0 && \
    rm  mesos-1.11.0.tar.gz

# Spark Install
RUN wget https://downloads.apache.org/spark/spark-3.0.2/spark-3.0.2-bin-hadoop2.7.tgz && \
    mkdir -p /usr/local/spark && \
    tar xvf spark-3.0.2-bin-hadoop2.7.tgz && \
    mv spark-3.0.2-bin-hadoop2.7/* /usr/local/spark/  && \
    rm -rf spark-3.0.2-bin-hadoop2.7 && \
    rm spark-3.0.2-bin-hadoop2.7.tgz


# Livy Install
RUN wget https://apache.osuosl.org/incubator/livy/0.7.1-incubating/apache-livy-0.7.1-incubating-bin.zip  && \
    mkdir -p /apps/livy && \
    mkdir -p /apps/livy/logs && \
    mkdir -p /apps/livy/upload && \
    unzip apache-livy-0.7.1-incubating-bin.zip  && \
    mv apache-livy-0.7.1-incubating-bin/* /apps/livy/  && \
    rm -rf apache-livy-0.7.1-incubating-bin && \
    rm apache-livy-0.7.1-incubating-bin.zip

	
# Add custom files, set permissions
ADD entrypoint.sh .
RUN chmod +x entrypoint.sh

ADD livy.conf /apps/livy/conf

# Expose port
EXPOSE 8998

ENTRYPOINT ["/entrypoint.sh"]
