#!/bin/sh

set -e -x

yum -y install ntp krb5-server krb5-workstation

systemctl enable --now ntpd

timedatectl set-timezone Europe/Rome

mv /etc/krb5.conf{,.orig}

cp /vagrant/krb5.conf /etc/

mv /var/kerberos/krb5kdc/kdc.conf{,.orig}

cp /vagrant/kdc.conf /var/kerberos/krb5kdc/

kdb5_util -r EXAMPLE.COM create -s -P password

kadmin.local -r EXAMPLE.COM add_principal -kvno 0 +allow_forwardable +allow_renewable +allow_proxiable +ok_as_delegate +ok_to_auth_as_delegate -pw password admin/admin@EXAMPLE.COM
kadmin.local -r EXAMPLE.COM add_principal -kvno 1 +allow_forwardable +allow_renewable +allow_proxiable +ok_as_delegate +ok_to_auth_as_delegate -pw password HTTP/frontend@EXAMPLE.COM
kadmin.local -r EXAMPLE.COM add_principal -kvno 2 +allow_forwardable +allow_renewable +allow_proxiable +ok_as_delegate +ok_to_auth_as_delegate -pw password remote/backend@EXAMPLE.COM
kadmin.local -r EXAMPLE.COM add_principal -kvno 3 +allow_forwardable +allow_renewable +allow_proxiable +ok_as_delegate +ok_to_auth_as_delegate -pw password postgres/database@EXAMPLE.COM
kadmin.local -r EXAMPLE.COM add_principal -kvno 4 +allow_forwardable +allow_renewable +allow_proxiable +ok_as_delegate +ok_to_auth_as_delegate -pw password user1@EXAMPLE.COM
kadmin.local -r EXAMPLE.COM add_principal -kvno 5 +allow_forwardable +allow_renewable +allow_proxiable +ok_as_delegate +ok_to_auth_as_delegate -pw password postgres@EXAMPLE.COM
kadmin.local -r EXAMPLE.COM add_principal -kvno 6 +allow_forwardable +allow_renewable +allow_proxiable +ok_as_delegate +ok_to_auth_as_delegate -pw password wildfly@EXAMPLE.COM

systemctl start krb5kdc
