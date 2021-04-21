insert into users (username,gecos,email) values ('myusername','mygecos','myemail');
insert into users (username,gecos,email) values ('scotty','scotty_gecos','scotty_email');

insert into categories (title,description) values ('apple', 'fruits'), ('orange','fruits'),('lettuce','vegetable');
insert into categories (title) values ('lemon');
insert into categories (title,description) values ('apricot','fruits');
insert into categories (title,description) values ('jp', 'pg'), ('zx','guard'),('djq','pg');
insert into categories (title,description) values ('zx','sg');
insert into categories (title,description) values ('ll', 'sf'), ('jl', 'sf'), ('lc','sf');
insert into categories (title,description) values ('wl', 'pf'), ('zy','pf');
insert into categories (title,description) values ('cz', 'c'), ('fy','c');


insert into posts(title,content,author,category) values('my orange','my orange is the best orange in the world',1,11);
insert into posts(title,content,author,category) values('my apple','my apple is the best orange in the world',1,10);
insert into posts(title,content,author,category,reply_to) values('Re:my orange','No! It''s my orange the best orange in the world',2,11,2);
insert into posts(title,content,author,category) values('my tomato','my tomato is the best orange in the world',2,12);