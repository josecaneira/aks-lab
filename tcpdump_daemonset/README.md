
**tcpdump DaemonSet**

DaemonSet to collect tcpdump capture files on each AKS cluster node

# Based on https://github.com/amjadaljunaidi/tcpdump however only using yaml.
# Improved with features from https://github.com/ioanc/k8s-network-troubleshooting/blob/master/daemonSet-tcpdump-pvc.yaml
#
# Using this yaml file will create a configmap, a StorageClass, a PersistentVolumeClaim and a DaemonSet that will run a tcpdump command on each one of your nodes.
# Key features:
#               Doesn't require Helm and uses Azure Linux(Mariner) image from Microsoft Artifcat Registry(MCR) that is already cached on AKS nodes;
#               Should work on more restricted egress AKS clusters since only requires access to Microsoft MCR(mcr.microsoft.com) and Azure Linux Packages(packages.microsoft.com);
#               A PV/PVC file share will be created on the AKS cluster default storage account that then can be browsed on your cluster managed Resource Group "MC_" using Azure Portal;
#               Can be customized by changing the variables defined on the ConfigMap to better tailor your requirements.
#
# Special thanks to Amjad Aljunaidi and Ioan Corcodel

# Default usage:
#    1) Deploy/Run: kubectl apply -f https://github.com/josecaneira/aks-lab/raw/main/tcpdump_daemonset/tcpdump_ds.yaml
#    2) Wait for traffic to be collected;
#    3) Delete/Stop: kubectl delete -f https://github.com/josecaneira/aks-lab/raw/main/tcpdump_daemonset/tcpdump_ds.yaml
#    4) Delete the PV:
#       a) Get the PV name: kubectl get pv|grep tcpdump
#       b) Delete the PV: kubectl delete pv <PV_NAME>
#    5) Browse the file share(PV) on your cluster managed Resource Group "MC_" using Azure Portal to download capture files.
#
# Customize usage:
#    1) Download from GitHub: wget https://github.com/josecaneira/aks-lab/raw/main/tcpdump_daemonset/tcpdump_ds.yaml
#    2) Edit the "tcpdump_ds.yaml" file and change the ConfigMap variables or whatever you want
#    3) Deploy/Run with: kubectl apply -f tcpdump_ds.yaml
#       OPTIONAL - Deploy/Run using a namespace: kubectl apply -f tcpdump_ds.yaml -n your-namespace
#    4) Wait for traffic to be collected;
#    5) Delete/Stop with: kubectl delete -f tcpdump_ds.yaml
#       OPTIONAL - Delete/Stop using a namespace: kubectl delete -f tcpdump_ds.yaml -n your-namespace
#    6) Delete the PV:
#       a) Get the PV name: kubectl get pv|grep tcpdump
#       b) Delete the PV: kubectl delete pv <PV_NAME>
#    7) Browse the file share(PV) on your cluster managed Resource Group "MC_" using Azure Portal to download capture files.
#
# Latest Version: 1.1.4
#
# CHANGELOG:
#     11/08/2023:
#         Initial release.
#     12/08/2023:
#         Insert of a ConfigMap with source(SRC) and destination(DST) variables to filter the tcpdump, update line 34 and/or 36 on the data section of the ConfigMap to use filtering;
#         Posibility to run tcpdump only on a specific node, uncomment line 145 on nodeSelector section and personalize it with your own node hostname.
#     26/10/2023:
#         Added support for use of CIDRs on SRC and DST filters. Thank you Fabio Fidelis for pointing this out.
#     20/02/2024:
#         Moved tcpdump to it's own directory tcpdump_daemonset and renamed to tcpdump_ds.yaml
#         Added support to change the operator when both "SRC" and "DST" are set. Accepted values are "or" or "OR", if empty or any other value defaults to "and".
#     21/02/2024:
#         Added support to filter by interface name. Used with nodeSelector will allow you to only collect pod traffic. Thank you João Pedrosa for suggesting this;
#         Added support to change dump file size. If empty or not a integer number will default to 500MB, unit is MegaBytes;
#         Removed namespace so that namespace can be used at apply.
#     23/02/2024:
#         Added a storageClass with retain on reclaimPolicy to avoid patching PV manually. Thank you Ioan Corcodel for the idea from is own work https://github.com/ioanc/k8s-network-troubleshooting/blob/master/daemonSet-tcpdump-pvc.yaml
#         Added support to filter by HOST, if HST variable is set it will be used to filter the tcpdump with "host" option, SRC and DST variables will be ignored;
#         Improved logic so that IFs aren't required to handle the INT variable per each tcpdump command. Default interface will be "any".
#
# TODO: Implement a "restricted" mode to only collect certain packages types. Other suggestions and/or feedback is welcomed.
#
__________________________________________________________________________________________________________________________________________________________________________________________________________
