### Chapter 3: Managing Users and Connections

The following topics are covered in this chapter:
* Introduction to users and groups
* Managing roles
* Managing incoming connections at the role level



### Introduction to users and groups
A `role` represents a collection of database permissions and connection properties

### Managing roles
`CREATE`, `ALTER` or `DROP` a role

**Creating new roles** 
```sql
my_database=# 
CREATE ROLE evan
WITH LOGIN PASSWORD 'xxx'
VALID UNTIL '2020-12-25 23:59:59';
```

**Using a role as a group**
```sql
create role pf
with nologin;

create role kevin
with login password 'Changeme123'
in role pf;

create role tim
with login password 'Changeme123'
in role pf;

--Add members to a group using `GRANT` statement
create role dirk
with login password 'Changeme123';
grant pf to dirk;
```

**Admin**

Every group can have one or more `admin` who are allowed to add new members to the group

```sql
grant pf to kevin
with admin option;
```

**Remove an existing role**
```sql
drop role if exists kobe;
NOTICE:  role "kobe" does not exist, skipping
DROP ROLE
```
**Inspection existing roles**

Get information about what role your are running
```sql
# select current_role;
 current_role 
--------------
 evan
(1 row)
```

Describe users as well as their arrtibutes
```sql
# \du
ace=> \du
                                   List of roles
 Role name |                         Attributes                         | Member of 
-----------+------------------------------------------------------------+-----------
 dirk      |                                                            | {pf}
 evan      | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 kevin     |                                                            | {pf}
 pf        | Cannot login                                               | {}
 tim       |                                                            | {pf}
```

Get specific information from roles
```sql 
# select rolname, rolcanlogin, rolpassword from pg_roles where rolname = 'kevin';
 rolname | rolcanlogin | rolpassword 
---------+-------------+-------------
 kevin   | t           | ********
(1 row)


# select rolname, rolcanlogin, rolpassword from pg_authid where rolname = 'kevin';
 rolname | rolcanlogin |             rolpassword             
---------+-------------+-------------------------------------
 kevin   | t           | md55c9108324c37bfef6296bd3a4ec45716
(1 row)

```


### Managing incoming connections at the role level
The role has the LOGIN property is not enough for it to open a new connection to any database within the cluster. 

PostgreSQL checks the incoming connection request against a kind of firewall table, formerly know as `host-based access`, that is defined within the `pg_hba.conf` file.

| Type        | Database | User | Address | Method |
| :---------: |:---------:|:---:|:-------:|:------:|
| host     | all | luca |carmensita | scram-sha-256|
| host     | all | test |192.168.222.1/32 | scram-sha-256
| host     | digikamdb | pgwatch2 |192.168.222.4/32 | trush
| host     | digikamdb | enrico |carmensita | reject


The syntax of the above `pg_hba.conf`:
1. The user `luca` can connect to all databases via TCP/IP connection coming from a host named `carmensita`
2. The user 'test' can connect to all databases only from a machine `192.168.222.1/32`
3. The access to the `digikamdb` database is granted only to the user `pgwatch2` from the host `192.168.222.4/32` without any credential being required
4. Reject the user `enrico` to access the `digikamdb` database from a host named carmensita


Key factors:
1. **<font color = red>The order matters! The rule on the top overrule rules underneath** </font>
2. The usual workflow when dealing with `pg_hba.conf` is **modify** then **reload**

**Merging multiple rules into a single one**
The role, database, and remote-machine fields allow for the definition of multiple matches, each one separated by a `, (comma)`.