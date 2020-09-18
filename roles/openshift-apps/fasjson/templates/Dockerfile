FROM fedora:32
LABEL \
  name="fasjson" \
  vendor="Fedora Infrastructure" \
  license="GPLv3+"
ENV HOME=/tmp
RUN dnf install -y \
        openldap-clients \
        vim \
        git \
        python3-pip \
        python3-setuptools \
        ipa-client \
        gcc \
        python-devel \
        krb5-devel \
        openldap-devel \
        httpd \
        mod_auth_gssapi \
        mod_session \
        policycoreutils-python-utils \
        python3-mod_wsgi \
        python3-dns \
        python3-flask \
        python3-gssapi \
        python3-ldap \
        python3-pip \
        python3-wheel && \
    dnf autoremove -y && \
    dnf clean all -y
RUN git clone https://github.com/fedora-infra/fasjson.git && \
    pushd fasjson && \
    git checkout {{ (env == 'production')|ternary('stable', 'staging') }} && \
    pip-3 install . && \
    mkdir -p /usr/share/fasjson && \
    cp ansible/roles/fasjson/files/fasjson.wsgi /usr/share/fasjson && \
    popd && \
    rm -rf fasjson
RUN rm -f /etc/krb5.conf && ln -sf /etc/krb5/krb5.conf /etc/krb5.conf && \
    rm -f /etc/openldap/ldap.conf && ln -sf /etc/ipa/ldap.conf /etc/openldap/ldap.conf
EXPOSE 8080
ENTRYPOINT bash /etc/fasjson/start.sh
