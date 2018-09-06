#!/bin/bash

config=/etc/sysctl.conf

sed -i 's/.*net.ipv4.ip_forward\s*=.*//g' ${config}
echo 'net.ipv4.ip_forward=1' >> ${config}

sed -i 's/.*net.ipv4.conf.all.accept_redirects\s*=.*//g' ${config}
echo '# Do not accept ICMP redirects (prevent MITM attacks)' >> ${config}
echo 'net.ipv4.conf.all.accept_redirects=0' >> ${config}

sed -i 's/.*net.ipv4.conf.all.send_redirects\s*=.*//g' ${config}
echo '# Do not send ICMP redirects (we are not a router)' >> ${config}
echo 'net.ipv4.conf.all.send_redirects=0' >> ${config}

sed -i 's/.*net.ipv4.ip_no_pmtu_disc\s*=.*//g' ${config}
echo 'net.ipv4.ip_no_pmtu_disc=1' >> ${config}


sudo ufw disable
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
iptables -Z
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -p udp --dport  500 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 4500 -j ACCEPT
sudo iptables -A FORWARD --match policy --pol ipsec --dir in  --proto esp -s 10.1.0.0/16 -j ACCEPT
sudo iptables -A FORWARD --match policy --pol ipsec --dir out --proto esp -d 10.1.0.0/16 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -m policy --pol ipsec --dir out -j ACCEPT
sudo iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE
sudo iptables -t mangle -A FORWARD --match policy --pol ipsec --dir in -s 10.1.0.0/16 -o eth0 -p tcp -m tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1361:1536 -j TCPMSS --set-mss 1360
sudo iptables -A INPUT -j DROP
sudo iptables -A FORWARD -j DROP




#iptables -A INPUT -i lo -j ACCEPT
#iptables -A INPUT -p udp --dport  500 -j ACCEPT
#iptables -A INPUT -p udp --dport 4500 -j ACCEPT
#iptables -A FORWARD --match policy --pol ipsec --dir in  --proto esp -s 10.1.0.0/16 -j ACCEPT
#iptables -A FORWARD --match policy --pol ipsec --dir out --proto esp -d 10.1.0.0/16 -j ACCEPT
#iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -m policy --pol ipsec --dir out -j ACCEPT
#iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE
#iptables -t mangle -A FORWARD --match policy --pol ipsec --dir in -s 10.1.0.0/16 -o eth0 -p tcp -m tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1361:1536 -j TCPMSS --set-mss 1360
