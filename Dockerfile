FROM quay.io/openshift/origin-cli as OC
FROM gepardec/awscli

ENV PATH="$PATH:/usr/local/bin/acme.sh" \
    KUBECONFIG=/.kube/config \
    ACME_HOME=/.acme.sh

RUN curl --silent \
        'https://api.github.com/repos/acmesh-official/acme.sh/releases/latest' | \
    grep '"tag_name":' | \
    sed -E 's/.*"([^"]+)".*/\1/' | \
    xargs -I {} curl -sOL 'https://github.com/acmesh-official/acme.sh/archive/'{}'.tar.gz' && \
    mkdir -p /usr/local/bin/acme.sh && \
    tar -xvf *.tar.gz  -C /usr/local/bin/acme.sh  --strip-components=1 && \
    rm *.tar.gz && \
    mkdir -p ${ACME_HOME} && \
    chgrp -R 0 ${ACME_HOME} && \
    chmod -R g=u ${ACME_HOME}

COPY --from=OC /usr/bin/oc /usr/local/bin/oc
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
COPY helm/files/scripts/ /usr/local/bin/
COPY resources /opt/openshift/resources
COPY helm /opt/openshift/helm

RUN chgrp -R 0 /usr/bin /opt/openshift && \
    chmod -R g=u /usr/bin /opt/openshift

CMD [ "bash" ]