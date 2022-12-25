CREATE DATABASE Home_Insurance;

USE Home_Insurance;

CREATE TABLE PolicyHolder(
P_HolderId INT PRIMARY KEY,
FullName VARCHAR(30),
Mobile_No VARCHAR(10),  
HouseNo INT,
DOB DATE
);

CREATE TABLE House(
HouseNo INT PRIMARY KEY,
HouseType VARCHAR(10),
HouseAddress VARCHAR(30),
Colour VARCHAR(10)
);

CREATE TABLE HomePolicy(
PolicyNo INT PRIMARY KEY,
PropertyNo INT,
Premium INT,  
PolicyLimit INT,
Validity DATE
);

CREATE TABLE Damages(
ReportNo INT PRIMARY KEY,
DamageType VARCHAR(10),
DamageDate DATE
);

CREATE TABLE Payment(
PaymentId INT PRIMARY KEY,
Amount INT,
TransactionDate DATE
);

-- 2(A)
-- Policy Holder Names
INSERT INTO PolicyHolder(P_HolderId,FullName,Mobile_No,HouseNo,DOB) 
VALUES (1101,'Tusshar Singh','9667978357',4,'2002-11-13');
INSERT INTO PolicyHolder VALUES (1102,'Aman Rathore','916127457',1,'2001-07-27');
INSERT INTO PolicyHolder VALUES (1103,'Nishant Shrinetra','7607209456',3,'2002-10-30');
INSERT INTO PolicyHolder VALUES (1104,'Chetan Choudhary','7978434258',2,'2003-09-05');

-- Houses Description
INSERT INTO House(HouseNo,HouseType,HouseAddress,Colour) 
VALUES (1,'Bunglow','Vaishali','White');
INSERT INTO House VALUES (2,'Mansion','Indrapuram','Brown');
INSERT INTO House VALUES (3,'Villa','Kaushambi','Yellow');
INSERT INTO House VALUES (4,'Apartment','Kaushambi','Blue');

-- Policy Info
INSERT INTO HomePolicy(PolicyNo,PropertyNo,Premium,PolicyLimit,Validity) 
VALUES (2101,4,75000,100000,'2030-10-20');
INSERT INTO HomePolicy VALUES (2102,1,125000,200000,'2033-09-30');
INSERT INTO HomePolicy VALUES (2103,3,65000,90000,'2035-12-11');
INSERT INTO HomePolicy VALUES (2104,2,50000,80000,'2028-05-20');

-- Damages Incurred
INSERT INTO Damages(ReportNo,DamageType,DamageDate) 
VALUES (1,'Burglary','2027-10-20');
INSERT INTO Damages VALUES (2,'Theft','2028-07-15');
INSERT INTO Damages VALUES (3,'Fire','2028-08-01');
INSERT INTO Damages VALUES (4,'Earthquake','2029-11-08');

-- Payments Claimed By Policy Holder
INSERT INTO Payment(PaymentId,Amount,TransactionDate) 
VALUES (2102,180000,'2027-11-12');
INSERT INTO Payment VALUES (2104,65000,'2028-10-20');
INSERT INTO Payment VALUES (2103,80000,'2028-09-15');
INSERT INTO Payment VALUES (2101,90000,'2029-12-23');

-- 2(B)
SELECT * FROM PolicyHolder;
SELECT * FROM House;
SELECT * FROM HomePolicy;
SELECT * FROM Damages;
SELECT * FROM Payment;

-- 3(A)
UPDATE PolicyHolder
SET Mobile_No='9319314567' WHERE P_HolderId='1103';
SELECT * FROM PolicyHolder;

UPDATE House
SET HouseType='Villa' WHERE HouseNo='1';
SELECT * FROM House;
COMMIT;

-- 3(B)
DELETE FROM PolicyHolder
WHERE P_HolderId='1103';
SELECT * FROM PolicyHolder;
ROLLBACK;

-- 4(A)
SELECT * FROM HomePolicy
ORDER BY Premium ASC;

-- 4(B)
SELECT COUNT(HouseType) AS TotalHomes,HouseAddress
FROM House
GROUP BY HouseAddress;

-- 5(A)
COMMIT;

-- 5(B)
DELETE from House Where HouseAddress='Kaushambi'; 
SELECT * FROM House; 
ROLLBACK; 
SELECT * FROM House; 

-- 5(C)
SELECT Home.HouseNo,Home.HouseType,Home.HouseAddress,HomePolicy.PolicyLimit,HomePolicy.Validity
FROM Home
INNER JOIN HomePolicy ON Home.HouseNo=HomePolicy.PropertyNo;

-- 6(A)
ALTER TABLE PolicyHolder ADD Gender VARCHAR(6);
SELECT * FROM PolicyHolder;
ALTER TABLE PolicyHolder DROP Gender;
SELECT * FROM PolicyHolder;

-- 6(B)
SHOW TABLES;
ALTER TABLE House RENAME TO Home;
SHOW TABLES;
COMMIT;

-- 6(C)
SELECT DATE(DOB) FROM PolicyHolder;
TRUNCATE TABLE Damages;
SELECT * FROM Damages;
ROLLBACK;

-- 7(A) & 7(B)
SELECT Premium,PolicyLimit FROM HomePolicy;

-- 7(C)
ALTER TABLE HomePolicy
ADD CHECK(PolicyLimit <= 200000);
SELECT * FROM HomePolicy;

ALTER TABLE Home
ALTER Colour SET DEFAULT 'White';
SELECT * FROM Home;

-- 8(A)
SELECT * FROM HomePolicy
ORDER BY PolicyLimit ASC;

-- 8(B)
DELIMITER $$ 

Create TRIGGER Location_Set  
BEFORE INSERT ON Home FOR EACH ROW  
BEGIN  
    IF NEW.HouseAddress = 'Kaushambi' THEN SET NEW.HouseAddress = 'AnandVihar';  
    END IF;  
END $$  

DELIMITER ;

DELIMITER $$  
  
CREATE TRIGGER Policy_Limit_Violation  
BEFORE UPDATE  
ON HomePolicy FOR EACH ROW  
BEGIN  
    DECLARE error_msg VARCHAR(255);  
    SET error_msg = ('The new Policy Limit exceeds 2,00,000');  
    IF new.PolicyLimit > 200000 THEN  
    SIGNAL SQLSTATE '45000'   
    SET MESSAGE_TEXT = error_msg;  
    END IF;  
END $$  
  
DELIMITER ;   