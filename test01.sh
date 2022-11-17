#!/bin/bash
apt-get update; apt-get install --reinstall libappstream4
apt-get update
apt-get install isc-dhcp-server -y
mv /etc/dhcp/dhcpd.conf{,.old}
echo -e "default-lease-time 600;\nmax-lease-time 7200;\nauthoritative;\n\nsubnet 192.168.0.0 netmask 255.255.255.0 {\n range 192.168.0.1 192.168.0.253;\n option routers 192.168.0.254;\n option domain-name-servers 194.167.158.13, 10.2.12.4;\n}" > /etc/dhcp/dhcpd.conf
mv /etc/default/isc-dhcp-server{,.old}
echo -e "INTERFACESv4="ens4" > /etc/default/isc-dhcp-server
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE
