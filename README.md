A Kubernetes cluster with role-based access control (RBAC) enabled.
Ensure your cluster has enough resources available, and if not scale your cluster by adding more Kubernetes Nodes. You’ll deploy a 3-Pod Elasticsearch cluster with 3 master Pods, and a 9-Pod Elasticsearch cluster with 3 master Pods, 3 data Pods, and 3 client Pods. I’d suggest you have 9 Kubernetes Nodes with at least 4GB of RAM and 50GB of storage.

ELASTICSEARCH CLUSTER TOPOLOGY
When working with the Elastic Stack, the part of it that needs special attention is Elasticsearch itself — that layer in the middle of the stack that stores the data and does all the magic. A typical Elasticsearch cluster will look something like this:


TYPICAL ELASTICSEARCH CLUSTER 

1. There are at least 2 Data nodes which will persist all data; they recieve queries and indexing requests, and do all of the heavy lifting.
2. There are exactly 3 Master-eligible nodes, which will manage the cluster metadata. Unlike what many think, Master nodes never deal with data operations, only cluster metadata operations. They never even come close to the data.
3.Optionally, there are 2 or more Client nodes, also known as Coordinating nodes. These are the nodes that are exposed to consumers of the cluster data and serve as HTTP proxies. If they are not deployed, Data nodes will serve as coordinating nodes as well which is something we usually like to avoid on decent size clusters.
The cluster access point is then any of the coordinating nodes, or a load-balancer that can be put in front of them.


ELASTICSEARCH CLUSTER TOPOLOGY running on Kubernetes

1. The same layout of nodes; separate client nodes are still optional.
2. Data nodes are deployed as StatefulSets with PV and PVCs. Therefore, they preserve their identity and storage also through restarts and crashes, which is the desired behavior.
3. Master nodes can be deployed as either Deployments or StatefulSets. Deploying as StatefulSets will just make cluster recoveries faster.
4. A headless service for each StatefulSet is created and used for inter-cluster discovery.
5. Client nodes are completely stateless and can be deployed as a simple Kubernetes Deployment.
6. A LoadBalancer Kubernetes Service is created to forward HTTP requests to the coordinating nodes.
7. Your applications, as well as tools like Kibana, Logstash, Beats, etc., should all be configured to talk to the LoadBalancer service. This is also where you should set up HTTPS security via Kubernetes Ingress or the like.

FILE TO RUN THE SCRIPT

please run the script file run.sh