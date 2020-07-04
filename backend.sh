#!/bin/sh

set -e -x

yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

yum -y install ntp net-tools java-1.8.0-openjdk-devel krb5-workstation postgresql12

systemctl enable --now ntpd

timedatectl set-timezone Europe/Rome

mv /etc/krb5.conf{,.orig}

cp /vagrant/krb5.conf /etc/

cd /opt

curl -JLOk https://jdbc.postgresql.org/download/postgresql-42.2.14.jar

curl -JLOk https://download.jboss.org/wildfly/18.0.1.Final/wildfly-18.0.1.Final.tar.gz

tar -xzf wildfly-18.0.1.Final.tar.gz

./wildfly-18.0.1.Final/bin/add-user.sh -a -u admin -p password
./wildfly-18.0.1.Final/bin/add-user.sh -a -u user1@EXAMPLE.COM -p password -g default

./wildfly-18.0.1.Final/bin/jboss-cli.sh --file=/vagrant/backend.cli

printf "add_entry -password -p HTTP/frontend@EXAMPLE.COM -k 1 -e aes256-cts-hmac-sha1-96\npassword\nadd_entry -password -p remote/backend@EXAMPLE.COM -k 2 -e aes256-cts-hmac-sha1-96\npassword\nadd_entry -password -p postgres/database@EXAMPLE.COM -k 3 -e aes256-cts-hmac-sha1-96\npassword\nwrite_kt wildfly-18.0.1.Final/standalone/configuration/example.keytab" | ktutil

cp wildfly-18.0.1.Final/docs/contrib/scripts/init.d/wildfly-init-redhat.sh /etc/init.d/wildfly

cp /vagrant/wildfly.conf /etc/default/wildfly

groupadd -r wildfly

useradd -r -g wildfly wildfly

chown -R wildfly:wildfly /opt/wildfly-18.0.1.Final

chkconfig --add wildfly

chkconfig --level 2345 wildfly on

systemctl start wildfly
