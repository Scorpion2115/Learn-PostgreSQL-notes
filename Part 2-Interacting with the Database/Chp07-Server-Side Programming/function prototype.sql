
-- SQL Prototype 1
CREATE OR REPLACE FUNCTION my_sum(x integer, y integer) 
RETURNS integer AS
$$
SELECT x + y; 
$$ 
LANGUAGE SQL;

-- SQL Prototype 2
CREATE OR REPLACE FUNCTION your_sum(integer, integer) 
RETURNS integer AS 
$$
SELECT $1 + $2;
$$ 
LANGUAGE SQL;


-- PL/pgSQL Prototype 1
CREATE OR REPLACE FUNCTION my_sum(x integer, y integer) 
RETURNS integer AS
$BODY$
DECLARE ret integer;
BEGIN ret := x + y;
RETURN ret;
END;
$BODY$
LANGUAGE 'plpgsql';

-- PL/pgSQL Prototype 2
CREATE OR REPLACE FUNCTION my_sum(integer, integer) 
RETURNS integer AS
$BODY$
DECLARE
    x alias for $1;
    y alias for $2;
    ret integer;
BEGIN
    ret := x + y;
RETURN 
	ret;
END;
   $BODY$
LANGUAGE 'plpgsql';


-- PL/pgSQL Prototype 3
CREATE OR REPLACE FUNCTION my_sum(integer, integer) 
RETURNS integer AS
$BODY$
DECLARE ret integer;
BEGIN ret := $1 + $2;
RETURN ret;
END;
$BODY$
LANGUAGE 'plpgsql';

-- PL/pgSQL Prototype 4
CREATE OR REPLACE FUNCTION my_sum(IN x integer,IN y integer, OUT z integer) AS
$BODY$
BEGIN
z := x+y; 
END;
$BODY$
LANGUAGE 'plpgsql';
