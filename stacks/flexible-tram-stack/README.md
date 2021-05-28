# Introduction

This Tram provisioning defintion contains three folders:
* groups
* models
* objects

Objects is a placeholder folder for one-off situations where you need to define a Snowflake object that doesn't fit needly into the model-group structure.

Models holds the definitions used by groups to create Snowflake objects. The model files don't do anything on their own, but act as templates the groups
provide paramters to that will cause TRAM to run SQL statements. A model can create one resource or a set of resources.

Groups are the day-to-day files that define what resources we want to create by invoking Model files.

There are files that you will not need. This example provides enough granularity to be useful for any scale project, but most projects will not need everything.

For example, we provide global, business unit, and project level resources. You may decide to condense that to global and business unit. For a very small project, 
you might even use global without any more granularity.

## Product and Source databases

In the example information architecture, I provide definitions for product and source databases. A source database is one that mirrors a source system, while a product 
database contains the curated and consumer-ready data from one or more source databases. You may need more or less stages (in the form of databases or schemas) for your 
data and you may choose to use schemas rather than databases for those steps. I choose to use databases because the access control model is condusive to that level of 
granularity when managed by TRAM, but with some effort it is possible to do it with schemas, the trade-off being that new schemas will need to be managed from within 
TRAM rather than by the project teams.

The definitions that I gave have worked well for me and are what I believe to be minimalistic without falling short of what is necessary. That shouldn't prevent you from 
exapanding upon where I have started.

## Roles

A note on roles: Throughout the process of defining your information architecture, you'll definte both access roles and functional roles.

A Snowflake object can be a database, warehouse, schema, table, stage, integration, stored procedure, or anything else one defines with a SQL CREATE statement.

A functional role is granted to users and is a collection of access roles. Functional roles do not have direct grants to Snowflake objects. 

An access role is a set of grants related to a Snowflake objects collected as a role. They exist for three purposes:
1. They help document functional roles by providing easy-to-read and common high-level definitions.
2. They make defining functional roles less error prone by reducing the number of statements necessary to define the appropriate access.
3. They make changing access across many functional roles simple and accurate.

An access role should never be directly used by a user, as it won't give them access to both compute and data at the same time. This can be confusing to new users
and is the primary disadvantage to this structure. Despite this, we still recommend using them, but you will want a role naming convention to help avoid confusion.

This IA gives you the ability to prefix the names of Functional Roles and Access Roles. In the examples, we use `FR_` for functional roles and `AR_` for access roles. 
It would be perfectly acceptable to prefix only one or the other. For example, you could prefix access roles with `ZZ_` and then name functional roles without any prefix. 
You are balancing legibility, usability, and maintainability of your information architecture. More prefixes tends to make the definitions look esoteric, but without 
any prefixes, users won't know whether they should or should not use a role. Since most UIs (including the Snowflake UI) show role names alphabetically, I prefer to 
prefix my access roles with `ZZ_` and not prefix my functional roles to achieve a balance. Yes, ZZ_ is esoteric, but only for those roles that I don't want a user to 
actually use. Users who forget or do not read training material tend to immediately be suspicious of ZZ_ roles only see them if they scroll down. If they attempt to 
use those roles and they do not work, they are also less inclined to think there is something wrong with the roles.

## Composite Roles
This information architecture provides the ability to grant users a Composite Role. This role has pros and cons.

Pros:
* Users do not have to switch roles to access any data they have access to, and is useful when company access controls are by resource rather than functional role.

Cons:
* Users can mix-and-match warehouses and data between projects, which is not well suited to companies that chargeback expenses to the projects that utilize compute 
resources and for certain companies can also have regularitory issues when data is mixed.

# Groups

The top level folder structure holds objects that are account-wide. It has two child folders:
* ad_groups
* projects

`ad_groups` exists to prevent the main folder from becoming too cluttered and holds the mappings between Active Directory groups and Snowflake Roles. 

`projects` holds folders for each business unit, and each of those folders holds folders for each project. This is a suggested directory structure, but 
it is possible to organize your files however suits your needs.


## databases

The Databases group defines a list of databases managed outside of specific projects. These might be used for monitoring, reporting, or shared stored procedures.

When defining a database, you can pick prefixes and suffixes for your Access Roles.

## resource_monitors

Every warehouse should be associated with a resource monitor. This group is a list of global resource monitors that aren't associated with a business unit.

Some companies do not have complicated chargeback models and only need to define a few warehouses and a few resource monitors. This location can also be used
for dba warehouses.

## role_grants

Largely exists for one-off role grants to a user where an Active Directory Group doesn't exist. Could also be used for companies that don't have Active Directory.

## users

Creates users and optionally their sandboxes based on their Active Directory Group.

## warehouses

Warehouses that aren't business unit specific. Maybe used for sandboxes or the dbas.

## projects folder

The projects folder holds a list of business unit folders.

### business unit folders

Each business unit will likely declare any resource monitors or warehouses they have that are not project specific, and they will have subfolders for each of their projects.

### business unit project folders

custom_roles: any roles that aren't managed by active directory that are custom. Likely not needed most of the time.
product_databases: databases that combine data from multiple source databases for reporting or machine learning.
resource_monitors: project-specific resource monitors
role_grants: only for use with custom_roles and likely not needed most of the time.
service_accounts: used to for systems to access Snowflake.
source_databases: databases that mirror the data from an external source system.
warehouses: warehouses that are project specific. 




# flexible-tram-model
