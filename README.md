# aks-lab

José Caneira's garden of AKS related stuff

__________________________________________________________________________________________________________________________________________________________________________________________________________

**tcpdump DaemonSet**

DaemonSet to collect tcpdump capture files on each AKS cluster node

Based on https://github.com/amjadaljunaidi/tcpdump however only using yaml
Doesn't require Helm and uses Azure Linux(Mariner) image from Microsoft Artifcat Registry(MCR)
Should work on more restricted egress AKS clusters since only requires access to Microsoft MCR(mcr.microsoft.com) and Azure Linux Packages(packages.microsoft.com)
A PV/PVC share will be created on the AKS cluster default storage account that then can be browsed on cluster "MC_" Resource Group using Azure Portal

Check it out at https://github.com/josecaneira/aks-lab/tree/main/tcpdump_daemonset

__________________________________________________________________________________________________________________________________________________________________________________________________________
