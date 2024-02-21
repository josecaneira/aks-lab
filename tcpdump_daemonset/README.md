
**tcpdump DaemonSet**

DaemonSet to collect tcpdump capture files on each AKS cluster node

Based on https://github.com/amjadaljunaidi/tcpdump however only using yaml.
Using this yaml will create a configmap, a PersistentVolumeClaim and a DaemonSet that will run a tcpdump command on each one of your nodes.
Key features:
                Doesn't require Helm and uses Azure Linux(Mariner) image from Microsoft Artifcat Registry(MCR) that is already cached on AKS nodes;
                Should work on more restricted egress AKS clusters since only requires access to Microsoft MCR(mcr.microsoft.com) and Azure Linux Packages(packages.microsoft.com);
                A PV/PVC share will be created on the AKS cluster default storage account that then can be browsed on your cluster managed "MC_" Resource Group using Azure Portal;
                Can be customized by changing the variables defined on the ConfigMap to better tailor your requirements.

Special thanks to Amjad Aljunaidi

Default usage:<br>
&nbsp;&nbsp;&nbsp;1) Deploy/Run: kubectl apply -f https://github.com/josecaneira/aks-lab/raw/main/tcpdump_daemonset/tcpdump_ds.yaml<br>
&nbsp;&nbsp;&nbsp;2) PV needs to be patched so that it would be retained after DaemnonSet delete:<br>
&nbsp;&nbsp;&nbsp;2.1) Identify PV: kubectl get pv|grep tcpdump<br>
&nbsp;&nbsp;&nbsp;2.2) Patch PV: kubectl patch pv <pv_name>  -p "{\"spec\":{\"persistentVolumeReclaimPolicy\":\"Retain\"}}"<br>
&nbsp;&nbsp;&nbsp;3) Delete/Stop: kubectl delete -f https://github.com/josecaneira/aks-lab/raw/main/tcpdump_daemonset/tcpdump_ds.yaml<br>
<br>
Customize usage:<br>
&nbsp;&nbsp;&nbsp;1) Download from GitHub: wget https://github.com/josecaneira/aks-lab/raw/main/tcpdump_daemonset/tcpdump_ds.yaml<br>
&nbsp;&nbsp;&nbsp;2) Edit the "tcpdump_ds.yaml" file and change the ConfigMap variables or whatever you want<br>
&nbsp;&nbsp;&nbsp;3) Deploy/Run with: kubectl apply -f tcpdump_ds.yaml<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;OPTIONAL - Deploy/Run using a namespace: kubectl apply -f tcpdump_ds.yaml -n your-namespace
&nbsp;&nbsp;&nbsp;4) Patch the PV as described above, so that it doesn't get deleted when you delete/stop the deployment<br>
&nbsp;&nbsp;&nbsp;5) Delete/Stop with: kubectl delete -f tcpdump_ds.yaml<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;OPTIONAL - Delete/Stop using a namespace: kubectl delete -f tcpdump_ds.yaml -n your-namespace


Version: 1.1.3<br>
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
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Added support to change the operator when both "SRC" and "DST" are set. Accepted values are "or" or "OR", if empty or any other value defaults to "and".<br>
&nbsp;&nbsp;&nbsp;&nbsp;21/02/2024:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Added support to filter by interface name. Used with nodeSelector will allow you to only collect pod traffic. Thank you João Pedrosa for suggesting this;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Added support to change dump file size. If empty or not a integer number will default to 500MB, unit is MegaBytes;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Removed namespace so that namespace can be used at apply.<br>
<br>
TODO: Use a storageClass with retain to avoid patching PV manually. Other suggestions and/or feedback is welcomed.<br>

__________________________________________________________________________________________________________________________________________________________________________________________________________
