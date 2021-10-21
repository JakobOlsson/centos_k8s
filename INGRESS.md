# Local Ingress

To setup your kubernetes bare metal cluster with a local Nginx Ingress as LoadBalancer using the external ip you have to perform following steps. *NOTE: We will use the already deployed hello-kube from k8s_setup*

1. Get your external ips of all the nodes
2. Apply the cloud-ingress-manifest from official kuberntes-ingres-nginx repository

   `kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml`
   This will setup nginx ingress as a LoadBalancer type.

3. Edit the new ingress controller and add the clusters external ips gather in step 1.

    `kubectl edit svc -n ingress-nginx ingress-nginx-controller`
    under `spec:` add a new entry `externalIPs:` with values of a list of one or more external ips

4. Verify that the service now have register external ips by running

    `kubectl get svc - ingress-nginx ingress-nginx-controller`

5. Create an ingress manifest `ingress.yaml`

```yaml
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
 name: minimal-ingress
 annotations:
   nginx.ingress.kubernetes.io/rewrite-target: /$1
   kubernetes.io/ingress.class: "nginx"
spec:
 rules:
 - http:
     paths:
     - path: /
       pathType: Prefix
       backend:
         service:
           name: hello-kube
           port:
             number: 8080

```

6. Apply it with `kubectl apply -f ingress.yaml`
7. Open firewall with `firewall-cmd --zone=public --port=80/tcp --permanent`
8. Get external ip of your host by `vagrant ssh main -c "ip -4 addr show eth0"`
9. TEST! `curl <externalip>` or test it in your browser
