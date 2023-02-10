-----VERIFY USER-----
CLEAR SCREEN;
SET VERIFY OFF;
SET LINESIZE 32767;
SET SERVEROUTPUT ON;

ACCEPT login_username PROMPT 'ENTER USERNAME: ';
ACCEPT login_password PROMPT 'ENTER PASSWORD: ';

DECLARE
	validUser NUMBER;
	loginUsername At_site_2_Seller.sellerUsername%TYPE;
	loginPassword At_site_2_Seller.sellerPassword%TYPE;
	
BEGIN
	validUser := 0;
	loginUsername := '&login_username';
	loginPassword := '&login_password';
	
	FOR R IN (SELECT sellerUsername, sellerPassword from At_site_2_Seller WHERE sellerUsername=loginUsername AND sellerPassword=loginPassword) LOOP
		validUser := 1;
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('Valid User=> ' || validUser);
	
END;
/