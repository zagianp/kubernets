Kubernetes installation methods

1- Single-node installation:
minikube is a single-node Kubernetes distribution that releases officially by the Kubernetes community. it’s suitable for practices, tests and development purposes.

2- Manual cluster installation:
kubeadm is a tool that is used to deploy a cluster by human hands. It is used to bootstrap Kubernetes components, not provisioning machines. Before bootstrapping the cluster, some actions should be done manually.

3- Automatic cluster installation:

kubespray is a collection of Ansible playbooks that are used to deploy production-grades clusters on both bare-metal and the cloud. Alongside the installation, day two operations can be performed with kubespray. 

kops will not only manage the cluster lifecycle, but it also will provision necessary cloud infrastructure.

RKE is a Rancher distributed Kubernetes that can deploy production-grade Kubernetes clusters on top of Docker containers.

4- Managed clusters:
EKS stands for Elastic Kubernetes Service is the amazon solution to provide managed Kubernetes cluster. EKS can easily be integrated with other Amazon services. A command-line tool, eksctl, is used to running a production Kubernetes cluster in a couple of minutes.


AKS is managed by Microsoft Azure and can be deployed easily. This managed Kubernetes solution is good for Azure users because it can integrate with other Azure tools that are available on the Azure ecosystem.

More information on https://azure.microsoft.com/en-us/services/kubernetes-service