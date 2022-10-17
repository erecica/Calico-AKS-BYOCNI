az group create --name Calico-AKS-Resourcegroup --location  westeurope --debug && \
echo "Resourcegroup created. Sleep for 5 sec" && \
sleep 5 && \ 
az aks create --resource-group Calico-AKS-Resourcegroup --name Calico-AKS-Workshop --location westeurope --pod-cidr 192.168.0.0/16 --network-plugin none --generate-ssh-keys --debug && \
echo "AKS without network-plugin created. Sleep for 5 sec" && \
sleep 5 && \
az aks get-credentials --resource-group Calico-AKS-Resourcegroup --name Calico-AKS-Workshop --debug && \
echo "Get AKS credentials. Sleep for 5 sec" && \
sleep 5 && \
kubectl create -f ./tigera-operator.yaml && \
echo "Create operator. Sleep for 5 sec" && \
sleep 5 && \
kubectl create -f ./tigera-operator-installation.yaml && \
echo "Install operator. Sleep for 5 sec" && \
sleep 5 && \
kubectl apply -f ./yaobank-org.yaml && \
echo "Deploy YOABank app. Sleep for 5 sec" && \
sleep 5 && \
kubectl apply -f ./yoabank-loadbalancer.yaml && \
echo "Deploy Loadbalancer. Waiting for External IP..." && \
sleep 30 && \
kubectl get svc -n yaobank-customer yaobank-customer -w --output jsonpath='{.status.loadBalancer.ingress[0].ip}'