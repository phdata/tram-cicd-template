# Tram CICD Template and Example Stacks

phData [Tram](https://www.phdata.io/tram/) is an infrastructure-as-code tool for creating and managing Snowflake users, roles, and objects.

This repository contains:

* A continuous delivery/continuous deployment workflow for Tram
* Example stacks that can be used to quickly bootstrap a Snowflake account

Full Tram documentation can be found on the [phData Customer Docs](https://docs.customer.phdata.io/docs/tram/) site.

## Tram CICD

This repository provides example build scripts for Jenkins, Bitbucket, AWS CodeBuild, and Azure Pipelines. Details on the CICD workflow and configuring this repo can be found in the  [CICD Deployment Strategy](./cicd_deployment_strategy.md) document.

## Stacks

Tram example stacks can be found in the [stacks](./stacks) directory.

### Source-Product

The [Source-Product](./stacks/source-product) stack organizes data into 'sources' that are consumed by 'products', taking advantage of the Snowflake role hierarchy to enforce one-way data flows and least-privilege access.
