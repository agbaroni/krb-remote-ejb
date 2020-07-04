#!/bin/sh

set -e -x

yum -y install ntp net-tools krb5-workstation

systemctl enable --now ntpd

timedatectl set-timezone Europe/Rome

yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

yum -y install postgresql12-server libpq5-devel

/usr/pgsql-12/bin/postgresql-12-setup initdb

mv /etc/krb5.conf{,.orig}

cp /vagrant/krb5.conf /etc/

printf "add_entry -password -p postgres/database@EXAMPLE.COM -k 3 -e aes256-cts-hmac-sha1-96\npassword\nwrite_kt /var/lib/pgsql/12/data/example.keytab" | ktutil

chown postgres:postgres /var/lib/pgsql/12/data/example.keytab

sed -i "s@#listen_addresses = 'localhost'@listen_addresses = '*'@g" /var/lib/pgsql/12/data/postgresql.conf

sed -i "s@#krb_server_keyfile = ''@krb_server_keyfile = '/var/lib/pgsql/12/data/example.keytab'@g" /var/lib/pgsql/12/data/postgresql.conf

sed -i "s@#log_min_messages = warning@log_min_messages = debug5@g" /var/lib/pgsql/12/data/postgresql.conf

mv /var/lib/pgsql/12/data/pg_hba.conf{,.orig}

cp /vagrant/pg_hba.conf /var/lib/pgsql/12/data/

chown postgres:postgres /var/lib/pgsql/12/data/pg_hba.conf

chmod 0600 /var/lib/pgsql/12/data/pg_hba.conf

systemctl enable postgresql-12

systemctl start postgresql-12

su -l -c 'createuser -d -l -r -s postgres/database@EXAMPLE.COM' postgres

su -l -c 'createuser -D -l -R -S user1@EXAMPLE.COM' postgres

su -l -c 'createdb -O user1@EXAMPLE.COM test1' postgres

su -l -c "psql -c 'CREATE TABLE WORDS (ID INTEGER PRIMARY KEY, NAME VARCHAR(64) NOT NULL)' test1 user1@EXAMPLE.COM" postgres

su -l -c "psql -c \"INSERT INTO WORDS VALUES (0, 'Alessio')\" test1 user1@EXAMPLE.COM" postgres
