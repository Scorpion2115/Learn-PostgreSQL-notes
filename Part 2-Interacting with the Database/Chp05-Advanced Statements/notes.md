# Chapter 5: Advanced Statements

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

3. Using `EXIST/NOT EXIST` Conditions
Check whether a subquery returns TRUE or FALSE
``` sql
-- You can add multiple conditions in the where exist clause.
-- The conditions can be either a simple logic or a query
select pk,title,content,author,category from posts where exists
(select 21 from categories where title ='orange' and posts.category=11)
```

### Learning UPSERTS
An `upsert` statement is used when we want to insert a new record on top of the existing record or update an existing record

1. Add constraints to the table and query the original table
```sql
alter table j_posts_tags 
add constraint j_posts_tags_pkey 
primary key (tag_pk, post_pk);

select * from j_posts_tags 
```

 tag_pk | post_pk
-------- | --------- 
1|2
1|3


2. Use `ON CONFLICT DO NOTHING` clause
```sql
insert into j_posts_tags values(1,2) ON CONFLICT DO NOTHING;
```
 tag_pk | post_pk
-------- | --------- 
1|2
1|3

3. Try apply for an update logic
```sql
insert into j_posts_tags values(1,2) ON CONFLICT (tag_pk,post_pk) DO UPDATE set tag_pk=excluded.tag_pk+1;
```
 tag_pk | post_pk
-------- | --------- 
1|3
**2**|2

### Learning the RETURNING clause for INSERT
The `RETURN` keyword provides an opportunity to return values of any column from `INSERT` or `UPDATE` statement after they are run

1. Return all
```sql
insert into j_posts_tags values(3,5) ON CONFLICT (tag_pk,post_pk) DO UPDATE SET tag_pk=excluded.tag_pk returning *;
```
tag_pk | post_pk
-------- | --------- 
3|5

### CTE (Common Table Expression)
A CTE is a temporary result taken from a SQL statement. 

This statement can contain SELECT, INSERT, UPDATE, or DELETE instructions. 

The lifetime of a CTE is equal to the lifetime of the query.

```sql
--Query an posts from scotty using a inline view
select t.pk, t.title from
(select p.*, u.username 
from posts p
inner join users u
on p.author = u.pk
where username='scotty') t

--Perform the same query using CTE
with posts_author_1 as
(select p.*, u.username 
from posts p
inner join users u
on p.author = u.pk
where username='scotty')
select pk, title from posts_author_1;
```

1. CTE example one: record a deletion
* We want to delete some records from the posts table, and 
* We want all the records that we have deleted from the t_posts table to be inserted into the delete_posts table. 

1.1 Preparation
```sql
drop table if exists t_posts;
create temp table t_posts as select * from posts;
create table delete_posts as select * from posts limit 0;
```

2.1 Delete all posts under category 11
```sql
with del_posts as (
delete from t_posts
where category in (select pk from categories where description
='pg')
returning *)
insert into delete_posts select * from del_posts;
```

2.  CTE example two: record an update
* We want to perform a query that moves, in the same transaction, all records from `t_posts` to `inserted_posts`

2.1 Preparation
```sql
drop table if exists t_posts;
create temp table t_posts as select * from posts;
create table inserted_posts as select * from posts limit 0;
```

2.2 Perform the table Transaction
```sql
with ins_posts as 
( insert into inserted_posts select * from t_posts returning *) 
delete from t_posts where pk in (select pk from ins_posts);
```

3. Recursive CTE
CTE work excellent on `tree hierarchy`, such as recursive
Recursive allows a table join itself with previous results

```sql
select * from tags
```


* What we have now is:
    pk | tag        | parent
   ----|------------|--------
     1 | fruits     |
     2 | vegetables |
     3 | apple      | 1

* What we want is:
    level | tag        
   ----|------------
     1 | fruits     |
     1 | vegetables |
     2 | fruits -> apple |

```sql
WITH RECURSIVE tags_tree AS
( -- non recursive statement
SELECT tag, pk, 1 "level"
FROM tags WHERE parent IS NULL
UNION
  -- recursive statement
SELECT tt.tag|| '->'||ct.tag, ct.pk, tt.level + 1
FROM tags ct
JOIN tags_tree tt ON tt.pk = ct.parent
)
SELECT level,tag FROM tags_tree;
```


