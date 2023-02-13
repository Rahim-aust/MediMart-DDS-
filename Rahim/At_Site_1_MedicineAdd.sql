/* MEDICINE ADD FROM SITE 1 */
CLEAR SCREEN;
SET VERIFY OFF;
SET LINESIZE 32767;
SET SERVEROUTPUT ON;

ACCEPT input_genericName	PROMPT 'ENTER GENERIC NAME: ';
ACCEPT input_medicineName	PROMPT 'ENTER MEDICINE NAME: ';
ACCEPT input_category		PROMPT 'ENTER CATEGORY: ';
ACCEPT input_companyName	PROMPT 'ENTER COMPANY NAME: ';
ACCEPT input_quantity		PROMPT 'ENTER QUANTITY: ';
ACCEPT input_pricePerUnit	PROMPT 'ENTER PRICE PER UNIT: ';
ACCEPT input_expiryDate		PROMPT 'ENTER EXPIRY DATE(01-JAN-2022): ';

DECLARE
	inputGenericName	At_site_1_Medicine.genericName%TYPE := '&input_genericName';
	inputMedicineName	At_site_1_Medicine.medicineName%TYPE := '&input_medicineName';
	inputCategory		At_site_1_Medicine.category%TYPE := '&input_category';
	inputCompanyName	At_site_1_Medicine.companyName%TYPE := '&input_companyName';
	inputQuantity		At_site_1_Medicine.quantity%TYPE := '&input_quantity';
	inputPricePerUnit	At_site_1_Medicine.pricePerUnit%TYPE := '&input_pricePerUnit';
	inputExpiryDate		At_site_1_Medicine.expiryDate%TYPE := '&input_expiryDate';
	
	invalidMedicineCategory EXCEPTION;

BEGIN
	-----MEDICINE CATEGORY VALIDATION-----
	IF(inputCategory = 'Syrup' OR inputCategory = 'SYRUP') THEN
		INSERT INTO At_site_2_Medicine@medimart_link VALUES(
			(SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600 FROM DUAL),
			inputGenericName,
			inputMedicineName,
			'Syrup',
			inputCompanyName,
			inputQuantity,
			inputPricePerUnit,
			inputExpiryDate);
		DBMS_LOCK.SLEEP(1);
	ELSIF(inputCategory = 'Tablet' OR inputCategory = 'TABLET') THEN
		INSERT INTO At_site_1_Medicine VALUES(
			(SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600 FROM DUAL),
			inputGenericName,
			inputMedicineName,
			'Tablet',
			inputCompanyName,
			inputQuantity,
			inputPricePerUnit,
			inputExpiryDate);
		DBMS_LOCK.SLEEP(1);
	ELSE
		RAISE invalidMedicineCategory;
	END IF;
	
	COMMIT;
	
	EXCEPTION
	WHEN invalidMedicineCategory THEN
		DBMS_OUTPUT.PUT_LINE('It seems that medicine category is wrong. It must be ''Syrup'' or ''Tablet''');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('OTHER ERRORS FOUND');	
END;
/	
	