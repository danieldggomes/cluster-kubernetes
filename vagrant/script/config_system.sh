#/bin/bash

cat "br_netfilter 
ip_vs 
ip_vs_rr 
ip_vs_sh 
ip_vs_wrr 
nf_conntrack_ipv4 
" >  /etc/modules-load.d/k8s.conf


sudo apt update && apt upgrade -y

sudo apt-get update && apt-get install -y  apt-transport-https 
ca-certificates curl software-properties-common gnupg2
