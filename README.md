# aks-lab
José Caneira's garden of AKS related stuff

__________________________________________________________________________________________________________________________________________________________________________________________________________

**tcpdump DaemonSet:**

DaemonSet to collect tcpdump capture files on each AKS cluster node

Based on https://github.com/amjadaljunaidi/tcpdump however only using yaml
Doesn't require Helm and uses Azure Linux(Mariner) image from Microsoft Artifcat Registry(MCR)
Should work on more restricted egress AKS clusters since only requires access to Microsoft MCR(mcr.microsoft.com) and Azure Linux Packages(packages.microsoft.com)
A PV/PVC share will be created on the AKS cluster default storage account that then can be browsed on cluster "MC_" Resource Group using Azure Portal

INSTALL and RUN: kubectl apply -f https://github.com/josecaneira/aks-lab/raw/main/mariner_tcpdump_ds.yaml

PV needs to be patched so that it would be retained after DaemnonSet delete:
    1st Identify PV: kubectl get pv|grep tcpdump
    2nd Patch PV: kubectl patch pv <pv_name>  -p "{\"spec\":{\"persistentVolumeReclaimPolicy\":\"Retain\"}}"

STOP and UNINSTALL: kubectl delete -f https://github.com/josecaneira/aks-lab/raw/main/mariner_tcpdump_ds.yaml

Special thanks to Amjad Aljunaidi

Version: 1.1<br>
CHANGELOG:<br>
&nbsp;&nbsp;11/08/2023:<br>
&nbsp;&nbsp;&nbsp;&nbsp;Initial release.<br>
&nbsp;&nbsp;12/08/2023:<br>
&nbsp;&nbsp;&nbsp;&nbsp;Insert of a ConfigMap with source(SRC) and destination(DST) variables to filter the tcpdump, update line 34 and/or 36 on the data section of the ConfigMap to use filtering;<br>
&nbsp;&nbsp;&nbsp;&nbsp;Posibility to run tcpdump only on a specific node, uncomment line 135 on nodeSelector section and personalize it with your own node hostname.<br>
<br>
TODO: Suggestions and feedback is welcomed.<br>

__________________________________________________________________________________________________________________________________________________________________________________________________________
