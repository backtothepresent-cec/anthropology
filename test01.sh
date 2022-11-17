#!/bin/bash
mv /etc/network/interfaces{,.backup}
echo -e "auto ens3\niface ens3 inet static\n    address 10.2.18.04\n    netmask 255.255.255.0\n    gateway \n10.2.18.1\n\nauto ens4\niface ens4 inet static\n    address 192.168.0.254\n    netmask 255.255.255.0" > /etc/network/interfaces
ifup -a
mv /etc/resolv.conf{,.old}
echo -e "nameserver 194.167.156.13" > /etc/resolv.conf
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
sysctl -w net.ipv6.conf.lo.disable_ipv6=1
export http_proxy=http://cache.univ-pau.fr:3128
export https_proxy=http://cache.univ-pau.fr:3128
apt-get install --reinstall libappstream4
apt-get update -y
apt-get install isc-dhcp-server -y
mv /etc/dhcp/dhcpd.conf{,.old}
echo -e "default-lease-time 600;\nmax-lease-time 7200;\nauthoritative;\n\nsubnet 192.168.0.0 netmask 255.255.255.0 {\n range 192.168.0.1 192.168.0.253;\n option routers 192.168.0.254;\n option domain-name-servers 194.167.158.13, 10.2.12.4;\n}" > /etc/dhcp/dhcpd.conf
mv /etc/default/isc-dhcp-server{,.old}
echo -e "INTERFACES="ens4" > /etc/default/isc-dhcp-server
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE
