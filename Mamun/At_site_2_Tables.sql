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

-----INVOICE TABLE-----
DROP TABLE At_site_2_Invoice CASCADE CONSTRAINTS;
CREATE TABLE At_site_2_Invoice(
	invoiceId VARCHAR2(20),
	customerName VARCHAR2(20),
	customerPhone VARCHAR2(20),
	sellAmount NUMBER,
	sellTime DATE,
	PRIMARY KEY(invoiceId)
);
DECLARE
	tempID INTEGER;
	
BEGIN
	INSERT INTO At_site_2_Seller(sellerID, sellerUsername, sellerPassword) VALUES (190104019, 'RAHIM', '190104019');
	INSERT INTO At_site_2_Seller(sellerID, sellerUsername, sellerPassword) VALUES (190104024, 'MAMUN', '190104024');
	COMMIT;
	
	INSERT INTO At_site_2_Medicine VALUES((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600 FROM DUAL), 'Chlorpromazine', 'Largazin 30ml', 'Syrup', 'United', 9, 16, SYSDATE);
	DBMS_LOCK.SLEEP(1);
	INSERT INTO At_site_2_Medicine VALUES((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600 FROM DUAL), 'Domperidone', 'Sandome 60ml', 'Syrup', 'Synovia', 30, 28.08, SYSDATE);
	DBMS_LOCK.SLEEP(1);
	INSERT INTO At_site_2_Medicine VALUES((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600 FROM DUAL),  'Carbamazepine', 'Cabretol 100ml', 'Syrup', 'Renata', 29, 301.13, SYSDATE);
	DBMS_LOCK.SLEEP(1);
	COMMIT;
	
	tempID := ((SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600);
	INSERT INTO At_site_2_Invoice VALUES(tempID, 'Rahul', '01874587458', 120, SYSDATE);
	--INSERT INTO At_site_1_Seller@medimart_link VALUES(tempID, 'Rahim', 120, SYSDATE);
	DBMS_LOCK.SLEEP(1);
	
	tempID := ((SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600);
	INSERT INTO At_site_2_Invoice VALUES(tempID, 'Milon', '0189887458', 140, SYSDATE);
	--INSERT INTO At_site_1_Seller@medimart_link VALUES(tempID, 'Mamun', 140, SYSDATE);
	DBMS_LOCK.SLEEP(1);
	COMMIT;

END;
/
	