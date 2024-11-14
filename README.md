Defined modules:
   1. Service PrinciPal
   2. KeyVault
   3. AKS

In Azure Active Directory, an App is registered which represents AKS cluster. In order to create azure resources, AKS authenticates itself with azure AD with service principal. 
For service principal, contributor role has been given to create secrets in key vault. 
For sevice princiapl, "ACR" pull role has been given so that AKS can pull images from ACR. AKS authenticates itself with service principal client id and client secret.

