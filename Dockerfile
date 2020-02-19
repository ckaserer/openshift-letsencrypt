FROM quay.io/openshift/origin-cli as OC
FROM gepardec/awscli

ENV PATH "$PATH:/usr/local/bin/acme.sh"

RUN curl --silent \
        'https://api.github.com/repos/acmesh-official/acme.sh/releases/latest' | \
    grep '"tag_name":' | \
    sed -E 's/.*"([^"]+)".*/\1/' | \
    xargs -I {} curl -sOL 'https://github.com/acmesh-official/acme.sh/archive/'{}'.tar.gz' && \
    mkdir -p /usr/local/bin/acme.sh && \
    tar -xvf *.tar.gz  -C /usr/local/bin/acme.sh  --strip-components=1 && \
    rm *.tar.gz && \
    mkdir -p /.acme.sh && \
    chgrp -R 0 /.acme.sh && \
    chmod -R g=u /.acme.sh

COPY --from=OC /usr/bin/oc /usr/local/bin/oc
COPY scripts/* /usr/local/bin/
COPY resources /opt/openshift/resources

RUN chgrp -R 0 /usr/bin /opt/openshift && \
    chmod -R g=u /usr/bin /opt/openshift

CMD [ "bash" ]