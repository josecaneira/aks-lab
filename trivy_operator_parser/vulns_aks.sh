#!/bin/bash
#
# This script will list all vulnerabilities found by Trivy Operator in AKS clusters
# It will list the CVE/GHSA ID, Severity, Link, Published Date, Resource, Installed Version, Fixed Version(s)
# It will also list the Kubernetes Kind, Resource Name, Namespace, Container and provide the command to get the full Trivy report
# It will also provide the command to describe the Kubernetes object
# Usage: bash vulns_aks.sh [file|csv]
# Output: vulns_aks_YYYYMMDD_HHMMSS.txt/csv (if file or csv argument is provided)
# Requirements: kubectl, jq, tr and trivy-operator deployment in AKS cluster
#
# Author: José Caneira
# Created Date: 2024-09-02
# Updated Date: 2024-09-20
# Version: 0.10.1
#CHANGELOG:  
# 18/09/2024 - 0.10 :
#  - Initial release.  
# 20/09/2024 - 0.10.1 :
#  - Minor bug correction where cluster name variable was being printed before being initialized;
#  - installedVersion also needed to be escaped to avoid CSV issues;
#  - replaced "tr" by "sed" on escaping commas;
#  - Updates to README.md to reflect up to date version in the links.
# 30/10/2024 - 0.10.2 :
#  - Added AKS cluster name to the output filename;
#
# TODO: Include more fields in the output
#
# Requirements checking...
if ! command -v kubectl &> /dev/null; then
    echo "kubectl could not be found, please install kubectl..."
    echo "https://kubernetes.io/docs/tasks/tools/install-kubectl"
    echo "https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    echo "az aks install-cli"
    exit 1
fi  
if ! command -v jq &> /dev/null; then
    echo "jq could not be found, please install jq..."
    echo "https://jqlang.github.io/jq/download/"
    exit 1
fi
if ! command -v sed &> /dev/null; then
    echo "sed command could not be found, please install sed..."
    echo "Ubuntu/Debian: sudo apt install sed"
    echo "AzureLinux: sudo tdnf install sed"
    exit 1
fi
if [ -z "`kubectl get deploy -A|grep trivy-operator`" ]; then
    echo "trivy-operator deployment not found, please install trivy-operator in AKS cluster..."
    echo "https://github.com/aquasecurity/trivy-operator"
    echo "helm repo add aqua https://aquasecurity.github.io/helm-charts/"
    echo "helm repo update"
    echo "helm install trivy-operator aqua/trivy-operator --namespace trivy-system --create-namespace"
    exit 1
fi
#Grab the current AKS cluster name from kubectl context.
cluster=`kubectl config current-context`
if [ -z "$cluster" ]; then
    echo "Could not get AKS cluster name from kubectl context..."
    exit 1
fi
echo "Collecting vulnerabilities from \"$cluster\" AKS cluster..."
if [ "$1" == "csv" ]; then
    csv=true
    log="vulns_aks_${cluster}_`date +%Y%m%d_%H%M%S`.csv"
    echo "Resource Kind,Resource Name,Namespace,Container,Vulnerability ID,Severity,Link,Published Date,Affected Component,Installed Version,Fixed Version(s)" >>${log}
else
    csv=false
    log="vulns_aks_${cluster}_`date +%Y%m%d_%H%M%S`.txt"
    echo "Vulnereabilities for \"$cluster\" AKS cluster:">${log}
    echo "#####################################################" >>${log}
