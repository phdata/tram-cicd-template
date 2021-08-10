# Tram CI/CD Deployment Strategy

This document outlines the Tram CICD deployment strategy using a build tool like AWS CodeBuild, GitLab CI/CD, or Github Actions at a client site.

This workflow will work for any infrastructure provisioned using the file-based API, including Tram Active Directory synchronization.

### Source Control

Tram resources, including 'group' and 'model' files should always be stored in source control.

#### Source Control Configuration

To use this workflow, the git ‘master’ branch should be restricted to a small group of approvers. Rewriting of history on the master branch should also be disabled.

### Tram CI/CD Workflow

Tram can be run using a build tool like AWS CodeDeploy, BitBucket Pipelines, any other on-prem or SaaS build tool.

#### Workflow Steps

* Users will make a change request or pull request to the Tram resource files. This can include changes to group files (to provision new resources) or changes in models (to define how Snowflake objects are provisioned).
* For any pull request, the build tool will be configured to run the `bin/tram-dry-run` script. This script will validate configuration file syntax, as well as print out a list of statements that Tram will execute against snowflake in the event the change is accepted.
* Privileged users will review the pull request/change request, providing feedback or accepting and rejecting changes.
* If the change is accepted, it should be merged into the ‘master’ branch.
* When the change is merged into the master branch, Tram will execute the `bin/tram-provision` script to create the new objects in Snowflake. If Active Directory synchronization is enabled, a scheduled job should be created instead of running `bin/tram-provision` on merge.

#### Build Tool Specific Installations

Each build tool’s build definition language is slightly different. phData can develop build definition scripts for whichever build tool the client is using.

#### Monitoring and Alerting

Monitoring and alerting is handled by the build tool using their existing monitoring and alerting mechanisms. The phData team should have access to the build logs and alerts so they can assist in troubleshooting and fixing configuration or application issues.

#### Upgrading Tram

The `bin/tram-fetch` scripts will pull Tram from a secured repository managed by phData. The tram version used can be updated by changing the version number in the `TRAM_VERSION` file at the repository root.

The client will be provided with a token to fetch Tram. These should be set in the build environment as:

```
TRAM_ENTITLEMENT_TOKEN=<token>
```

#### Choosing a Stack

Example stacks are kept in the `stacks/` directory. To point the scripts at a stack, export the variable `STACK_PATH`, for example:

```
STACK_PATH = 'stacks/source-product'
```

#### Snowflake Authentication

The following properties must be updated in the file `application.properties`:

```
tram.general.acceptEula # read the EULA at https://www.phdata.io/eula/
tram.snowflake.url
tram.snowflake.user
```

Private keys and passwords should be stored in the build tool as secured build variables. If using private key authentication, the url
should also be stored as a secured variable.

```
TRAM_SNOWFLAKE_USER
TRAM_SNOWFLAKE_URL
```

It is recommended private/public key authentication is used in this process, but `SNOWFLAKE_PASSWORD` can be used instead.

#### Logging

Change the log level by setting the `LOG_LEVEL` env variable, for example: `LOG_LEVEL=debug`.

#### Active Directory Synchronization

Full documentation for Active Directory synchronization can be found [here](https://docs.customer.phdata.io/docs/tram/latest/user-manual/#active-directory-synchronization)

If Tram groups are synchronized with Active Directory, the following properties must be set in `application.properties`

```
concert.ldap.userdn
concert.ldap.url
```

The ldap password should be stored as a secured variable:

```
CONCERT_LDAP_PASSWORD
```

#### Auditing

Auditing in this workflow is kept in the git history. It is possible to see who created the request by the pull request that was made. The approver of the pull/change request is also recorded in git history. Because audit history is kept in source control, Tram’s internal auditing is disabled for this workflow.
