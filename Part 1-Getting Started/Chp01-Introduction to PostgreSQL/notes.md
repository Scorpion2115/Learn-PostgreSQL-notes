### Chapter 1: Introduction to PostgreSQL

The following topics are covered in this chapter:
* PostgreSQL at a glance
* Exploring PostgreSQL terminology Installing PostgreSQL 12 or higher



### PostgreSQL at a glance
PostgreSQL is fully ACID-compliant
ACID:
* Atomicity
* Consistency
* Isolation
* Durability

### Exploring PostgreSQL terminology
A postgresql instance is called a `Cluster`.

Users connected to a database cannot cross the database boundary and interact with another database, unless they explicity connect to the latter database too.

A database can be organized into namespaces, called `schema`. Schemas cannot be nested, so they represent a flat namespace.

Every database `object` belongs to one and only one schema that, if not specified, is the default `public schema`

PostgreSQL stores all contents (user data and internal status) on a somgle filesystem directory known as `PGDATA`

`Postmaster` is the first process the cluster executes.
