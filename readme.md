# Project Administration (Tram) CICD Template and Example Stacks

The phData [Toolkit](https://toolkit.phdata.io/) is a unified interface for all of phData’s apps and tools that help to accelerate and automate your data projects. With central access, detailed documentation, unified updates, and a robust resource library, it’s now easier than ever to leverage phData’s automation software with our Toolkit.

After induction of Toolkit, **Tram** is rebranded as **_Project Administration_**, is an infrastructure-as-code tool for creating and managing Snowflake users, roles, objects and can be used to bootstrap a Snowflake account quickly.

This repository contains:

* A continuous delivery/continuous deployment workflow for Tram.
* Example stacks that can be used to quickly bootstrap a Snowflake account.

Detailed documentation of Tram is available in Toolkit [docs](https://toolkit.phdata.io/resources/documentation/project-administration/home) site.

## Tram CICD

This repository provides example build scripts for Jenkins, Bitbucket, AWS CodeBuild, and Azure Pipelines. Details on the CICD workflow and configuring this repo can be found in the  [CICD Deployment Strategy](./cicd_deployment_strategy.md) document.

## Stacks

Tram example stacks can be found in the [stacks](./stacks) directory.

### Source-Product

The [Source-Product](./stacks/source-product) stack organizes data into 'sources' that are consumed by 'products', taking advantage of the Snowflake role hierarchy to enforce one-way data flow and least-privilege access.
