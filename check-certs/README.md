# Certificate Validator

Purpose: This pipeline provides a pre-deployment check of your SSL certs for Pivotal Clouf Foundry.  

#### Current Status:
Tash.sh has been run as a script, however concourse pipeline testing has not yet been performed.

#### It checks:
- That you have the correct SANS  (for System, Login UAA and Apps Domains)
- The server cert matches the key
- That the server certificate has not expired (and prints a warning if it's going to expire in 6 months or less)
- The certificate chain is valid


#### To Do:
- Support multiple server certificates
- Support multiple intermediate certificates
- Check that the private key doesn't have a password