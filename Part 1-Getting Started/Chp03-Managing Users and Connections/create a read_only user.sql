--create a new user, which will turn to a user group
create role tpg_rf
with nologin;

---grant read-only previliege to the database, schema and table
GRANT CONNECT ON DATABASE mydatabase TO tpg_rf;
GRANT USAGE ON SCHEMA myschema TO tpg_rf;
GRANT SELECT ON ALL TABLES IN SCHEMA myschema TO tpg_rf;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA myschema TO tpg_rf;

--create a new user
create role evan
with login password 'Password12345'
in role tpg_rf;


--drop the user
drop owned by evan;
drop role if exists evan;