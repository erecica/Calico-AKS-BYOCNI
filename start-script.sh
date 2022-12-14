az group create --name Calico-AKS-Resourcegroup --debug && \
echo "Resourcegroup created. Next step might take 6-9 minutes" && \
sleep 5 && \ 
az aks create --resource-group Calico-AKS-Resourcegroup --name Calico-AKS-Workshop --pod-cidr 192.168.0.0/16 --network-plugin none --generate-ssh-keys --debug && \
echo "AKS without network-plugin created. One moment please..." && \
sleep 5 && \
az aks get-credentials --resource-group Calico-AKS-Resourcegroup --name Calico-AKS-Workshop --debug && \
echo "Get AKS credentials." && \
sleep 5 && \
kubectl create -f ./tigera-operator.yaml && \
echo "Create operator. One moment please..." && \
sleep 5 && \
kubectl create -f ./tigera-operator-installation.yaml && \
echo "Install operator. One moment please..." && \
sleep 5 && \
kubectl apply -f ./yaobank-org.yaml && \
echo "Deploy YOABank app. One moment please..." && \
sleep 45 && \
kubectl apply -f ./yoabank-loadbalancer.yaml && \
echo "Deploy Loadbalancer. Waiting for External IP..." && \
sleep 5 && \
kubectl get svc -n yaobank-customer yaobank-customer -w --output jsonpath='{"Visit YAO Bank with this url: http://"}{.status.loadBalancer.ingress[0].ip}{"\n"}{"You can exit with CTRL+C"}{"\n"}'