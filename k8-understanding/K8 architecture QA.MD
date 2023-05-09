what are components of K8 cluster? or what is acrhitetcure of k8?
k8 cluster consists of 2 components.

1- control plane/master node - plays role of orchestarting  and maintain stability of K8 cluster.

2- Worker node - it actually runs the deployed containers

Comtrol plane consists of -
+kube-apiserver- exposes k8 API. Kubcetl command talks with this API through HTTP RESTY API.
However, the internal cluster components like the scheduler, controller, etc talk to the API server using gRPC. gRPC is one of the most popular modern RPC frameworks for inter-process communication.
All communications happens over TLS.
Kube-API take care of Authorization(RBAC) and authentication(CA certs, tokens)

+etcd - etcd stores all configurations, states, and metadata of Kubernetes objects (pods, secrets, daemonsets, deployments, configmaps, statefulsets, etc).
etcd it is the only Statefulset component in the control plane.

+kube-scheduler - responsible for scheduling pods on worker nodes.

+kube-controller-manager - is a component that manages all the Kubernetes controllers. Kubernetes resources/objects like pods, namespaces, jobs, replicaset are managed by respective controllers. Also, the kube scheduler is also a controller managed by Kube controller manager.

+cloud-controller-manager - When kubernetes is deployed in cloud environments, the cloud controller manager acts as a bridge between Cloud Platform APIs and the Kubernetes cluster.
Node0k controller: This controller updates node-related information by talking to the cloud provider API. For example, node labeling & annotation, getting hostname, CPU & memory availability, nodes health, etc.
Route controller: It is responsible for configuring networking routes on a cloud platform. So that pods in different nodes can talk to each other.
Service controller: It takes care of deploying load balancers for kubernetes services, assigning IP addresses, etc.

Worker node components-

+kubelet- Runs on every node of cluster.it does not run as a container instead runs as a daemon, managed by systemd.
Creating, modifying, and deleting containers for the pod.
Responsible for handling liveliness, readiness, and startup probes.
Responsible for Mounting volumes by reading pod configuration and creating respective directories on the host for the volume mount.
Collecting and reporting Node and pod status via calls to the API server.
While bootstrapping the control plane, kubelet starts the api-server, scheduler, and controller manager as static pods from podSpecs located at /etc/kubernetes/manifests

Following are some of the key things about kubelet.

Kubelet uses the CRI (container runtime interface) gRPC interface to talk to the container runtime.
It also exposes an HTTP endpoint to stream logs and provides exec sessions for clients.
Uses the CSI (container storage interface) gRPC to configure block volumes.
It uses the CNI plugin configured in the cluster to allocate the pod IP address and set up any necessary network routes and firewall rules for the pod.

+kube proxy -
To understand kube proxy, you need to have a basic knowledge of Kubernetes Service & endpoint objects.

Service in Kubernetes is a way to expose a set of pods internally or to external traffic. When you create the service object, it gets a virtual IP assigned to it. It is called clusterIP. It is only accessible within the Kubernetes cluster.

The Endpoint object contains all the IP addresses and ports of pod groups under a Service object. The endpoints controller is responsible for maintaining a list of pod IP addresses (endpoints). The service controller is responsible for configuring endpoints to a service.

You cannot ping the ClusterIP because it is only used for service discovery, unlike pod IPs which are pingable.

Now let’s understand Kube Proxy.

Kube-proxy is a daemon that runs on every node as a daemonset. It is a proxy component that implements the Kubernetes Services concept for pods. (single DNS for a set of pods with load balancing). It primarily proxies UDP, TCP, and SCTP and does not understand HTTP.

When you expose pods using a Service (ClusterIP), Kube-proxy creates network rules to send traffic to the backend pods (endpoints) grouped under the Service object. Meaning, all the load balancing, and service discovery are handled by the Kube proxy.

So how does Kube-proxy work?

Kube proxy talks to the API server to get the details about the Service (ClusterIP) and respective pod IPs & ports (endpoints). It also monitors for changes in service and endpoints.

Kube-proxy then uses any one of the following modes to create/update rules for routing traffic to pods behind a Service

IPTables: It is the default mode. In IPTables mode, the traffic is handled by IPtable rules. In this mode, kube-proxy chooses the backend pod random for load balancing. Once the connection is established, the requests go to the same pod until the connection is terminated.
IPVS: For clusters with services exceeding 1000, IPVS offers performance improvement. It supports the following load-balancing algorithms for the backend.
rr: round-robin : It is the default mode.
lc: least connection (smallest number of open connections)
dh: destination hashing
sh: source hashing
sed: shortest expected delay
nq: never queue
Userspace (legacy & not recommended)
Kernelspace: This mode is only for windows systems.


+Container Runtime-
Container runtime runs on all the nodes in the Kubernetes cluster. It is responsible for pulling images from container registries, running containers, allocating and isolating resources for containers, and managing the entire lifecycle of a container on a host.
To understand this better, let’s take a look at two key concepts:

Container Runtime Interface (CRI): It is a set of APIs that allows Kubernetes to interact with different container runtimes. It allows different container runtimes to be used interchangeably with Kubernetes. The CRI defines the API for creating, starting, stopping, and deleting containers, as well as for managing images and container networks.
Open Container Initiative (OCI): It is a set of standards for container formats and runtimes.
Kubernetes supports multiple container runtimes (CRI-O, Docker Engine, containerd, etc) that are compliant with Container Runtime Interface (CRI). This means, all these container runtimes implement the CRI interface and expose gRPC CRI APIs (runtime and image service endpoints).

CNI Plugin
