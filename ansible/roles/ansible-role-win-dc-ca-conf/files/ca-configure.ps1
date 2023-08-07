# Configure CA
Install-AdcsCertificationAuthority -CAType EnterpriseRootCa -CACommonName rootca2.democloud.local -CryptoProviderName "ECDSA_P256#Microsoft Software Key Storage Provider" -KeyLength 256 -HashAlgorithmName SHA256 -Force

