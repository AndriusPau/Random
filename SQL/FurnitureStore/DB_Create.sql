CREATE TABLE Furniture (
Id          INTEGER        NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 0101 INCREMENT BY 1)   ,
Name        CHAR(40)       NOT NULL                                                                 ,
Price       DECIMAL(10, 2)          CONSTRAINT Not_Negative_Price     CHECK (Price >= 0)            ,
Description CHAR(100)                                                                               ,
Size_X      INTEGER                 CONSTRAINT Not_Negative_Or_Zero_X CHECK (Size_X > 0) DEFAULT 100,
Size_Y      INTEGER                 CONSTRAINT Not_Negative_Or_Zero_Y CHECK (Size_Y > 0) DEFAULT 100,
Size_Z      INTEGER                 CONSTRAINT Not_Negative_Or_Zero_Z CHECK (Size_Z > 0) DEFAULT 100
);

CREATE TABLE Components (
Id           INTEGER   NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 0001 INCREMENT BY 1),
Name         CHAR(40)                                                                        ,
Furniture_Id INTEGER                               
);

CREATE TABLE Clients (
Id      INTEGER   NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 0501 INCREMENT BY 1),
Name    CHAR(40)  NOT NULL                                                              ,
Address CHAR(50)                             
);

CREATE TABLE Orders_Head (
Id        INTEGER   NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1001 INCREMENT BY 1),
Client_Id INTEGER   NOT NULL                    
);

CREATE TABLE Orders_Body (
Order_Id     INTEGER   NOT NULL                                                     ,
Furniture_Id INTEGER   NOT NULL                                                     ,
Amount       INTEGER   NOT NULL CONSTRAINT Not_Negative_Or_Zero   CHECK (Amount > 0) 
);



ALTER TABLE Furniture   ADD PRIMARY KEY (Id);
ALTER TABLE Components  ADD PRIMARY KEY (Id);
ALTER TABLE Clients     ADD PRIMARY KEY (Id);
ALTER TABLE Orders_Head ADD PRIMARY KEY (Id);



ALTER TABLE Components  ADD CONSTRAINT Furniture_Id FOREIGN KEY (Furniture_Id) REFERENCES Furniture
ON DELETE SET NULL
ON UPDATE CASCADE;
ALTER TABLE Orders_Body ADD CONSTRAINT Furniture_Id FOREIGN KEY (Furniture_Id) REFERENCES Furniture
ON DELETE RESTRICT
ON UPDATE CASCADE;
ALTER TABLE Orders_Body ADD CONSTRAINT Order_Id     FOREIGN KEY (Order_Id)     REFERENCES Orders_Head
ON DELETE CASCADE
ON UPDATE CASCADE;
ALTER TABLE Orders_Head ADD CONSTRAINT Client_Id    FOREIGN KEY (Client_Id)    REFERENCES Clients
ON DELETE RESTRICT
ON UPDATE RESTRICT;



CREATE UNIQUE INDEX Index_Orders_Body
ON Orders_Body (Order_Id, Furniture_Id);

CREATE INDEX Index_Furniture
ON Furniture (Name);



CREATE VIEW Order_Price (
Order_Id, Price)
AS SELECT Orders_Head.Id, SUM(Furniture.Price * Orders_Body.Amount)
	FROM Orders_Head, Orders_Body, Furniture
	WHERE Orders_Head.Id = Orders_Body.Order_Id
		AND Orders_Body.Furniture_Id = Furniture.Id
		GROUP BY Orders_Head.Id
		ORDER BY Orders_Head.Id;

CREATE VIEW Furniture_Components (
Furniture_Id, Furniture_Name, Components_Id, Components_Name)
AS SELECT Furniture.Id, Furniture.Name, Components.Id, Components.Name
	FROM Furniture, Components
	WHERE Components.Furniture_Id = Furniture.Id
	ORDER BY Components.Furniture_Id;



CREATE VIEW Orders (
Client_Id, Order_Id, Furniture_Id, Amount)
AS SELECT Client_Id, Id, Furniture_Id, Amount
	FROM Orders_Head, Orders_Body
	WHERE Orders_Head.Id = Orders_Body.Order_Id
	ORDER BY Client_Id;




CREATE FUNCTION Furniture_Already_In_Order()
RETURNS TRIGGER AS 
$$
	BEGIN 
		IF (
			EXISTS(
				SELECT * 
					FROM Orders_Body 
					WHERE Orders_Body.Order_Id = NEW.Order_Id 
					AND Orders_Body.Furniture_Id = NEW.Furniture_Id))
		THEN RAISE EXCEPTION 'The furniture is already in the order. You can change the amount in the order.';
		END IF;
		RETURN NEW;
	END; 
