
**tcpdump DaemonSet**

DaemonSet to collect tcpdump capture files on each AKS cluster node

Based on https://github.com/amjadaljunaidi/tcpdump however only using yaml
Doesn't require Helm and uses Azure Linux(Mariner) image from Microsoft Artifcat Registry(MCR)
Should work on more restricted egress AKS clusters since only requires access to Microsoft MCR(mcr.microsoft.com) and Azure Linux Packages(packages.microsoft.com)
A PV/PVC share will be created on the AKS cluster default storage account that then can be browsed on cluster "MC_" Resource Group using Azure Portal

Special thanks to Amjad Aljunaidi

INSTALL and RUN: kubectl apply -f https://github.com/josecaneira/aks-lab/raw/main/tcpdump_daemonset/tcpdump_ds.yaml

PV needs to be patched so that it would be retained after DaemnonSet delete:<br>
&nbsp;&nbsp;&nbsp;1st Identify PV: kubectl get pv|grep tcpdump<br>
&nbsp;&nbsp;&nbsp;2nd Patch PV: kubectl patch pv <pv_name>  -p "{\"spec\":{\"persistentVolumeReclaimPolicy\":\"Retain\"}}"<br>
<br>
STOP and UNINSTALL: kubectl delete -f https://github.com/josecaneira/aks-lab/raw/main/tcpdump_daemonset/tcpdump_ds.yaml<br>
<br>
Customize usage:<br>
&nbsp;&nbsp;&nbsp;wget https://github.com/josecaneira/aks-lab/raw/main/tcpdump_daemonset/tcpdump_ds.yaml<br>
&nbsp;&nbsp;&nbsp;Edit the "tcpdump_ds.yaml" file and change the configmap variables or whatever you want<br>
&nbsp;&nbsp;&nbsp;Deploy/RUN with: kubectl apply -f tcpdump_ds.yaml<br>
&nbsp;&nbsp;&nbsp;Patch the PV as described above, so that it doesn't get deleted when you delete/stop the deployment<br>
&nbsp;&nbsp;&nbsp;Delete/STOP with: kubectl delete -f tcpdump_ds.yaml<br>

Version: 1.1.2<br>
CHANGELOG:<br>
&nbsp;&nbsp;&nbsp;&nbsp;11/08/2023:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Initial release.<br>
&nbsp;&nbsp;&nbsp;&nbsp;12/08/2023:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Insert of a ConfigMap with source(SRC) and destination(DST) variables to filter the tcpdump, update line 34 and/or 36 on the data section of the ConfigMap to use filtering;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Posibility to run tcpdump only on a specific node, uncomment line 135 on nodeSelector section and personalize it with your own node hostname.<br>
&nbsp;&nbsp;&nbsp;&nbsp;26/10/2023:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Added support for use of CIDRs on SRC and DST filters. Thank you Fabio Fidelis for pointing this out.<br>
&nbsp;&nbsp;&nbsp;&nbsp;20/02/2024:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Moved tcpdump project to it's own directory "tcpdump_daemonset" and renamed to "tcpdump_ds.yaml"<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Added support to change the operator when both "SRC" and "DST" are set. Accepted values are "or", "OR", "and" and "AND", if empty defaults to "and".<br><br>
TODO: Add support to filter by interface name on João Pedrosa suggestion. Other suggestions and feedback is welcomed.<br>

__________________________________________________________________________________________________________________________________________________________________________________________________________
