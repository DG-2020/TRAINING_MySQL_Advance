-- 1. Creating Foreign Key Constraints --
USE scratch;
DROP TABLE IF EXISTS widgetSale;
DROP TABLE IF EXISTS widgetCustomer;

CREATE TABLE widgetCustomer (ID INT AUTO_INCREMENT PRIMARY KEY, Name VARCHAR(64));
CREATE TABLE widgetSale (ID INT AUTO_INCREMENT PRIMARY KEY, Item_ID INT, Customer_ID INT, Quan INT, Price INT,
INDEX CustID(Customer_ID),
CONSTRAINT CustID FOREIGN KEY CustID(Customer_ID) REFERENCES widgetCustomer(ID)
ON UPDATE CASCADE -- RESTRICT -- SET NULL -- 
ON DELETE SET NULL );

INSERT INTO widgetCustomer(Name) VALUES ('Bob'), ('Sally'), ('Fred');
INSERT INTO widgetSale(Item_ID, Customer_ID, Quan, Price) VALUES (1, 3, 5, 1995), (2, 2, 3, 1495), (3, 1, 1, 2995);

UPDATE widgetCustomer SET ID = 9 WHERE ID = 2;

SELECT * FROM widgetSale;
SELECT * FROM widgetCustomer;


-- 2. Deleting & Changing Foreign Keys --
USE scratch;
SELECT * FROM widgetSale;
SELECT * FROM widgetCustomer;

ALTER TABLE widgetSale DROP FOREIGN KEY CustID;
ALTER TABLE widgetCustomer ADD CONSTRAINT CustID
FOREIGN KEY (Customer_ID) REFERENCES widgetCustomer(ID)
ON UPDATE RESTRICT 
ON DELETE SET NULL;

UPDATE widgetCustomer SET ID = 2 WHERE ID = 9;
SELECT * FROM widgetSale;
SELECT * FROM widgetCustomer;

