# Certificate Validator

## Purpose: 
This pipeline task provides a pre-deployment check of your SSL certs for Pivotal Clouf Foundry.  This task has been designed to run as the first step of your PCF-Pipelines deployment and provide fast feedback to the user to ensure that hours are not lost with incorrectly entered certs (they're tricky!).


### It checks:
- That you have the correct SANS  (for System, Login UAA and Apps Domains)
- The server cert matches the key
- That the server certificate has not expired (and prints a warning if it's going to expire in 6 months or less)
- The certificate chain is valid

## Maintainer

* [Haydon Ryan](https://github.com/haydonryan)

## Support

Validation Pipelines is a community supported cloud foundry add-on.  Opening issues for questions, feature requests and/or bugs is the best path to getting "support".  We strive to be active in keeping this tool working and meeting your needs in a timely fashion.

## Current Status:
Task.sh has been run as a script, however concourse pipeline testing has not yet been performed.

## To Do:
- Build example pipeline to test task
- Support multiple server certificates
- Support multiple intermediate certificates
- Check that the private key doesn't have a password