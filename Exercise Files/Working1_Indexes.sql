SELECT 'Hello, World';

USE world;
SHOW tables;

USE scratch;
SHOW tables;

USE album;
SELECT 
    *
FROM
    album;


-- 1.Creating an Index --
USE scratch;
DROP TABLE IF EXISTS test;
CREATE TABLE test (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    string1 VARCHAR(128) UNIQUE,
    string2 VARCHAR(128)
);
CREATE INDEX i_str2 ON test(string2);
SHOW INDEX FROM test;
DROP TABLE test;


-- 2.Showing Indexes --
USE scratch;
SHOW INDEX FROM customer;

SELECT DISTINCT
    table_name, index_name
FROM
    information_schema.statistics
WHERE
    table_schema = 'scratch';


-- 3.Dropping Indexes --
USE scratch;
DESCRIBE customer;
SHOW INDEX FROM customer;
CREATE INDEX custzip ON customer(zip);
SHOW INDEX FROM customer;
 
DROP INDEX custzip ON customer;
SHOW INDEX FROM customer;


-- 4.Multicolumn Indexes --
USE scratch;
DROP TABLE IF EXISTS test;

CREATE TABLE test(
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
string1 VARCHAR(128),
string2 VARCHAR(128),
INDEX twostrs (string1, string2)
);

INSERT INTO test(string1, string2) VALUES ('foo', 'bar'), ('this', 'that'), ('another', 'row'), ('foo', 'alphs');
SELECT 
    string1, string2
FROM
    test
ORDER BY string1 , string2;

SHOW INDEX FROM test;

SELECT 
    string1, string2
FROM
    test
ORDER BY 1 , 2;

SHOW INDEX FROM test;
EXPLAIN SELECT string1, string2 FROM test ORDER BY 1, 2;
DROP TABLE test;