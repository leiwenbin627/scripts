#!/bin/bash

yum install lrzsz wget vim -y


cd /etc/yum.repos.d/ 
wget https://mirrors.aliyun.com/dockerce/linux/centos/docker-ce.repo

cat << EOF > kubernetes.repo
[kubernetes]
name=kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
gpgcheck=0
enabled=1
EOF

cat > /etc/yum.repos.d/epel.repo << EOF
[epel]
name=Extra Packages for Enterprise Linux 7 - $basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/epel/7/$basearch
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
failovermethod=priority
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
[epel-debuginfo]
name=Extra Packages for Enterprise Linux 7 - $basearch - Debug
baseurl=https://mirrors.tuna.tsinghua.edu.cn/epel/7/$basearch/debug
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-debug-7&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=0
[epel-source]
name=Extra Packages for Enterprise Linux 7 - $basearch - Source
baseurl=https://mirrors.tuna.tsinghua.edu.cn/epel/7/SRPMS
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-source-7&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=0
EOF

yum -y install docker-ce

sed -i '18a Environment\=\"NO_PROXY\=127.0.0.0\/8\"' docker.service

mkdir -p /etc/docker

cat > /etc/docker/daemon.json << EOF
{

  "registry-mirrors": ["https://lvb4p7mn.mirror.aliyuncs.com"]

}
EOF

systemctl daemon-reload

systemctl start docker

systemctl enable docker

yum -y install  kubeadm-1.15.0-0.x86_64  kubectl-1.15.0-0.x86_64 kubelet-1.15.0-0.x86_64 kubernetes-cni-0.7.5-0.x86_64

echo 'KUBELET_EXTRA_ARGS="--fail-swap-on=false"' > /etc/sysconfig/kubelet

systemctl enable kubelet

docker load  -i k8s-1.15.0.tar.gz

docker load  -i flannel-v0.11.0.tar.gz

yum install bash-completion* -y

source <(kubectl completion bash)

echo "source <(kubectl completion bash)" >> ~/.bashrc



kubeadm join 192.168.81.10:6443 --token 2vtevp.nwyjj0xeznii3eux --discovery-token-ca-cert-hash sha256:4745b2d602d144de1b2ffc9dfe9595964a6b67003bbda3b3a8d8935ab1009f02 --ignore-preflight-errors=all


systemctl restart docker





