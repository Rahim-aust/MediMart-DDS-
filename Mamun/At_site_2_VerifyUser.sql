-----VERIFY USER AT SITE 2-----
SET VERIFY OFF;
SET LINESIZE 32767;
SET SERVEROUTPUT ON;

-----USER VALIDITY TABLE-----
DROP TABLE At_site_2_VerifyUser CASCADE CONSTRAINTS;
CREATE TABLE At_site_2_VerifyUser (id NUMBER, validity NUMBER);
CLEAR SCREEN;

ACCEPT login_username PROMPT 'ENTER USERNAME: ';
ACCEPT login_password PROMPT 'ENTER PASSWORD: ';

DECLARE
	validUser NUMBER := 0;
	loginUsername At_site_2_Seller.sellerUsername%TYPE := '&login_username';
	loginPassword At_site_2_Seller.sellerPassword%TYPE := '&login_password';
	
BEGIN	
	FOR R IN (SELECT sellerUsername, sellerPassword from At_site_2_Seller WHERE sellerUsername=loginUsername AND sellerPassword=loginPassword) LOOP
		validUser := 1;
	END LOOP;
	INSERT INTO At_site_2_VerifyUser VALUES (1, validUser);
	DBMS_OUTPUT.PUT_LINE('Valid User=> ' || validUser);
	
END;
/