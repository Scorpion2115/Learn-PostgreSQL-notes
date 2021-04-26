-- insert data into a table
insert into categories (title,description) values ('apple', 'fruits'), ('orange','fruits'),('lettuce','vegetable');

insert into categories (title) values ('lemon');

insert into categories (title,description) values ('apricot','fruits');


insert into tags (tag,parent) values ('fruits',NULL);
insert into tags (tag,parent) values ('vegetables',NULL);

insert into j_posts_tags values(1,2);
insert into j_posts_tags values(1,3);

