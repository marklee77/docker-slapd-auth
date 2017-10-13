FROM marklee77/supervisor:jessie
MAINTAINER Mark Stillwell <mark@stillwell.me>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        ca-certificates \
        ldap-utils \
        pwgen \
        slapd && \
    rm -rf \
        /etc/ldap/ldap.conf \
        /etc/ldap/slapd.d/* \
        /var/cache/apt/* \
        /var/lib/apt/lists/* \
        /var/lib/ldap/*

COPY root/etc/my_init.d/10-slapd-setup /etc/my_init.d/
COPY root/usr/local/sbin/slapd-run /usr/local/sbin/
RUN chmod 755 /etc/my_init.d/10-slapd-setup /usr/local/sbin/slapd-run
RUN mkdir -m 0755 -p /etc/ldap/dbinit.d

COPY root/etc/supervisor/conf.d/slapd.conf /etc/supervisor/conf.d/
RUN chmod 644 /etc/supervisor/conf.d/slapd.conf

VOLUME [ "/etc/ldap/slapd.d", "/var/lib/ldap" ]

EXPOSE 389 636
