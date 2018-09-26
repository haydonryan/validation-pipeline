# Validation Pipelines

A collectionn of Concourse Tasks that can be run to validate that your inputs to PCF-Pipelines are correct.

## Problem Statement:
When deploying Pivotal Application Service via pipelines you need to configure many settings.  Some of these settings if incorrect will only give you feedback late in the deploy process (for example incorrectly configured certificates).  By checking these prior to deployment, we can improve the speed of the feedback loop to save time.

Similarly if we can also add other checks, then we should do these in parallel before deployment.

Each Validation task will have individual contributors:

## Validation Tasks:
- [Certificate Validator](check-certs/README.md)
