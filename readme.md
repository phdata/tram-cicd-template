# Tram CICD Template

phData [Tram](https://www.phdata.io/tram/) is an infrastructure-as-code tool for creating and managing Snowflake users, roles, and objects.

This repository contains a continuous delivery/continuous deployment workflow for Tram. Using the provided config files Tram will quickly, consistently, and reliably manage your Snowflake account.

Full Tram documentation can be found on the [phData Customer Docs](https://docs.customer.phdata.io/docs/tram/) site.

## Tram CICD

This repository provides example build scripts for Jenkins, Bitbucket and AWS CodeBuild. Details on the CICD workflow can be found in the  [CICD Deployment Strategy](./cicd_deployment_strategy.md) document.

This project serves as a Snowflake resources manager for the <https://phdata.snowflakecomputing.com> Snowflake instance. It contains yaml files which are processed by the 
[Tram](https://bitbucket.org/phdata/tram/src/master/) provisioning service. 

## Stacks

Tram example stacks can be found in the `stacks/` directory.
