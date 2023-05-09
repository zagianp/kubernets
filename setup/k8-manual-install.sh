##Update the OS
yum update -y
## Install yum-utils, bash completion, git, and more
yum install yum-utils nfs-utils bash-completion git -y

##Disable firewall starting from Kubernetes v1.19 onwards
#systemctl disable firewalld --now
sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --permanent --add-port=2379-2380/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --add-port=10251/tcp
sudo firewall-cmd --permanent --add-port=10252/tcp
sudo firewall-cmd --permanent --add-port=10255/tcp
sudo firewall-cmd --reload

## letting ipTables see bridged networks
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

##
## iptables config as specified by CRI-O documentation
# Create the .conf file to load the modules at bootup
cat <<EOF | sudo tee /etc/modules-load.d/crio.conf
overlay
br_netfilter
EOF


sudo modprobe overlay
sudo modprobe br_netfilter


# Set up required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system


###
## configuring Kubernetes repositories
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

## Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

### Disable swap
swapoff -a

##make a backup of fstab
cp -f /etc/fstab /etc/fstab.bak

##Renove swap from fstab
sed -i '/swap/d' /etc/fstab


##Refresh repo list
yum repolist -y


## Install CRI-O binaries
##########################

#Operating system	$OS
#Centos 8	CentOS_8
#Centos 8 Stream	CentOS_8_Stream
#Centos 7	CentOS_7


#set OS version
OS=CentOS_7

#set CRI-O
VERSION=1.27

# Install CRI-O
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/devel:kubic:libcontainers:stable.repo
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo
sudo yum install cri-o cri-o-runc cri-tools -y

#Reload the systemd configurations and enable cri-o.   
sudo systemctl daemon-reload
sudo systemctl enable crio --now

# install certificated 
#sudo apt-get update
#sudo apt-get install -y apt-transport-https ca-certificates curl
---------------------------------------------
#Kubernetes requires PKI certificates for authentication over TLS. 
#If you install Kubernetes with kubeadm, 
#the certificates that your cluster requires are automatically generated. 
#You can also generate your own certificates
---------------------------------------------
#Download the Google Cloud public signing key:
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg


#Add the GPG key and apt repository.
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

##Install Kubernetes, specify Version as CRI-O
sudo yum update
sudo yum install -y kubelet kubeadm kubectl
sudo yum lock kubelet kubeadm kubectl
##make sure that the installed versions of Kubernetes and CRI-O are matching.
echo "check kuber version matching with cri";rpm -qa | grep -i kube; echo "cri version";rpm -qa | grep -i cri-o

#can put kubelet kubeadm kubectl on hold . so auto upgrade do not happen
