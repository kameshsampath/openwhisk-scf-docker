FROM registry.centos.org/centos:latest

ENV MAVEN_VERSION=3.3 \
    GRADLE_VERSION=4.2.1 \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable" \
    PATH=$PATH:/opt/gradle/bin \
    JAVA_APP_DIR=/deployments \
    JAVA_APP_JAR=ow-scf-runner.jar 

# Install Maven
RUN INSTALL_PKGS="rsync tar unzip which zip wget curl java-1.8.0-openjdk-headless java-1.8.0-openjdk-headless.i686 rh-maven33*" && \
    yum install -y centos-release-scl-rh && \
    yum install -y --enablerepo=centosplus --setopt=tsflags=nodocs $INSTALL_PKGS && \
    curl -LOk https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle-${GRADLE_VERSION}-bin.zip -d /opt && \
    rm -f gradle-${GRADLE_VERSION}-bin.zip && \
    ln -s /opt/gradle-${GRADLE_VERSION} /opt/gradle && \
    rpm -V ${INSTALL_PKGS//\*/} && \
    yum clean all -y && \
    mkdir -p /home/user/.m2 && \
    mkdir -p /home/user/.gradle && \
    mkdir -p $JAVA_APP_DIR 

RUN useradd -u 1001 user && \
    mkdir -p $JAVA_APP_DIR 

ADD contrib/bin/scl_enable /usr/local/bin/scl_enable
ADD ./contrib/settings.xml /home/user/.m2/
ADD ./contrib/init.gradle /home/user/.gradle/
ADD ./contrib/configure.gradle /tmp/build.gradle

RUN  cd /tmp && \
    gradle copyAdapter && \
    mv /deployments/spring-cloud-function-adapter-openwhisk-1.0.0.BUILD-SNAPSHOT.jar /deployments/${JAVA_APP_JAR} && \
    chown -R 1001:0 /home/user && \
    chmod -R g+rw /home/user && \
    chown -R 1001:0 $JAVA_APP_DIR && \
    chmod -R g+rwx $JAVA_APP_DIR

WORKDIR /deployments

USER user

CMD [ "/deployments/run-java.sh" ]
