# Pull base image.
FROM ubuntu

# Beautify output
ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

# Install Nginx.
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y nginx-extras curl && \
  rm /etc/nginx/sites-enabled/default && \
  rm /etc/nginx/nginx.conf

ADD ./etc/nginx/nginx.conf /etc/nginx/

# Install confd.
RUN \
  cd /usr/local/bin && \
  curl -L https://github.com/kelseyhightower/confd/releases/download/v0.6.3/confd-0.6.3-linux-amd64 -o confd && \
  chmod +x confd && \
  mkdir -p /etc/confd

ADD ./etc/confd/* /etc/confd/
ADD ./usr/local/bin/confd-watch /usr/local/bin/

RUN \
  chmod +x /usr/local/bin/confd-watch

EXPOSE 80
