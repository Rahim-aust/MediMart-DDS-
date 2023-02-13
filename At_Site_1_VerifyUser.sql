-----VERIFY USER-----
CLEAR SCREEN;
SET VERIFY OFF;
SET LINESIZE 32767;
SET SERVEROUTPUT ON;

ACCEPT login_username PROMPT 'Enter username: ';
ACCEPT login_password PROMPT 'Enter password: ';

DECLARE
  valid_user NUMBER := 0;
  login_username At_site_1_Seller.sellerUsername%TYPE := '&login_username';
  login_password At_site_1_Seller.sellerPassword%TYPE := '&login_password';
BEGIN
  SELECT 1 INTO valid_user
  FROM At_site_1_Seller
  WHERE sellerUsername = login_username AND sellerPassword = login_password;

  -- IF valid_user = 1 THEN
  --   INSERT INTO DUAL(D) VALUES(login_username);
  -- ELSE
  --   DBMS_OUTPUT.PUT_LINE('Invalid User.');
  -- END IF;
  DBMS_OUTPUT.PUT_LINE('Valid user: ' || valid_user);
END;
/
