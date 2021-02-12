### Chapter 2: Getting to Know Your Cluster

The following topics are covered in this chapter:
* Managing your cluster
* Connecting to the cluster
* Exploring the disk layout of PGDATA 
* Exploring configuration files and parameters



### Managing your cluster
`pg_ctl` allows you to initialize, start, restar and stop the cluster.

**Check the status**

```shell
$ pg_ctl -D /usr/local/var/postgres status

pg_ctl: server is running (PID: 1496)
/usr/local/Cellar/postgresql/13.1/bin/postgres "-D" "/usr/local/var/postgres"
```

**Start and Stop**

```shell
$ pg_ctl -D /usr/local/var/postgres start

$ pg_ctl -D /usr/local/var/postgres stop

$ pg_ctl -D /usr/local/var/postgres stop -m smart/fast/immediate
```
Stop Mode:
* The `smart` mode means that the PostgreSQL cluster will gently wait for all the connected clients to disconnect and only then it will shut the cluster down.
* The `fast` mode will immediately disconnect every client and will shut down the server without having to wait.
* The `immediate` mode will abort every PostgreSQL process, including client connections, and shut down the cluster in a dirty way, meaning that data integrity is not guaranteed and the server needs a crash recovery at start up time.


**PostgreSQL processes**
``` shell
$ pstree pid 1496

-+= 01496 evan /usr/local/opt/postgresql/bin/postgres -D /usr/local/var/postgres
 |--= 01548 evan postgres: checkpointer   
 |--= 01549 evan postgres: background writer   
 |--= 01550 evan postgres: walwriter   
 |--= 01551 evan postgres: autovacuum launcher   
 |--= 01553 evan postgres: stats collector   
 |--= 01554 evan postgres: logical replication launcher   
 |--= 21295 evan postgres: evan postgres ::1(61750) idle  
 |--= 21296 evan postgres: evan postgis_cookbook ::1(61755) idle  
 |--= 21297 evan postgres: evan ace ::1(61758) idle  
 |--= 21402 evan postgres: evan ace ::1(62042) idle  
 |--= 29892 evan postgres: evan rome ::1(56851) idle  
 \--= 31603 evan postgres: evan ace 127.0.0.1(55284) idle  
```

### Connecting to the cluster
**The template database**

Command to inspect available databases 
```shell
$ psql -l

  List of databases
       Name       | Owner | Encoding | Collate | Ctype | Access privileges 
------------------+-------+----------+---------+-------+-------------------
 ace              | evan  | UTF8     | C       | C     | 
 postgis_cookbook | evan  | UTF8     | C       | C     | 
 postgres         | evan  | UTF8     | C       | C     | 
 rome             | evan  | UTF8     | C       | C     | 
 template0        | evan  | UTF8     | C       | C     | =c/evan          +
                  |       |          |         |       | evan=CTc/evan
 template1        | evan  | UTF8     | C       | C     | =c/evan          +
                  |       |          |         |       | evan=CTc/evan
(6 rows)
```

Factors of templates:
* The `template1` database is the first database created when the system is initialized, and then it is cloned into `template0`.
* You cannot connect to `template0`, because it acts as a safe copy.
* When you create a new database, PostgreSQL clones `template1` database as a **common base**
* Nevertheless, you are not forced to use `template1`. You can create your own databases and use them as template for other databases.
* The cluster can work without the template databases `template1` and `template0`. However, if you lost the templates, you will be required to nominate a template every time you perform relvant actions.

**The psql command-line client**

psql accepts several options to connect to a database, mainly the following:
* `-d`: The database name
* `-U`: The username
* `-h`: The host (either an IPv4 or IPv6 address or a hostname)
* `-p`: The port


list all available databases on the ubuntu server
```shell
$ psql -U postgres -h 10.224.44.127 -p 30050 -l
Password for user postgres: 
                              List of databases
   Name    |  Owner   | Encoding | Collate |  Ctype  |   Access privileges   
-----------+----------+----------+---------+---------+-----------------------
 DSA7      | postgres | UTF8     | C.UTF-8 | C.UTF-8 | 
 gis       | postgres | UTF8     | C.UTF-8 | C.UTF-8 | 
 postgres  | postgres | UTF8     | C.UTF-8 | C.UTF-8 | 
 template0 | postgres | UTF8     | C.UTF-8 | C.UTF-8 | =c/postgres          +
           |          |          |         |         | postgres=CTc/postgres
 template1 | postgres | UTF8     | C.UTF-8 | C.UTF-8 | =c/postgres          +
           |          |          |         |         | postgres=CTc/postgres
 tpg_gis   | postgres | UTF8     | C.UTF-8 | C.UTF-8 | tpg_rf=c/postgres
(6 rows)
```