$$
LANGUAGE plpgsql;

CREATE TRIGGER Trigger_Furniture_Already_In_Order
BEFORE UPDATE OR INSERT ON Orders_Body
FOR EACH ROW
EXECUTE PROCEDURE Furniture_Already_In_Order();


CREATE FUNCTION Furniture_Has_No_Components()
RETURNS TRIGGER AS 
$$
	BEGIN 
		IF (
			NOT EXISTS(
			SELECT *
				FROM Components
				WHERE (Components.Furniture_Id = NEW.Furniture_Id)))
		THEN RAISE EXCEPTION 'This furniture cannot be ordered right now.';
		END IF;
		RETURN NEW;
	END; 
$$
LANGUAGE plpgsql;

CREATE TRIGGER Trigger_Furniture_Has_No_Components
BEFORE UPDATE OR INSERT ON Orders_Body
FOR EACH ROW
EXECUTE PROCEDURE Furniture_Has_No_Components();


INSERT INTO Furniture (Name, Price, Description, Size_X, Size_Y, Size_Z)
VALUES ('Table'      , 150, 'This is a Table'      , 100, 100, 100);
INSERT INTO Furniture (Name, Price, Description, Size_X, Size_Y, Size_Z)
VALUES ('Chair'      , 50 , 'This is a Chair'      , 50 , 100, 50 );
INSERT INTO Furniture (Name, Price, Description, Size_X, Size_Y, Size_Z)
VALUES ('Nightstand' , 75 , 'This is a Nightstand' , 40 , 50 , 100);
INSERT INTO Furniture (Name, Price, Description, Size_X, Size_Y, Size_Z)
VALUES ('Wardrobe'   , 250, 'This is a Wardrobe'   , 100, 200, 150);
INSERT INTO Furniture (Name, Price, Description, Size_X, Size_Y, Size_Z)
VALUES ('Drawers'    , 50 , 'This is a Drawers'    , 100, 120, 40 );

INSERT INTO Components (Name, Furniture_Id)
VALUES ('Table Leg'                   , 101);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Table Board'                 , 101);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Chairs Leg'                  , 102);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Chairs Seat Board'           , 102);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Chairs Armrest Board'        , 102);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Nightstand Bottom/Top Board' , 103);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Nightstand Side Board'       , 103);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Nightstand Back Board'       , 103);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Nightstand Door'             , 103);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Wardrobe Bottom Board'       , 104);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Wardrobe Top Board'          , 104);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Wardrobe Side Board'         , 104);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Wardrobe Back Board'         , 104);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Wardrobe Door'               , 104);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Drawers Wheels'              , 105);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Drawers Bottom Board'        , 105);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Drawers Top Board'           , 105);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Drawers Back Board'          , 105);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Drawers Side Board'          , 105);
INSERT INTO Components (Name, Furniture_Id)
VALUES ('Drawers Drawers'             , 105);

INSERT INTO Clients (Name, Address)
VALUES ('IKEA'             , 'Sweden');
INSERT INTO Clients (Name, Address)
VALUES ('Ashley Furniture' , 'Alaska');
INSERT INTO Clients (Name, Address)
VALUES ('Wayfair'          , 'Online');
INSERT INTO Clients (Name, Address)
VALUES ('Article'          , 'Online');
INSERT INTO Clients (Name, Address)
VALUES ('Joybird'          , 'Online');

INSERT INTO Orders_Head (Client_Id)
VALUES (0501);
INSERT INTO Orders_Head (Client_Id)
VALUES (0501);
INSERT INTO Orders_Head (Client_Id)
VALUES (0503);
INSERT INTO Orders_Head (Client_Id)
VALUES (0505);
INSERT INTO Orders_Head (Client_Id)
VALUES (0505);
INSERT INTO Orders_Head (Client_Id)
VALUES (0505);

INSERT INTO Orders_Body
VALUES (1001, 0104, 2 );
INSERT INTO Orders_Body
VALUES (1002, 0101, 1 );
INSERT INTO Orders_Body
VALUES (1002, 0102, 2 );
INSERT INTO Orders_Body
VALUES (1003, 0102, 2 );
INSERT INTO Orders_Body
VALUES (1004, 0105, 1 );
INSERT INTO Orders_Body
VALUES (1005, 0101, 4 );
INSERT INTO Orders_Body
VALUES (1005, 0102, 12);
INSERT INTO Orders_Body
VALUES (1005, 0104, 4 );
INSERT INTO Orders_Body
VALUES (1005, 0105, 8 );
INSERT INTO Orders_Body
VALUES (1006, 0103, 2 );


REFRESH MATERIALIZED VIEW Orders;
