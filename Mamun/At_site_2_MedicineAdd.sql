/* MEDICINE ADD FROM SITE 2 */
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
	
-----FUNCTION: VALIDATES MEDICINE CATEGORY-----
CREATE OR REPLACE FUNCTION validate_category (givenCategory IN At_site_2_Medicine.category%TYPE) 
RETURN BOOLEAN
IS
BEGIN
	IF (givenCategory = 'Syrup' OR givenCategory = 'Tablet' OR givenCategory = 'SYRUP' OR givenCategory = 'TABLET') THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END validate_category;
/

-----PROCEDURE: ADDS NEW MEDICINE-----
CREATE OR REPLACE PROCEDURE add_medicine(
    p_generic_name   IN At_site_2_Medicine.genericName%TYPE,
    p_medicine_name  IN At_site_2_Medicine.medicineName%TYPE,
    p_category       IN At_site_2_Medicine.category%TYPE,
    p_company_name   IN At_site_2_Medicine.companyName%TYPE,
    p_quantity       IN At_site_2_Medicine.quantity%TYPE,
    p_price_per_unit IN At_site_2_Medicine.pricePerUnit%TYPE,
    p_expiry_date    IN At_site_2_Medicine.expiryDate%TYPE)
IS
BEGIN
	IF (validate_category(p_category)) THEN-----FUNCTION CALL-----
		IF(p_category = 'Syrup' OR p_category = 'SYRUP') THEN
			INSERT INTO At_site_2_Medicine
			VALUES ((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) * 24 * 3600 FROM DUAL),
				p_generic_name,
				p_medicine_name,
				'Syrup',
				p_company_name,
				p_quantity,
				p_price_per_unit,
				p_expiry_date);
		ELSE
			INSERT INTO At_site_1_Medicine@medimart_link
			VALUES ((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) * 24 * 3600 FROM DUAL),
				p_generic_name,
				p_medicine_name,
				'Tablet',
				p_company_name,
				p_quantity,
				p_price_per_unit,
				p_expiry_date);
		END IF;
		COMMIT;
	ELSE
    DBMS_OUTPUT.PUT_LINE ('Invalid category. Category must be either ''Syrup'' or ''Tablet''');
  END IF;
END add_medicine;
/
	
-----MAIN-----
DECLARE
	validUser NUMBER;
	
	inputGenericName	At_site_2_Medicine.genericName%TYPE	:= '&input_genericName';
	inputMedicineName	At_site_2_Medicine.medicineName%TYPE:= '&input_medicineName';
	inputCategory		At_site_2_Medicine.category%TYPE	:= '&input_category';
	inputCompanyName	At_site_2_Medicine.companyName%TYPE	:= '&input_companyName';
	inputQuantity		At_site_2_Medicine.quantity%TYPE	:= '&input_quantity';
	inputPricePerUnit	At_site_2_Medicine.pricePerUnit%TYPE:= '&input_pricePerUnit';
	inputExpiryDate		At_site_2_Medicine.expiryDate%TYPE	:= '&input_expiryDate';
	
	emptyField EXCEPTION;
	invalidUser EXCEPTION;

BEGIN
	SELECT validity INTO validUser FROM At_site_2_VerifyUser WHERE id=1;
	IF(validUser != 1) THEN
		RAISE invalidUser;
	ELSE
		IF(inputGenericName IS NULL
			OR inputMedicineName IS NULL
			OR inputCategory IS NULL
			OR inputCompanyName	IS NULL
			OR inputQuantity IS NULL
			OR inputPricePerUnit IS NULL
			OR inputExpiryDate IS NULL) THEN
			RAISE emptyField;
		ELSE
			-----PROCEDURE CALL-----
			add_medicine(
			inputGenericName,
			inputMedicineName,
			inputCategory,
			inputCompanyName,
			inputQuantity,
			inputPricePerUnit,
			inputExpiryDate
			);
		END IF;
	END IF;
	
	EXCEPTION
	WHEN invalidUser THEN
		DBMS_OUTPUT.PUT_LINE('User login credentials are not valid.');
	WHEN emptyField THEN
		DBMS_OUTPUT.PUT_LINE('Input fields can not be empty.');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('OTHER ERRORS FOUND');	
END;
/
