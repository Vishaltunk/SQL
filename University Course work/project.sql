CREATE TABLE Product
(
  productSKU CHAR (20)NOT NULL,
  Productname VARCHAR (50)NOT NULL,
  quantity INT (5)NOT NULL,
  PRIMARY KEY (productSKU)
);

CREATE TABLE Availability_
(
  sitename VARCHAR (20) NOT NULL,
  stockavailable INT (50)NOT NULL,
  siteID INT (5) NOT NULL,
  PRIMARY KEY (siteID)
);

CREATE TABLE sites
(
  productSKU CHAR (20) NOT NULL,
  siteID INT (5) NOT NULL,
  PRIMARY KEY (productSKU, siteID),
  FOREIGN KEY (productSKU) REFERENCES Product(productSKU),
  FOREIGN KEY (siteID) REFERENCES Availability_(siteID)
);

CREATE TABLE Customer
(
  CustomerID CHAR (10) NOT NULL,
  Custname VARCHAR (50) NOT NULL,
  Customerregion VARCHAR (50) NOT NULL,
  siteID INT (5) NOT NULL,
  PRIMARY KEY (CustomerID),
  FOREIGN KEY (siteID) REFERENCES Availability_(siteID)
);

CREATE TABLE Transaction
(
  TransactionID INT (5) NOT NULL,
  Date DATE NOT NULL,
  amount FLOAT NOT NULL,
  CustomerID Char (10) NOT NULL,
  PRIMARY KEY (TransactionID),
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE purchase
(
  productSKU CHAR (20) NOT NULL,
  CustomerID CHAR (10) NOT NULL,
  PRIMARY KEY (productSKU, CustomerID),
  FOREIGN KEY (productSKU) REFERENCES Product(productSKU),
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE record
(
  productSKU CHAR (20) NOT NULL,
  TransactionID INT (5) NOT NULL,
  PRIMARY KEY (productSKU, TransactionID),
  FOREIGN KEY (productSKU) REFERENCES Product(productSKU),
  FOREIGN KEY (TransactionID) REFERENCES Transaction(TransactionID)
);

INSERT INTO Product( 
        productSKU,
        Productname,
        quantity
)
VALUES
       ("7640", "Dell Inspiron 14", 100),
       ("7882", "Dell XPS 15", 120),
       ("7992", "Dell Inspiron 16", 100) ;


INSERT INTO Availability_( 
        sitename,
        stockavailable,
        siteID
)
VALUES
       ("Amazon", "50", 0101),
       ("Walmart", "100", 0202),
       ("Costco", "70", 0303) ;