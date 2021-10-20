#!/usr/bin/env bash
# Run post provisioning of a CentOS machine
set -e # exit on first error
echo "* Create .kube-directory for current user"
mkdir -p $HOME/.kube

echo "* Initilize Cluster"
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

echo "* Copy kubeconfig for current user to access"
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Lets make sure we have crio and kubernetes in right state
sudo systemctl restart crio
sudo systemctl restart kubelet

echo "* Deploying POD network: flannel"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# By default, your cluster will not schedule Pods on the control-plane node
# for security reasons. If you want to be able to schedule Pods on the
# control-plane node, for example for a single-machine Kubernetes cluster for development, run:
echo "* Allow running pods on master"
kubectl taint nodes --all node-role.kubernetes.io/master-

# List current nodes
echo "* Listing nodes"
kubectl get nodes -A -o wide

# List current pods
echo "* Listing pods"
kubectl get pods -A -o wide

# Lets launch something simple
echo "* Creating a simple app and service with a simple echoserver and expose it as NodePort"
kubectl create deployment hello-kube --image=k8s.gcr.io/echoserver:1.4
kubectl expose deployment hello-kube --type=NodePort --port=8080

echo "* NOTE: you might have to wait a couple of seconds if the cluster is just created"
echo "* sleeping 10sec"
sleep 10

echo "* Get the nodeport for the new services"
kubectl describe service hello-kube | grep -i nodeport

echo "* You can test it out with: curl locahlost:<nodeport>"
echo "* example: curl locahlost:31699"
