

***Bash shell script to parse data from Trivy Operator running on an AKS cluster.***



Requirements:
* Trivy Operator running on AKS cluster:  
    Overview: https://aquasecurity.github.io/trivy-operator/v0.3.0/operator  
    Install using Helm: https://aquasecurity.github.io/trivy-operator/v0.3.0/operator/installation/helm  
    Install using kubectl: https://aquasecurity.github.io/trivy-operator/v0.3.0/operator/installation/kubectl/  

* kubectl command:  
    https://kubernetes.io/docs/tasks/tools/install-kubectl  
    https://docs.microsoft.com/en-us/cli/azure/install-azure-cli  
    After having Azure CLI use `az aks install-cli` to install kubectl and kubelogin  

* jq command:  
    https://jqlang.github.io/jq/download  
    Ubuntu: `sudo apt install jq`  
    Azure Linux: `sudo tdnf install jq`  

* tr command:  
    Ubuntu: `sudo apt install coreutils`  
    AzureLinux: `sudo tdnf install coreutils`  


Key features:
* This script will list all vulnerabilities found by Trivy Operator in AKS clusters;  
* It will list the CVE/GHSA ID, Severity, Link, Published Date, Resource, Installed Version, Fixed Version(s);  
* It will show the Kubernetes Kind, Resource Name, Namespace, Container;  
* On pretty/file mode will also provide provide the command to get the full Trivy report and the command to describe the affected Kubernetes object.  

Trivy Operator deployment:  
* Helm:  
  - Add Aqua chart repository: `helm repo add aqua https://aquasecurity.github.io/helm-charts/` 
  - Update helm repos: `helm repo update` 
  - Install: `helm install trivy-operator aqua/trivy-operator --namespace trivy-system --create-namespace --set="trivy.ignoreUnfixed=true" --version 0.3.0`  
  
* Yaml: `kubectl apply -f https://raw.githubusercontent.com/aquasecurity/trivy-operator/v0.3.0/deploy/static/trivy-operator.yaml` 
  
  
Usage:  
1. Download: `wget https://raw.githubusercontent.com/josecaneira/aks-lab/main/trivy_operator_parser/vulns_aks.sh`  
2. Change permissions: `chmod u+x vulns_aks.sh`  
3. Run: `vulns_aks.sh [file|csv]`  


***Latest Version: 0.10(Initial Public Release)***

CHANGELOG:  
* 18/09/2024:
  - Initial release.

		
TODO: Include other available Trivy fields in outputs.

__________________________________________________________________________________________________________________________________________________________________________________________________________
