# eBPF Dataplane Advantages

eBPF is an innovative way to communicate with the Linux kernel. Since eBPF programs communicate directly with the Linux kernel, they can offer an eye-catching performance that is hard to match with other methods.

Calico’s eBPF data plane uses the power of eBPF and the efficiency of the Linux kernel to push the networking capabilities of Kubernetes further.

By enabling the eBPF mode, Calico will use carefully created eBPF programs to capture every traffic flow in your cluster from its earliest origin and then deliver it to its destination efficiently.

Calico’s native service handling outperforms kube-proxy both in terms of networking and control plane performance and supports features such as source IP preservation. The differences in performance are most noticeable if you have workloads that are particularly sensitive to network latency or if you are running large numbers of services.

## Source IP Check

Before going any further, let’s check out the source IP address that will be logged in our containerized applications. 

Use the following command to read the Pod logs.
```
kubectl logs deployments/customer -n yaobank-customer
```

You should see somthing like this:

```
192.168.57.192 - - [05/Apr/2022 09:16:26] "GET / HTTP/1.1" 200 -
```

## Enabling the Calico eBPF Dataplane

Using the following command, we can determine our load balancer DNS address:

```
kubectl cluster-info | grep -i kubernetes
```

You should see a result similar to the following.

```
Kubernetes control plane is running at https://calico-aks-calico-aks-resou-ee6546-94a15ed2.hcp.westeurope.azmk8s.io:443
```

>Your FQDN address may differ.

```
kubectl apply -f - <<EOF
kind: ConfigMap
apiVersion: v1
metadata:
  name: kubernetes-services-endpoint
  namespace: kube-system
data:
  KUBERNETES_SERVICE_HOST: "https://calico-aks-calico-aks-resou-ee6546-94a15ed2.hcp.westeurope.azmk8s.io"
  KUBERNETES_SERVICE_PORT: "443"
EOF
```

Restart "operator" and "calico-node" deployments.

```
kubectl rollout restart deployments/tigera-operator -n tigera-operator
kubectl rollout restart daemonset/calico-node -n calico-system
```

To enable eBPF mode, change the Felix configuration parameter bpfEnabled to true.

```
kubectl patch felixconfiguration default --type=merge --patch='{"spec": {"bpfEnabled": true}}'
```

You should see a result similar to:

```
felixconfiguration.projectcalico.org/default patched
```

### eBPF Verification
After enabling the eBPF dataplane, “calico-node” pods will begin to output the relative logs to their terminal. By using the logs command from kubectl, you should be able to search these logs for indicators that are relative to eBPF. 

Issue the following command to verify that eBPF is enabled.

```
kubectl logs -n calico-system ds/calico-node | egrep -i "BPF enabled"
```

You should see a result similar to:

```
Found 3 pods, using pod/calico-node-pfkgg
Defaulted container "calico-node" out of: calico-node, flexvol-driver (init), install-cni (init)
2022-11-20 19:53:24.447 [INFO][205] felix/int_dataplane.go 390: BPF enabled, configuring iptables layer to clean up kube-proxy's rules.
2022-11-20 19:53:24.456 [INFO][205] felix/int_dataplane.go 616: BPF enabled, starting BPF endpoint manager and map manager.
2022-11-20 19:53:24.506 [INFO][205] felix/int_dataplane.go 1873: BPF enabled, disabling unprivileged BPF usage.
```

### Disabling kube-proxy
Calico replaces kube-proxy in eBPF mode, so running both would waste resources. You can disable kube-proxy (this is reversible) by adding a node selector to kube-proxy’s DaemonSet that matches no nodes.

For example:

```
kubectl patch ds -n kube-system kube-proxy -p '{"spec":{"template":{"spec":{"nodeSelector":{"non-calico": "true"}}}}}'
```

### Source IP Preservation

Now that eBPF is enabled, and Kube-proxy is not running anymore, external traffic will directly go to the endpoint workloads. This means that endpoint logs now will be able to acquire the end-user public IP address.

Check out the Pod logs.

```
kubectl logs deployments/customer -n yaobank-customer
```
You should see a similar result with your Public IP.


```
217.104.75.175 - - [20/Nov/2022 19:59:51] "GET / HTTP/1.1" 200 -
217.104.75.175 - - [20/Nov/2022 19:59:54] "GET / HTTP/1.1" 200 -
217.104.75.175 - - [20/Nov/2022 20:00:05] "GET / HTTP/1.1" 200 -
217.104.75.175 - - [20/Nov/2022 20:01:07] "GET / HTTP/1.1" 200 -
```


## Disabling eBPF

Reverting eBPF changes is as easy as enabling them.

Execute the following command to disable the eBPF dataplane.

```
kubectl patch felixconfiguration default --type=merge --patch='{"spec": {"bpfEnabled": false}}'
```

Execute the following command to spin up kube-proxy pods.

```
kubectl patch ds -n kube-system kube-proxy --type merge -p '{"spec":{"template":{"spec":{"nodeSelector":{"non-calico": null}}}}}'
```