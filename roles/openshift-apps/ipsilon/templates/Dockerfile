FROM fedora:32
RUN curl -o /etc/yum.repos.d/infra-tags.repo https://infrastructure.fedoraproject.org/infra/ansible/files/common/fedora-infra-tags.repo
{% if env == "staging" %}
RUN curl -o /etc/yum.repos.d/infra-tags-stg.repo https://infrastructure.fedoraproject.org/infra/ansible/files/common/fedora-infra-tags-stg.repo
RUN curl -o /etc/yum.repos.d/fedora-updates-testing.repo https://src.fedoraproject.org/rpms/fedora-repos/raw/master/f/fedora-updates-testing.repo
{% endif %}
RUN dnf install -y \
{% if env == "staging" %}
    --enablerepo=updates-testing \
{% endif %}
    ipsilon \
    ipsilon-openid \
    ipsilon-saml2 \
    ipsilon-persona \
    ipsilon-authgssapi \
    ipsilon-authldap \
    ipsilon-openidc \
    ipsilon-theme-Fedora \
    mod_auth_openidc \
    python-psycopg2 \
    python-setuptools \
    python-jinja2 \
    httpd \
    python3-mod_wsgi \
    #python3-fasjson-client \
    git

# Fedora specific stuff
RUN cd /tmp && \
    git clone --branch {{ env }} https://pagure.io/fedora-infra/ipsilon-fedora.git && \
    cd ipsilon-fedora && \
    ./install.sh

# Cleanup
RUN dnf remove -y git && rm -rf /tmp/ipsilon-fedora

# Set up krb5
RUN rm -f /etc/krb5.conf && ln -sf /etc/ipsilon/krb5.conf /etc/krb5.conf
# Set up LDAP
RUN rm -f /etc/openldap/ldap.conf && ln -sf /etc/ipa/ldap.conf /etc/openldap/ldap.conf

RUN ln -s /etc/ipsilon/ipsilon.conf /var/lib/ipsilon/ipsilon.conf

# Install some more deps that are not yet in Fedora nor in the infra repo. This is very temporary. (added in 2020)
RUN dnf install -y \
    https://abompard.fedorapeople.org/aaa/python3-jsonref-0.2-1.fc32.noarch.rpm \
    https://abompard.fedorapeople.org/aaa/python3-bravado-core-5.17.0-1.fc32.noarch.rpm \
    https://abompard.fedorapeople.org/aaa/python3-bravado-10.6.2-1.fc32.noarch.rpm \
    https://abompard.fedorapeople.org/aaa/python3-fasjson-client-0.0.3-1.fc32.noarch.rpm

EXPOSE 8080
ENTRYPOINT bash /etc/ipsilon/start.sh
