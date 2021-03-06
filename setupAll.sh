#!/bin/sh

user_name=$1
user_pass=$2
strongSwanIP=$3
squidPort=$4
danteInterface=$5
dantePort=$6
githubpath=https://github.com/OreinSoft/IKEv2Setup/raw/master

if    [ -z ${user_name} ] || [ -z ${user_pass} ]      || [ -z ${strongSwanIP} ]\
   || [ -z ${squidPort} ] || [ -z ${danteInterface} ] || [ -z ${dantePort} ]; then
  echo "Usage: user_name user_pass strongSwanIP squidPort danteInterface dantePort"
  exit 1
fi

if [ "$(id -u)" != "0" ]; then
    echo "ERROR: Must be run as root"
    exit 1
fi

cd /home

read -p "Continue setup gateway (y/n)? " answer
if [ "$answer" != "y" ]; then
  exit
fi

set -x #echo on
apt update
set +x #echo off

bash <(wget -qO- ${githubpath}/setupSquid.sh) ${squidPort} ${user_name} ${user_pass} noaptupdate
set +x #echo off
bash <(wget -qO- ${githubpath}/setupDanteServer.sh) ${danteInterface} ${dantePort} ${user_name} ${user_pass} noaptupdate
set +x #echo off
bash <(wget -qO- ${githubpath}/setupStrongSwan.sh) ${strongSwanIP} ${user_name} ${user_pass} noaptupdate
set +x #echo off
bash <(wget -qO- ${githubpath}/setupNetwork.sh)

set +x #echo off
echo '+'
echo '+'
echo '+'
echo '+'
echo '+'
echo '+'
echo '+'
echo '+'
echo '+'
echo '+'

echo "check ssh connection, if all ok run commands:"
echo "netfilter-persistent save"
echo "netfilter-persistent reload"
echo "Setup complete"
