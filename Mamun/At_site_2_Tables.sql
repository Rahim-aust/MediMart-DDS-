/* TABLE CREATION AT SITE 2 */
CLEAR SCREEN;
SET VERIFY OFF;
SET LINESIZE 32767;
SET SERVEROUTPUT ON;

-----SELLER TABLE-----
DROP TABLE At_site_2_Seller CASCADE CONSTRAINTS;
CREATE TABLE At_site_2_Seller (
	sellerID NUMBER, 
	sellerUsername VARCHAR2(10), 
	sellerPassword VARCHAR2(10),
	PRIMARY KEY(sellerID)
); 

-----MEDICINE TABLE-----
DROP TABLE At_site_2_Medicine CASCADE CONSTRAINTS;
CREATE TABLE At_site_2_Medicine(
	batchNo VARCHAR2(20),
	genericName VARCHAR2(20),
	medicineName VARCHAR2(20),
	category VARCHAR2(10),
	companyName VARCHAR2(20),
	quantity NUMBER,
	pricePerUnit NUMBER,
	expiryDate DATE,
	PRIMARY KEY(batchNo)
);

-----CUSTOMER TABLE-----
DROP TABLE At_site_2_Customer CASCADE CONSTRAINTS;
CREATE TABLE At_site_2_Customer(
	customerNo VARCHAR2(20),
	customerBonus NUMBER,
	PRIMARY KEY(customerNo)
);

-----INVOICE TABLE-----
DROP TABLE At_site_2_Invoice CASCADE CONSTRAINTS;
CREATE TABLE At_site_2_Invoice(
	invoiceId VARCHAR2(20),
	customerNo VARCHAR2(20),
	sellAmount NUMBER,
	sellTime DATE,
	PRIMARY KEY(invoiceId)
);

DECLARE
	tempID INTEGER;
	
BEGIN
	INSERT INTO At_site_2_Seller(sellerID, sellerUsername, sellerPassword) VALUES (190104024, 'MAMUN', '190104024');
	COMMIT;
	
	INSERT INTO At_site_2_Medicine VALUES((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600 FROM DUAL), 'Chlorpromazine', 'Largazin 30ml', 'Syrup', 'United', 25, 16, '01-DEC-2025');
	DBMS_LOCK.SLEEP(1);
	INSERT INTO At_site_2_Medicine VALUES((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600 FROM DUAL), 'Domperidone', 'Sandome 60ml', 'Syrup', 'Synovia', 30, 28.08, '01-DEC-2025');
	DBMS_LOCK.SLEEP(1);
	INSERT INTO At_site_2_Medicine VALUES((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600 FROM DUAL),  'Carbamazepine', 'Cabretol 100ml', 'Syrup', 'Renata', 29, 301.13, '01-DEC-2025');
	DBMS_LOCK.SLEEP(1);
	COMMIT;

	INSERT INTO At_site_2_Customer VALUES('01712345678', 0);
	INSERT INTO At_site_1_Customer@medimart_link VALUES('01812345678', 70);
	COMMIT;
	
	tempID := (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600;
	INSERT INTO At_site_2_Invoice VALUES(tempID, '01712345678', 120, SYSDATE);
	INSERT INTO At_site_1_Invoice@medimart_link VALUES(tempID, 'Rahim', 120, SYSDATE);
	DBMS_LOCK.SLEEP(1);
	
	tempID := (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600;
	INSERT INTO At_site_2_Invoice VALUES(tempID, '01812345678', 140, SYSDATE);
	INSERT INTO At_site_1_Invoice@medimart_link VALUES(tempID, 'Mamun', 140, SYSDATE);
	DBMS_LOCK.SLEEP(1);
	
	tempID := (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600;
	INSERT INTO At_site_2_Invoice VALUES(tempID, '', 45, SYSDATE);
	INSERT INTO At_site_1_Invoice@medimart_link VALUES(tempID, 'Rahim', 45, SYSDATE);
	DBMS_LOCK.SLEEP(1);
	
	tempID := (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600;
	INSERT INTO At_site_2_Invoice VALUES(tempID, '', 60, SYSDATE);
	INSERT INTO At_site_1_Invoice@medimart_link VALUES(tempID, 'Mamun', 60, SYSDATE);
	DBMS_LOCK.SLEEP(1);
	COMMIT;
	
END;
/
	