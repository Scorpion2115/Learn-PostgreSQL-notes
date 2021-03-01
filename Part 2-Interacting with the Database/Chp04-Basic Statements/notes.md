# Chapter 3: Basic Statements

## The following topics are covered in this chapter:
* Setting up the development environment
* Creating and managing databases
* Managing tables
* Understand basic table manipulation statements


## Setting up the development environment
### Basic Functions
* Connect to psql environment

```sql
psql
```

* Enable the Expanded display
```sql
\x
```

* List all databases
```sql
\l
```

* Connect the one database
```sql
\c forumdb
```

* Show all tables in the current database
```sql
\d
```
## Create and managing databases
### Making a new database from a modified template
* Connect to the template1 database
```sql
\c template1
```

* Create a table called dummytable. Then any changes made to the template1 will be presented in all databases created after this change!
```sql
create table dummytable (dummyfield integer not null primary key);
```

* Create a dummy database to verify the template
```sql
create database dummy;
\c dummy
You are now connected to database "dummy" as user "evan".

\d
          List of relations
 Schema |    Name    | Type  | Owner 
--------+------------+-------+-------
 public | dummytable | table | evan
(1 row)
```

* Drop tables and databases
```sql
\c template1
drop table dummytable;

drop database dummy;
```

### Making a database copy
* Make a copy of the forumdb database
```sql
create database forumdb2 template forumdb;
```

### Confirming the database size
* psql method
```sql
\l+ you-konw-who
```
* SQL method
```sql
select pg_database_size('you-know-who');


select pg_size_pretty(pg_database_size('you-know-who'));
```
## Managing tables
### Three types of tables:
1. `Temporary tables`:fast, visible only to the user who created them
2. `Unlogged tables`:very fast, common to all users
3. `Logged tables`: regular tables
### The EXISTS option
The `EXISTS` option can be used in conjunction with entity create or drop commands to check whether the object already exists or the object doesn't exist.
```sql
create table if not exists mytable;

drop table if exists mytable;
```
### Managing temporary tables


## Understand basic table manipulation statements
haha
