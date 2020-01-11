#!/bin/bash


sed '11s/AllowOverride\ None/AllowOverride\ All/' /etc/apache2/sites-enabled/000-default > /tmp/la
cat /tmp/la > /etc/apache2/sites-enabled/000-default
sed '12s/AllowOverride\ None/AllowOverride\ All/' /etc/apache2/sites-enabled/default-ssl > /tmp/le
cat /tmp/le > /etc/apache2/sites-enabled/default-ssl
#echo "CustomLog /proc/self/fd/1" > /etc/apache2/conf.d/other-vhosts-access-log
rm -f /etc/apache2/conf.d/other-vhosts-access-log
sed -i '/output_buffering = 4096/c output_buffering = Off' /etc/php5/apache2/php.ini

/etc/init.d/memcached start

rm -f /var/run/apache2.pid && exec apache2 -DFOREGROUND
