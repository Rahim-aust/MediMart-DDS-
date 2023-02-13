/* TABLE CREATION AT SITE 2 */
CLEAR SCREEN;
SET VERIFY OFF;
SET LINESIZE 32767;
SET SERVEROUTPUT ON;

-----SELLER TABLE-----
DROP TABLE At_site_1_Seller CASCADE CONSTRAINTS;
CREATE TABLE At_site_1_Seller (
	sellerID NUMBER, 
	sellerUsername VARCHAR2(10), 
	sellerPassword VARCHAR2(10),
	PRIMARY KEY(sellerID)
); 

-----MEDICINE TABLE-----
DROP TABLE At_site_1_Medicine CASCADE CONSTRAINTS;
CREATE TABLE At_site_1_Medicine(
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

-----CUSTOMER TABLE----
DROP TABLE At_site_1_Customer CASCADE CONSTRAINTS;
CREATE TABLE At_site_1_Customer(
	customerNo VARCHAR2(20),
	customerName VARCHAR2(20),
	customerBonus NUMBER,
	PRIMARY KEY (customerNo)
);
-----INVOICE TABLE-----
DROP TABLE At_site_1_Invoice CASCADE CONSTRAINTS;
CREATE TABLE At_site_1_Invoice(
	invoiceId varchar2(20),
	sellerUsername varchar2(20),
	sellAmount number,
	sellTime date,
	PRIMARY KEY(invoiceId)
	--FOREIGN KEY (customerNo) REFERENCES At_site_1_Customer(customerNo)
);

DECLARE
	tempID INTEGER;
	
BEGIN
	INSERT INTO At_site_1_Seller(sellerID, sellerUsername, sellerPassword) VALUES (190104019, 'RAHIM', '190104019');
	INSERT INTO At_site_1_Seller(sellerID, sellerUsername, sellerPassword) VALUES (190104024, 'MAMUN', '190104024');
	COMMIT;
	
	-- INSERT INTO At_site_1_Medicine VALUES((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600 FROM DUAL), 'Chlorpromazine', 'Largazin 30ml', 'Syrup', 'United', 9, 16, SYSDATE);
	-- DBMS_LOCK.SLEEP(1);
	-- INSERT INTO At_site_1_Medicine VALUES((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600 FROM DUAL), 'Domperidone', 'Sandome 60ml', 'Syrup', 'Synovia', 30, 28.08, SYSDATE);
	-- DBMS_LOCK.SLEEP(1);
	-- INSERT INTO At_site_1_Medicine VALUES((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600 FROM DUAL),  'Carbamazepine', 'Cabretol 100ml', 'Syrup', 'Renata', 29, 301.13, SYSDATE);
	-- DBMS_LOCK.SLEEP(1);
	-- COMMIT;

    INSERT INTO At_site_1_Medicine VALUES((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600 FROM DUAL), 'Ibuprofen', 'Nurofen 200mg', 'Tablet', 'Pfizer', 50, 10, SYSDATE);
    DBMS_LOCK.SLEEP(1);
    INSERT INTO At_site_1_Medicine VALUES((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600 FROM DUAL), 'Paracetamol', 'Panadol 500mg', 'Tablet', 'GSK', 80, 5, SYSDATE);
    DBMS_LOCK.SLEEP(1);
    INSERT INTO At_site_1_Medicine VALUES((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600 FROM DUAL), 'Amlodipine', 'Norvasc 5mg', 'Tablet', 'Pfizer', 60, 20, SYSDATE);
    DBMS_LOCK.SLEEP(1);
    INSERT INTO At_site_1_Medicine VALUES((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600 FROM DUAL), 'Lisinopril', 'Prinivil 20mg', 'Tablet', 'Merck', 40, 15, SYSDATE);
    DBMS_LOCK.SLEEP(1);
    INSERT INTO At_site_1_Medicine VALUES((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600 FROM DUAL), 'Metformin', 'Glucophage 500mg', 'Tablet', 'Sanofi', 70, 8, SYSDATE);
    COMMIT;
	
	

END;
/
	