fi
# Main loop to get vulnerabilities.
for pods in `kubectl get vuln -A --no-headers|awk '{print $2":"$1}'`; do
  pod=$(echo $pods|awk -F ":" '{print $1}')
  namespace=$(echo $pods|awk -F ":" '{print $2}')
  jq=$(kubectl get vuln $pod -n $namespace -ojson)
  trivy_name=`echo $jq|jq -r '.metadata.name'`
  namespace=`echo $jq|jq -r '.metadata.namespace'`
  name=`echo $jq|jq -r '.metadata.labels["trivy-operator.resource.name"]'`
  kind=`echo $jq|jq -r '.metadata.labels["trivy-operator.resource.kind"]'`
  container=`echo $jq|jq -r '.metadata.labels["trivy-operator.container.name"]'`
  cves=`echo $jq|jq -r ".report.vulnerabilities[] | .vulnerabilityID, .primaryLink, .publishedDate, .severity, .resource, .installedVersion, .fixedVersion"`
  if [ ! -z "$cves" ]; then
    # If not CSV output, print a pretty output.
    if [ "$csv" != "true" ]; then
      echo "Kubernetes Kind: $kind"
      echo "Resource Name: $name"
      echo "Namespace: $namespace"
      echo "Container: $container"
      echo ">> Get Trivy full report:"
      echo "   kubectl get vuln $trivy_name -n $namespace -ojson|jq"
      echo ">> Describe Kubernetes object:"
      echo "   kubectl describe $kind $name -n $namespace"
      echo "Check out CVEs/GHSAs bellow:"
    fi
    count=1
    # Get vulnerabilities of the current object in a while read loop.
    kubectl get vuln $trivy_name -n $namespace -o json | jq -r '.report.vulnerabilities[] | .fixedVersion, .installedVersion, .lastModifiedDate, .links, .primaryLink, .publishedDate, .resource, .score, .severity, .target, .title, .vulnerabilityID' | while read -e line; do
      # Full set of fields available in the Trivy report. TODO: include all fields into output.
      # Commas in installedVersion and fixedVersion need to be replaced to avoid csv issues.
      case $count in
        1)
            fixedVersion=$(echo $line|sed 's/\,/\;/g')
            ;;
        2)
            installedVersion=$(echo $line|sed 's/\,/\;/g')
            ;;
        3)
            lastModifiedDate=$(echo $line)
            ;;
        4)
            links=$(echo $line)
            ;;
        5)
            primaryLink=$(echo $line)
            ;;
        6)
            publishedDate=$(echo $line)
            ;;
        7)
            resource=$(echo $line)
            ;;
        8)
            score=$(echo $line)
            ;;
        9)
            severity=$(echo $line)
            ;;
        10)
            target=$(echo $line)
            ;;
        11)
            title=$(echo $line)
            ;;
        12)
            vulnerabilityID=$(echo $line)
            ;;
      esac
      # Check if we have all fields to print or increment the count if not.
      if [ $count -eq 12 ]; then
        if [ "$csv" == "true" ]; then
            echo "$kind,$name,$namespace,$container,$vulnerabilityID,$severity,$primaryLink,$publishedDate,$resource,$installedVersion,$fixedVersion"
        else
          # If not CSV print a pretty output.
          echo "-------- Vulnerability ---------"
          echo "CVE/GHSA ID: $vulnerabilityID"
          echo "Severity: $severity"
          echo "Link: $primaryLink"
          echo "Published Date: $publishedDate"
          echo "Affected Component: $resource"
          echo "Installed Version: $installedVersion"
          echo "Fixed Version(s): $fixedVersion"
        fi
        count=1
      else
        count=$((count+1))
      fi
    done
    if [ "$csv" != "true" ]; then
      echo "#####################################################"
    fi    
  fi
done >>${log}
echo "">>${log}
# Trivy will show vulnerabilities from images that are not actually running in the cluster just because they are referenced in a Kubernetes object.
echo "<<NOTE: Trivy will show vulnerabilities from images that are not actually running in the cluster just because they are referenced in a Kubernetes object.>>">>${log}
echo "Finished vulnerabilities collection from \"$cluster\" AKS cluster."
# Keep the log if file or csv argument is provided
if [ "$1" == "file" ] || [ "$1" == "csv" ] ; then
    echo "Output saved to $log"
elif [ "$1" != "csv" ]; then
    cat ${log}
    rm ${log}
fi
# THE END!