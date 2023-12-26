create TABLE Homes
(
  HomeID char (10) NOT NULL,
  Hometype varchar (60) NULL,
  HomeDescription varchar(200) Null,
  Price int (11) not null,
  Dateavailable date null, 
  NumberofBeds int(11) null, 
  AgentID char(10) null,
  PRIMARY KEY (HomeID)
);

INSERT INTO homes ( 
        HomeID,
        Hometype ,
		HomeDescription,
		Price,
		Dateavailable ,
		NumberofBeds ,
		AgentID 
)
VALUES
       ("X2346573", "Single Family", "Great location, at reasonable",2100, "2023-07-10", 3, 1272);

      
SELECT HomeID, Hometype, HomeDescription, 
       Price * 0.9 AS AdjustedPrice,
       Dateavailable, NumberofBeds, AgentID
FROM homes
WHERE Dateavailable > '2023-10-01' AND Price > 2000;
