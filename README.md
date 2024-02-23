# aks-lab

José Caneira's garden of AKS related stuff

__________________________________________________________________________________________________________________________________________________________________________________________________________

***DaemonSet to collect tcpdump capture files on each AKS cluster node storing them on an Azure file share.***

Based on https://github.com/amjadaljunaidi/tcpdump however only using yaml instead of Helm.<br>
Improved with features ideas from https://github.com/ioanc/k8s-network-troubleshooting/blob/master/daemonSet-tcpdump-pvc.yaml<br>
Special thanks to Amjad and Ioan for source materials and ideas.<br>

Using this yaml file will create a configmap, a StorageClass, a PersistentVolumeClaim and a DaemonSet that will run a tcpdump command on each one of your nodes.

Key features:
* Doesn't require Helm and uses Azure Linux(Mariner) image from Microsoft Artifcat Registry(MCR) that is already cached on AKS Azure Linux nodes;
* Should work on more restricted egress AKS clusters since only requires access to Microsoft MCR(mcr.microsoft.com) and Azure Linux Packages(packages.microsoft.com);
* A PV/PVC file share will be created on the AKS cluster default storage account that then can be browsed on your cluster managed Resource Group "MC_" using Azure Portal. If no default storage account exists a new one will be created, __please remember to delete it after it no longer being required__;
* Can be customized by changing the variables defined on the ConfigMap to better tailor your requirements.

Check it out at https://github.com/josecaneira/aks-lab/tree/main/tcpdump_daemonset

__________________________________________________________________________________________________________________________________________________________________________________________________________
