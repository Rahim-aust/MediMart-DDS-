/* MEDICINE ADD FROM SITE 1 */
CLEAR SCREEN;
SET VERIFY OFF;
SET LINESIZE 32767;
SET SERVEROUTPUT ON;

-- CREATE THE FUNCTION TO VALIDATE THE CATEGORY
CREATE OR REPLACE FUNCTION validate_category (p_category IN VARCHAR2) 
RETURN BOOLEAN
IS
BEGIN
  IF p_category = 'Syrup' OR p_category = 'TABLET' THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END validate_category;
/

-- CREATE THE PROCEDURE TO ADD THE MEDICINE
CREATE OR REPLACE PROCEDURE add_medicine (
    p_generic_name   IN VARCHAR2,
    p_medicine_name  IN VARCHAR2,
    p_category       IN VARCHAR2,
    p_company_name   IN VARCHAR2,
    p_quantity       IN NUMBER,
    p_price_per_unit IN NUMBER,
    p_expiry_date    IN DATE)
AS
BEGIN
  -- VALIDATE THE CATEGORY
  IF validate_category (p_category) THEN
    IF p_category = 'Syrup' THEN
      INSERT INTO At_site_2_Medicine@medimart_link
      VALUES ((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) * 24 * 3600
               FROM DUAL),
              p_generic_name,
              p_medicine_name,
              'Syrup',
              p_company_name,
              p_quantity,
              p_price_per_unit,
              p_expiry_date);
      DBMS_LOCK.SLEEP (1);
    ELSE
      INSERT INTO At_site_1_Medicine
      VALUES ((SELECT (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) * 24 * 3600
               FROM DUAL),
              p_generic_name,
              p_medicine_name,
              'Tablet',
              p_company_name,
              p_quantity,
              p_price_per_unit,
              p_expiry_date);
      DBMS_LOCK.SLEEP (1);
    END IF;
    COMMIT;
  ELSE
    DBMS_OUTPUT.PUT_LINE ('Invalid category. Category must be either ''Syrup'' or ''Tablet''');
  END IF;
END add_medicine;
/

-- CREATE A BLOCK TO GET THE USER INPUT AND CALL THE PROCEDURE
DECLARE
    v_generic_name   VARCHAR2 (30);
    v_medicine_name  VARCHAR2 (30);
    v_category       VARCHAR2 (30);
    v_company_name   VARCHAR2 (30);
    v_quantity       NUMBER;
    v_price_per_unit NUMBER;
    v_expiry_date    DATE;

BEGIN
    ACCEPT v_generic_name PROMPT 'Enter generic name: ';
    ACCEPT v_medicine_name PROMPT 'Enter medicine name: ';
    ACCEPT v_category PROMPT 'Enter category (Syrup/Tablet): ';
    ACCEPT v_company_name PROMPT 'Enter company name: ';
    ACCEPT v_quantity PROMPT 'Enter quantity: ';
    ACCEPT v_price_per_unit PROMPT 'Enter price per unit: ';
    ACCEPT v_expiry_date PROMPT 'Enter expiry date (dd-mon-yyyy): ';

    -- CALL THE PROCEDURE
    ADD_MEDICINE (
    v_generic_name,
    v_medicine_name,
    v_category,
    v_company_name,
    v_quantity,
    v_price_per_unit,
    v_expiry_date
    );
END;
