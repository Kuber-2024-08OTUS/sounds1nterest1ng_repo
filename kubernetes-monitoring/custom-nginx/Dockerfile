FROM nginx:bookworm as build
ARG NGINX_VERSION=1.27.2

RUN apt-get -y update && apt-get install -y \
    wget \
    libpcre3-dev \
    zlib1g-dev \
    libssl-dev \
    gcc \
    make  \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
    && mkdir /tmp/nginx\
    && tar -zxvf nginx-${NGINX_VERSION}.tar.gz -C /tmp/nginx --strip-components=1 \
    && wget https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v1.3.0/nginx-prometheus-exporter_1.3.0_linux_amd64.tar.gz \
    && tar -zxvf nginx-prometheus-exporter_1.3.0_linux_amd64.tar.gz -C /tmp/\
    && mv nginx-prometheus-exporter /usr/local/bin/ \
    && rm nginx-prometheus-exporter_1.3.0_linux_amd64.tar.gz \
    && chmod +x /usr/local/bin/nginx-prometheus-exporter

WORKDIR /tmp/nginx

RUN ./configure \
      --user=nginx \
      --group=nginx \
      --pid-path=/run/nginx.pid \
      --lock-path=/run/lock/subsys/nginx \
      --with-http_stub_status_module \
    && make \
    && make install


EXPOSE 80 9113

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx-prometheus-exporter.conf /etc/nginx-prometheus-exporter.conf
COPY index.html /usr/share/nginx/html/index.html

RUN touch /var/run/nginx.pid \
    && chown -R nginx:nginx \
    /etc/nginx \
    /usr/share/nginx \
    /usr/local/nginx/ \
    /etc/nginx/nginx.conf \
    /var/log/nginx \
    /var/run/nginx.pid \
    /var/cache/nginx

USER nginx
STOPSIGNAL SIGTERM
ENTRYPOINT ["sh","-c","nginx & nginx-prometheus-exporter --nginx.scrape-uri=http://localhost:80/stub_status"]
