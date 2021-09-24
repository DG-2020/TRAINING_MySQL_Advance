-- 1. Updating with Triggers --
USE scratch;
DROP TABLE IF EXISTS widgetCustomer;
DROP TABLE IF EXISTS widgetSale;

CREATE TABLE widgetCustomer (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(64), last_order_id INT);
CREATE TABLE widgetSale (id INT AUTO_INCREMENT PRIMARY KEY, item_id INT, customer_id INT, quan INT, price INT);

INSERT INTO widgetCustomer (name) VALUES ('Bob');
INSERT INTO widgetCustomer (name) VALUES ('Sally');
INSERT INTO widgetCustomer (name) VALUES ('Fred');

SELECT * FROM widgetCustomer;

DROP TRIGGER IF EXISTS newWidgetSale;
DELIMITER //
CREATE TRIGGER newWidgetSale AFTER INSERT ON widgetSale
FOR EACH ROW
BEGIN
UPDATE widgetCustomer SET last_order_id = NEW.id WHERE widgetCustomer.id = NEW.customer_id;
END //
DELIMITER ;

INSERT INTO widgetSale (item_id, customer_id, quan, price) VALUES (1, 3, 5, 1995);
INSERT INTO widgetSale (item_id, customer_id, quan, price) VALUES (2, 2, 3, 1495);
INSERT INTO widgetSale (item_id, customer_id, quan, price) VALUES (3, 1, 1, 2995);
SELECT * FROM widgetSale;
SELECT * FROM widgetCustomer;

SHOW triggers;
DROP trigger IF EXISTS newWidgetSale;
DROP TABLE IF EXISTS widgetCustomer;
DROP TABLE IF EXISTS widgetSale;


-- 2. Preventing Updates --
USE scratch;
DROP TABLE IF EXISTS widgetCustomer;
DROP TABLE IF EXISTS widgetSale;

CREATE TABLE widgetCustomer(id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(64), last_order_id INT);
CREATE TABLE widgetSale(id INT AUTO_INCREMENT PRIMARY KEY, item_id INT, customer_id INT, quan INT, price INT, reconciled INT);
INSERT INTO widgetSale (item_id, customer_id, quan, price, reconciled) VALUES (1, 3, 5, 1995, 0);
INSERT INTO widgetSale (item_id, customer_id, quan, price, reconciled) VALUES (2, 2, 3, 1495, 1);
INSERT INTO widgetSale (item_id, customer_id, quan, price, reconciled) VALUES (3, 1, 1, 2995, 0);

SELECT * FROM widgetSale;


DROP TRIGGER IF EXISTS updateWidgetSale;
DELIMITER //
CREATE TRIGGER updateWidgetSale BEFORE UPDATE ON widgetSale
FOR EACH ROW 
BEGIN
IF OLD.id = NEW.id AND OLD.reconciled = 1 THEN
SIGNAL SQLSTATE '45000' set message_text = 'cannot update reconciled ropw: "widgetSale';
END IF ;
END //
DELIMITER ; 

UPDATE widgetSale SET quan = 9 WHERE id = 1; 
UPDATE widgetSale SET quan = 9 WHERE id = 2;

SELECT * FROM widgetSale;

DROP TABLE IF EXISTS widgetCustomer;
DROP TABLE IF EXISTS widgetSale;


-- 3. Example: TimeStamps --
USE scratch;
DROP TABLE IF EXISTS widgetSale;
DROP TABLE IF EXISTS widgetCustomer;
DROP TABLE IF EXISTS widgetLog;

CREATE TABLE widgetCustomer(id INT AUTO_INCREMENT PRIMARY KEY, Name VARCHAR(64), Last_Order_ID INT, Stamp VARCHAR(24));
CREATE TABLE widgetSale(id INT AUTO_INCREMENT PRIMARY KEY, Item_ID INT, Customer_ID INT, Quan INT, Price INT, Stamp VARCHAR(24));
CREATE TABLE widgetLog(id INT AUTO_INCREMENT PRIMARY KEY, Stamp VARCHAR(24), Event VARCHAR(64), UserName VARCHAR(64), TableName VARCHAR(64), Table_ID INT);

INSERT INTO widgetCustomer(Name) VALUES ('Bob');
INSERT INTO widgetCustomer(Name) VALUES ('Sally');
INSERT INTO widgetCustomer(Name) VALUES ('Fred');
SELECT * FROM widgetCustomer;


DROP TRIGGER IF EXISTS stampSale;
DROP TRIGGER IF EXISTS newWidgetSale;

DELIMITER //
CREATE TRIGGER stampSale BEFORE INSERT ON widgetSale
FOR EACH ROW
BEGIN
DECLARE nowstamp VARCHAR(24) DEFAULT NOW();
SET NEW.stamp = nowstamp;
END//

CREATE TRIGGER newWidgetSale AFTER INSERT ON widgetSale
FOR EACH ROW
BEGIN
DECLARE nowstamp VARCHAR(24) DEFAULT NOW();
INSERT INTO widgetLog(Stamp, Event, UserName, TableName, Table_ID)
VALUES (nowstamp, 'INSERT', USER(), 'widgetSale', NEW.id);
UPDATE widgetCustomer SET Last_Order_ID = NEW.id, Stamp = nowstamp
WHERE widgetCustomer.id = NEW.customer_id;
END//
DELIMITER ;

INSERT INTO widgetSale (Item_ID, Customer_ID, Quan, Price) VALUES (1, 3, 5, 1995);
INSERT INTO widgetSale (Item_ID, Customer_ID, Quan, Price) VALUES (2, 2, 3, 1495);
INSERT INTO widgetSale (Item_ID, Customer_ID, Quan, Price) VALUES (3, 1, 1, 2995);

SELECT * FROM widgetSale;
SELECT * FROM widgetCustomer;
SELECT * FROM widgetLog;

-- Restore Database --
DROP TABLE IF EXISTS widgetCustomer;
DROP TABLE IF EXISTS widgetSale;
DROP TABLE IF EXISTS widgetLog;