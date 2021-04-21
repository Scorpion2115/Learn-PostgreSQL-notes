# Chapter 3: Basic Statements

## The following topics are covered in this chapter:
* The topics we will talk about will be the following:
* Exploring the SELECT statement Using UPSERT
* Exploring CTEs
<br></br>

## Exploring the SELECT statement
### Using the `Like` clause
1. General use case
```sql
-- start with a
select * from categories where title like 'a%';

-- end with e
select * from categories where title like '%e';

-- contains `ap`
select * from categories where title like '%ap%';
```

2. Like searches are case-sensitive
```sql
-- this won't work as tiles are come with lower-case
select * from categories where title like 'A%';

-- use upper() function
select * from categories where upper(title) like 'A%';
```
<br></br>

### Using `iLike` Clause to solve the case-insensitive like query issue
```sql
select * from categories where title ilike 'A%';
```

### Using `coalesce`
1. given two or more parameters to coalesce function, it returns the first value that is not NULL
```sql
select coalesce(NULL,'test');
```
2. `coalesce`function can fill `null` with value you want.
```sql
select description,coalesce(description,'No description') description_fillna 
from categories 
order by 1;
```

### Using `limit` and `offset`
1. control the number of query result
```sql
-- return the 1st record only
select * from categories order by pk limit 1;

-- skip the first 7 record and return the 8th one
select * from categories order by pk offset 7 limit 1;
```

2. create an empty new table by copying structure from an existing one
```sql
create table new_categories as select * from categories limit 0; 
```

### Using `subqueries`
Nested a query into another query using parentheses
1. Using `IN/NOT IN` Conditions
``` sql
-- we can use the `IN/NOT IN` operator inside a where clause instead of using multiple OR conditions
select * from categories where pk in (10,11);

-- the same as
select * from categories where pk=10 or pk=11;

-- try nest query
select * from posts where category in (select pk from categories where title='djq');
```

2. Using `EXIST/NOT EXIST` Conditions