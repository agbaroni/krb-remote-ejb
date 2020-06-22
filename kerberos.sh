#!/bin/sh

set -e -x

yum -y install krb5-server krb5-workstation

mv /etc/krb5.conf{,.orig}

cp /vagrant/krb5.conf /etc/

mv /var/kerberos/krb5kdc/kdc.conf{,.orig}

cp /vagrant/kdc.conf /var/kerberos/krb5kdc/

kdb5_util -r EXAMPLE.COM create -s -P password

kadmin.local -r EXAMPLE.COM add_principal -pw password admin/admin@EXAMPLE.COM
kadmin.local -r EXAMPLE.COM add_principal -pw password HTTP/frontend@EXAMPLE.COM
kadmin.local -r EXAMPLE.COM add_principal -pw password remote/backend@EXAMPLE.COM
kadmin.local -r EXAMPLE.COM add_principal -pw password user1@EXAMPLE.COM

systemctl start krb5kdc

