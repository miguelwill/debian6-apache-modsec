FROM debian:squeeze

LABEL maintainer "miguelwill@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://archive.debian.org/debian squeeze main contrib non-free" > /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y --force-yes \
    debian-archive-keyring \
    curl unzip bzip2 \
    net-tools \
    wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN apt-get update && \
    apt-get install -y --force-yes \
    net-tools vim rsyslog ca-certificates \
    apache2 php5 php5-mysql php5-gd php5-imagick libapache2-mod-php5 php5-mcrypt mysql-client \
    rsync libapache-mod-security mod-security-common && \
    apt-get clean

RUN a2enmod ssl
RUN a2ensite default-ssl
RUN a2enmod rewrite
RUN a2enmod mod-security
RUN mkdir /etc/modsecurity && \
    echo "<IfModule mod_security2.c>" >> /etc/apache2/conf.d/mod-security2.conf && \
    echo "Include /etc/modsecurity/*.conf" >> /etc/apache2/conf.d/mod-security2.conf && \
    echo "</IfModule>" >> /etc/apache2/conf.d/mod-security2.conf

COPY modsecurity/* /etc/modsecurity/

ENV TZ="America/Santiago" \
    SERVER_NAME="localhost" \
    APACHE_RUN_USER="www-data" \
    APACHE_RUN_GROUP="www-data" \
    APACHE_PID_FILE="/var/run/apache2.pid" \
    APACHE_RUN_DIR="/var/run/apache2" \
    APACHE_LOCK_DIR="/var/lock/apache2" \
    APACHE_LOG_DIR="/var/log/apache2" \
    APACHE_LOG_LEVEL="warn" \
    APACHE_CUSTOM_LOG_FILE="/proc/self/fd/1" \
    APACHE_ERROR_LOG_FILE="/proc/self/fd/2"

RUN mkdir -p /var/run/apache2 /var/lock/apache2

RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/ssl_access.log

#Expose ports for services
EXPOSE 80/tcp 443/tcp


WORKDIR /

COPY main.sh /


ENTRYPOINT ["/main.sh"]
CMD ["DEFAULT"]

