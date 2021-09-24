-- 1. Data Integrity --
USE scratch;
DROP TABLE IF EXISTS widgetInventory;
DROP TABLE IF EXISTS widgetSales;

CREATE TABLE widgetInventory(
ID INT AUTO_INCREMENT PRIMARY KEY,
Description TEXT,
OnHand INT NOT NULL);

CREATE TABLE widgetSales(
ID INT AUTO_INCREMENT PRIMARY KEY,
Inv_ID INT,
Quan INT,
Price INT);

INSERT INTO widgetInventory(Description, OnHand) VALUES ('Rock', '25');
INSERT INTO widgetInventory(Description, OnHand) VALUES ('Paper', '25');
INSERT INTO widgetInventory(Description, OnHand) VALUES ('Scissirs', '25');
SELECT * FROM widgetInventory;

START TRANSACTION;
INSERT INTO widgetSales(Inv_ID, Quan, Price) VALUES (1, 5, 500);
UPDATE widgetInventory SET OnHand = (OnHand - 5) WHERE ID = 1;
COMMIT;
SELECT * FROM widgetSales;
SELECT * FROM widgetInventory;

SELECT TRANSACTION;
INSERT INTO widgetInventory (Description, OnHand) VALUES ('Toy', 25);
ROLLBACK;
SELECT * FROM widgetSales;
SELECT * FROM widgetInventory;

-- Restore DataBase --
DROP TABLE widgetSales;
DROP TABLE widgetInventory;


-- 2. Performance--
USE scratch;
DROP TABLE IF EXISTS test;
DROP PROCEDURE IF EXISTS insert_loop;

CREATE TABLE test (id INT AUTO_INCREMENT PRIMARY KEY, DATA TEXT);

DELIMITER //
CREATE PROCEDURE insert_loop(IN count INT unsigned)
BEGIN
DECLARE accum INT UNSIGNED DEFAULT 0;
DECLARE start_time VARCHAR(32);
DECLARE end_time VARCHAR(32);
SET start_time = sysdate(6);
WHILE accum < count DO
SET accum = accum + 1;
INSERT INTO test (data) VALUES ('this is a good sized line of text.');
END WHILE ;
SET end_time = sysdate(6);
SELECT time_format(start_time, '%T.%f') AS 'Start',
time_format(end_time, '%T.%f') AS 'End',
time_format(timediff(end_time, start_time), '%s.%f') AS 'Elapsed Secs';
END //
DELIMITER ; 

START TRANSACTION;
CALL insert_loop(10000);
COMMIT; 

SELECT * FROM test ORDER BY id DESC LIMIT 10;

DROP TABLE IF EXISTS test;
DROP PROCEDURE IF EXISTS insert_loop;
