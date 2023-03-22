-- Task #1
-- A popular candy store, with a number of regular customers of 1 million users,
-- turned to our company to create an online store.
-- You need to design a database for this store and code on SQL.
--
-- After communicating with the customer, it became clear that it would be necessary
-- to store information about Customer with the required fields: first name, last name, phone number, address, email, personal discount
--
-- Also store information about candies: name, type (chocolates, lollipops, gum), description, price and quantity.
--
-- And save the orders information to display in your personal account and collect data for analytics,
-- Order should contains customer information, the quantity and what kind of candy he ordered, order date.
-- HINT: one order can contain several different candies with a different quantity for each candy
--
-- The business analyst analyzed the market and calculated that the number of
-- various candies will be about a million with different names, the number of
-- each type of candy will be approximately the same. He also noticed that it will be
-- necessary to filter by type of candy, search by the name of the candy
-- (only search by the beginning of a word or by a complete match) and sort by price.

CREATE SCHEMA `candy_store` ;
USE `candy_store`;

CREATE TABLE `customers` (
	Customer_Id INT,
	First_Name VARCHAR(100),
    Last_Name VARCHAR(100),
    Phone_Number VARCHAR(10),
    Address VARCHAR(150),
    Email VARCHAR(100),
    Personal_Discount INT,
    PRIMARY KEY(Customer_Id)
);
CREATE TABLE `candies` (
	Name VARCHAR(100),
    Type VARCHAR(100),
    Description TEXT,
    Price FLOAT(10, 2),
    Quantity INT,
    PRIMARY KEY(Name)
);
CREATE TABLE `orders_head` (
	Order_Id INT,
    Customer_Id INT,
    PRIMARY KEY(Order_Id, Customer_Id),
    FOREIGN KEY(Customer_Id) REFERENCES customers(Customer_Id)
);
CREATE TABLE `orders_body` (
	Order_Id INT,
    Candy_Name VARCHAR(100),
    Quantity INT,
    Order_Date DATE,
    PRIMARY KEY(Order_Id, Candy_Name),
    FOREIGN KEY(Order_Id) REFERENCES orders_head(Order_Id),
    FOREIGN KEY(Candy_Name) REFERENCES candies(Name)
);

CREATE VIEW `orders` AS
	SELECT H.Order_Id, H.Customer_Id, B.Candy_Name, B.Quantity, B.Order_Date
    FROM orders_head AS H, orders_body AS B 
    WHERE H.Order_Id = B.Order_Id;

DELIMITER $$
CREATE PROCEDURE `Filter_Candy_Type` (IN Search VARCHAR(100))
BEGIN
	SELECT Name, Price FROM candy_store.candies WHERE LOCATE(Search, Type) > 0;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `Search_Candy_Name` (IN Search VARCHAR(100))
BEGIN
	SELECT Name, Type, Price, Description FROM candy_store.candies WHERE Name LIKE CONCAT(Search, '%');
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `Sort_Candy_Price` ()
BEGIN
	SELECT Name, Price FROM candy_store.candies ORDER BY Price;
END$$
DELIMITER ;

INSERT INTO candies VALUES ("Milka", "Chocolate", "This is chocolate", 5.25, 125);
INSERT INTO candies VALUES ("Lolly", "Candy", "This is a lollypop", 1, 100);
INSERT INTO candies VALUES ("Mint", "Candy", "This is a mint", 0.25, 200);
INSERT INTO candies VALUES ("Watermellon", "Gum", "This is a watermellon gum", 1.25, 180);
INSERT INTO candies VALUES ("Orbit", "Gum", "This is an Orbit gum", 1.20, 160);
INSERT INTO candies VALUES ("Trash", "Trash", "This is Trash", 0.01, 1000);
INSERT INTO candies VALUES ("food1", "food", "This is food", 0.01, 1000);
INSERT INTO candies VALUES ("food2", "food", "This is food", 0.01, 1000);
INSERT INTO candies VALUES ("food3", "food", "This is food", 0.01, 1000);
INSERT INTO candies VALUES ("food4", "food", "This is food", 0.01, 1000);
INSERT INTO candies VALUES ("food5", "food", "This is food", 0.01, 1000);
INSERT INTO candies VALUES ("food6", "food", "This is food", 0.01, 1000);
INSERT INTO candies VALUES ("food7", "food", "This is food", 0.01, 1000);

CALL Filter_Candy_Type("Candy");
CALL Search_Candy_Name("Mi");
CALL Sort_Candy_Price();

INSERT INTO customers VALUES (101, "name1", "lname1", "number1", "address1", "email1", 1);
INSERT INTO customers VALUES (102, "name2", "lname2", "number2", "address2", "email2", 2);
INSERT INTO customers VALUES (103, "name3", "lname3", "number3", "address3", "email3", 3);

INSERT INTO orders_head VALUES (001, 101);
INSERT INTO orders_head VALUES (002, 102);
INSERT INTO orders_head VALUES (003, 103);
INSERT INTO orders_head VALUES (004, 101);
INSERT INTO orders_head VALUES (005, 103);

INSERT INTO orders_body VALUES (001, "Milka", 2, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (001, "Mint", 10, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (002, "Milka", 4, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (002, "Lolly", 5, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (002, "Watermellon", 4, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (003, "Watermellon", 8, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (004, "Milka", 3, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (004, "Orbit", 1, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (005, "Lolly", 1, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (005, "Mint", 4, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (005, "Watermellon", 12, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (005, "food1", 1, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (005, "food2", 2, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (005, "food3", 3, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (005, "food4", 4, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (005, "food5", 5, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (005, "food6", 6, "2023-06-15 09:34:21");
INSERT INTO orders_body VALUES (005, "food7", 7, "2023-06-15 09:34:21");

-- ----------------------------------------------------------------------------


-- Task №2
-- Based on the previous task, write a query that returns the names and the number of ordered 10 most popular candies
-- for the current year, depending on the quantity of candies in the orders.

SELECT Candy_Name, SUM(Quantity) 
	FROM orders 
    WHERE Order_Date BETWEEN CAST("2023-01-01" AS DATE) AND CAST("2023-12-31" AS DATE) 
    GROUP BY Candy_Name
    ORDER BY SUM(Quantity) DESC
    LIMIT 10;
-- ----------------------------------------------------------------------------
