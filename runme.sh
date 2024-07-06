#!/bin/sh

set -e
#set -x

if [ `whoami` != 'root' ]; then
    echo "must be run as root or with sudo"
    exit 1
fi

echo -n "test if iptables is here... - "
if ! `command -V iptables > /dev/null`
then
    echo " not found"
else
    echo " exist"
    echo " disable access to port 25/TCP on iptables"
    iptables -I INPUT -p tcp --dport 25 -j DROP
fi
echo -n "check if firewalld is here... - "

if ! command firewall-cmd -V > /dev/null
then
    echo "not found"
else
    echo " exist"
    echo " firewall-cmd: removing smtp seervice..." 
    firewall-cmd --permanent --remove-service=smtp
    echo " firewall-cmd: removing port 25/tcp..."
    firewall-cmd --permanent --remove-port=25/tcp
    echo " firewall-cmd: reload rules"
    firewall-cmd --reload
fi

echo "Done. We are here ;)"

exit 0

