az group create --name Calico-AKS-Resourcegroup --location  westeurope && \
echo "Sleep for 10 sec" && \
sleep 10 && \ 
az aks create --resource-group Calico-AKS-Resourcegroup --name Calico-AKS-Workshop --location westeurope --pod-cidr 192.168.0.0/16 --network-plugin none --generate-ssh-keys && \
echo "Sleep for 10 sec" && \
sleep 10 && \
az aks get-credentials --resource-group Calico-AKS-Resourcegroup --name Calico-AKS-Workshop && \
echo "Sleep for 10 sec" && \
sleep 10 && \
kubectl create -f ./tigera-operator.yaml && \
echo "Sleep for 10 sec" && \
sleep 10 && \
kubectl create -f ./tigera-operator-installation.yaml && \
echo "Sleep for 10 sec" && \
sleep 10 && \
kubectl apply -f ./yaobank-org.yaml && \
echo "Sleep for 10 sec" && \
sleep 10 && \
kubectl apply -f ./yoabank-loadbalancer.yaml && \
echo "Sleep for 10 sec" && \
sleep 10 && \
kubectl get svc -n yaobank-customer yaobank-customer -w