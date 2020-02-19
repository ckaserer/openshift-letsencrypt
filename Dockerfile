FROM centos:7

ENV PATH "$PATH:/usr/local/bin/acme.sh"

RUN mkdir -p /.acme.sh && \
    chgrp -R 0 /.acme.sh && \
    chmod -R g+rwx /.acme.sh

RUN yum update -y && \
    yum install -y openssl && \
    yum clean all

RUN curl --silent \
        'https://api.github.com/repos/acmesh-official/acme.sh/releases/latest' | \
    grep '"tag_name":' | \
    sed -E 's/.*"([^"]+)".*/\1/' | \
    xargs -I {} curl -sOL 'https://github.com/acmesh-official/acme.sh/archive/'{}'.tar.gz' && \
    mkdir -p /usr/local/bin/acme.sh && \
    tar -xvf *.tar.gz  -C /usr/local/bin/acme.sh  --strip-components=1 && \
    rm *.tar.gz

COPY scripts/* /usr/local/bin/
COPY resources /opt/openshift/resources