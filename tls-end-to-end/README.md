

***How to setup TLS end-to-end using AKS + Application Gateway and cert-manager***

Key features:  
* Two options provided: Public AKS and AppGw or Private AKS and AppGw;
* cert-manager will handle new certificates and renewal;
* cert-manager will validate domains using the solvers configured on cluster-issues, currently appgw or dns01 samples are provided;
* AGIC will update Application Gateway configurations and update new/renewed certificates;
* nginx image used for backend endpoint.


CHANGELOG:  
* 20/03/2023:
  - Place holder.
		
TODO: Initial release.  


Reference documentation:  
  https://azure.github.io/application-gateway-kubernetes-ingress/annotations/  
  https://cert-manager.io/docs/configuration/acme/dns01/azuredns/  
  https://letsencrypt.org/docs/challenge-types/#dns-01-challenge  
  https://cert-manager.io/docs/configuration/acme/  
  https://cert-manager.io/docs/configuration/acme/dns01/#setting-nameservers-for-dns01-self-check  

__________________________________________________________________________________________________________________________________________________________________________________________________________
