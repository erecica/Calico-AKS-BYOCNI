WCO='\033[0;32m' # With color
NC='\033[0m' # No Color

az group create --name Calico-AKS-Resourcegroup && \
echo "${WCO}Resourcegroup created.\nMoving to the next step${NC}" && \
sleep 5 && \ 
az aks create --resource-group Calico-AKS-Resourcegroup --name Calico-AKS-Workshop --pod-cidr 192.168.0.0/16 --network-plugin none --generate-ssh-keys && \
echo "${WCO}AKS without network-plugin created.\nThis might take 6-9 minutes${NC}" && \
sleep 5 && \
az aks get-credentials --resource-group Calico-AKS-Resourcegroup --name Calico-AKS-Workshop && \
echo "${WCO}Get AKS credentials.${NC}" && \
sleep 5 && \
kubectl create -f ./tigera-operator.yaml && \
echo "${WCO}Create operator.\nOne moment please...${NC}" && \
sleep 5 && \
kubectl create -f ./tigera-operator-installation.yaml && \
echo "${WCO}Install operator.\nOne moment please...${NC}" && \
sleep 5 && \
kubectl apply -f ./yaobank-org.yaml && \
echo "${WCO}Deploy YOABank app. Sleep for 5 sec${NC}" && \
sleep 5 && \
kubectl apply -f ./yoabank-loadbalancer.yaml && \
echo "${WCO}Deploy Loadbalancer. Waiting for External IP...${NC}" && \
sleep 5 && \
watch kubectl get svc -n yaobank-customer yaobank-customer