#!/bin/bash

/usr/bin/yum install lrzsz wget vim -y


cd /etc/yum.repos.d/ 
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

cat << EOF > kubernetes.repo
[kubernetes]
name=kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
gpgcheck=0
enabled=1
EOF


/usr/bin/yum -y install docker-ce

sed -i '18a Environment\=\"NO_PROXY\=127.0.0.0\/8\"' /usr/lib/systemd/system/docker.service

mkdir -p /etc/docker

cat > /etc/docker/daemon.json << EOF
{

"registry-mirrors": ["https://lvb4p7mn.mirror.aliyuncs.com"]

}
EOF

systemctl daemon-reload

systemctl start docker

systemctl enable docker

/usr/bin/yum -y install kubeadm-1.15.0-0.x86_64 kubectl-1.15.0-0.x86_64 kubelet-1.15.0-0.x86_64 kubernetes-cni-0.7.5-0.x86_64

echo 'KUBELET_EXTRA_ARGS="--fail-swap-on=false"' > /etc/sysconfig/kubelet

systemctl enable kubelet

/usr/bin/docker load -i /root/k8s-1.15.0.tar.gz

/usr/bin/docker load -i /root/flannel-v0.11.0.tar.gz

/usr/bin/yum install bash-completion* -y

source <(kubectl completion bash)

echo "source <(kubectl completion bash)" >> ~/.bashrc

/usr/bin/kubeadm join 192.168.81.10:6443 --token wdqyml.b4cjiefdl4kqylvs --discovery-token-ca-cert-hash sha256:eeb025cddf79b221ef27cccd235b73ba9b1e65152b533eb961699d48cfac7f49 --ignore-preflight-errors=all


systemctl restart docker