List and then connect to one database
```shell
$ psql -U evan -d ace
psql (13.1)
Type "help" for help.

ace=# 

$ pstree pid 1496
-+= 01496 evan /usr/local/opt/postgresql/bin/postgres -D /usr/local/var/postgres
 |--= 01548 evan postgres: checkpointer   
 |--= 01549 evan postgres: background writer   
 |--= 01550 evan postgres: walwriter   
 |--= 01551 evan postgres: autovacuum launcher   
 |--= 01553 evan postgres: stats collector   
 |--= 01554 evan postgres: logical replication launcher   
 |--= 21295 evan postgres: evan postgres ::1(61750) idle  
 |--= 21296 evan postgres: evan postgis_cookbook ::1(61755) idle  
 |--= 21297 evan postgres: evan ace ::1(61758) idle  
 |--= 21402 evan postgres: evan ace ::1(62042) idle  
 |--= 29892 evan postgres: evan rome ::1(56851) idle  
 |--= 31603 evan postgres: evan ace 127.0.0.1(55284) idle  
 |--= 35354 evan postgres: evan ace 127.0.0.1(51090) idle  
 |--= 35355 evan postgres: evan ace 127.0.0.1(51107) idle  
 \--= 36420 evan postgres: evan ace [local] idle  
```
This last record `\--= 36420 evan postgres: evan ace [local] idle` means a user is connecting to a database


### Exploring the disk layout of PGDATA
All of the PostgreSQL-related stuff is contained in a directory known as `PGDATA`

```sql
SHOW data_directory;
/usr/local/var/postgres
```

```shell
$ ls
PG_VERSION		pg_dynshmem		pg_multixact		pg_snapshots		pg_tblspc		postgresql.auto.conf
base			pg_hba.conf		pg_notify		pg_stat			pg_twophase		postgresql.conf
global			pg_ident.conf		pg_replslot		pg_stat_tmp		pg_wal			postmaster.opts
pg_commit_ts		pg_logical		pg_serial		pg_subtrans		pg_xact			postmaster.pid
```

**Objects in the PGDATA directory**

`base` is a directory that contains all the users' data

Every file is name after a numberic identifier named `OID`(**Object Identifier** or **filenode**). Execute the odi2name utility to get a list of available databases:
* -d: speficy a table name
* -f: specicy a filenode

```shell
$ oid2name
All databases:
    Oid     Database Name  Tablespace
-------------------------------------
  45349               ace  pg_default
  16384  postgis_cookbook  pg_default
  13709          postgres  pg_default
  17626              rome  pg_default
  13708         template0  pg_default
      1         template1  pg_default

```

```shell
$ oid2name -d ace
From database "ace":
  Filenode                  Table Name
--------------------------------------
     46383                  auth_group
     46393      auth_group_permissions
     46375             auth_permission
     46401                   auth_user
     46411            auth_user_groups
     46419  auth_user_user_permissions
     46479            django_admin_log
     46365         django_content_type
     46354           django_migrations
     46510              django_session
     46554           reporter_counties
     46529         reporter_incidences
     46601             site_status_msl
     46542             site_status_poi
     45655             spatial_ref_sys
```

```shell
$ oid2name -d ace -f 46542
From database "ace":
  Filenode       Table Name
---------------------------
     46542  site_status_poi

```

PostgreSQL does not allow a single file to be greater than 1GB. In case a table grows beyong the limit, the table will be stored in chunks whose filenode are named as:
* 123
* 123.1
* 123.2
* ...

**Tablespaces**

PostgreSQL allows "escaping" the PGDATA directory by means of `tablespaces`. 

A tablespace is a sotrage space that ba can outside the PGDATA directory. PostgreSQL provides the `TABLESPACE` feature to manage this
```shell
$ oid2name -s
All tablespaces:
   Oid  Tablespace Name
-----------------------
  1663       pg_default
  1664        pg_global

```
