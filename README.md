# Passos

# instalações



- Instalando em todos os nodes

```bash

sudo passwd root

locale-gen en_US.UTF-8
localedef -i en_US -f UTF-8 en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

cat > /etc/modules-load.d/k8s.conf <<EOF
br_netfilter
ip_vs
ip_vs_rr
ip_vs_sh
ip_vs_wrr
nf_conntrack_ipv4
EOF

apt update && apt upgrade -y

apt-get update && apt-get install -y  apt-transport-https ca-certificates 

curl software-properties-common gnupg2

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

sudo apt install -y docker.io

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload

systemctl restart docker

docker info | grep -i cgroup

sudo systemctl enable docker

apt-get update && apt-get install -y apt-transport-https gnupg2

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

apt-get update

apt-get install -y kubelet kubeadm kubectl

swapoff -a

``` 

- Comandos somente para o node master

```bash
kubeadm init --pod-network-cidr=192.168.121.0/24 --apiserver-advertise-address=192.168.121.95

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

modprobe br_netfilter ip_vs_rr ip_vs_wrr ip_vs_sh nf_conntrack_ipv4 ip_vs

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

kubectl get pods --all-namespaces -o wide

kubectl get nodes

```


- Comandos somente para work 1 e work 2

```bash

kubeadm join 192.168.121.95:6443 --token uba0e6.25j0y3cx9wcm2gde \
    --discovery-token-ca-cert-hash sha256:1ebcd4e8b967f74b0ed8ff76cabee889b4fc553729316e31bf4436f738f403b3   

```


# Vagrant Cloud

vagrant cloud auth login

vagrant package --BASE mrRobot01  --output mrrobot01.box --vagrantfile Vagrantfile
vagrant package --BASE mrRobot02  --output mrrobot02.box --vagrantfile Vagrantfile
vagrant package --BASE mrRobot03  --output mrrobot03.box --vagrantfile Vagrantfile

vagrant cloud publish danieldggomes/kubernetes-cluster 1.0.0 virtualbox mrrobot01.box -d "cluster kubernetes" --version-description "Master node kubernetes cluster" --release --short-description "Master node cluster"

vagrant cloud publish danieldggomes/mrrobot02 1.0.0 virtualbox mrrobot02.box -d "cluster kubernetes" --version-description "worker node kubernetes cluster" --release --short-description "worker node cluster"


vagrant cloud publish danieldggomes/mrrobot03 1.0.0 virtualbox mrrobot03.box -d "cluster kubernetes" --version-description "worker node kubernetes cluster" --release --short-description "worker node cluster"

