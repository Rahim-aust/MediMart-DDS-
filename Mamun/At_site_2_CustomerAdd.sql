/* CUSTOMER ADD FROM SITE 2 */
CLEAR SCREEN;
SET VERIFY OFF;
SET LINESIZE 32767;
SET SERVEROUTPUT ON;

ACCEPT input_customerNo		PROMPT 'ENTER CUSTOMER PHONE NO.: ';

DECLARE
	validUser NUMBER := 0;
	
	inputCustomerNo		At_site_2_Customer.customerNo%TYPE;
	
	customerInfo VARCHAR(200) := '';
	invalidUser EXCEPTION;
	invalidCustomerPhoneNo EXCEPTION;

BEGIN
	inputCustomerNo		:= '&input_customerNo';
	
	SELECT validity INTO validUser FROM At_site_2_VerifyUser WHERE id=1;
	
	IF(validUser != 1) THEN
		RAISE invalidUser;
	ELSE
		-----CUSTOMER VALIDATION-----
		FOR C IN(SELECT * FROM At_site_2_Customer WHERE customerNo=inputCustomerNo) LOOP
			customerInfo := ('Customer Phone No.: ' ||C.customerNo || ', Bonus: ' || C.customerBonus);
		END LOOP;
		
		FOR C IN(SELECT * FROM At_site_1_Customer@medimart_link WHERE customerNo=inputCustomerNo) LOOP
			customerInfo := ('Customer Phone No.: ' ||C.customerNo || ', Bonus: ' || C.customerBonus);
		END LOOP;
		
		IF(customerInfo IS NOT NULL) THEN
			DBMS_OUTPUT.PUT_LINE('CUSTOMER EXISTS...');
			DBMS_OUTPUT.PUT_LINE(customerInfo);
		ELSIF(inputCustomerNo IS NOT NULL) THEN
			INSERT INTO At_site_2_Customer VALUES(inputCustomerNo, 0);
		ELSE
			RAISE invalidCustomerPhoneNo;
		END IF;
		
		COMMIT;
	END IF;
	
	EXCEPTION
	WHEN invalidUser THEN
		DBMS_OUTPUT.PUT_LINE('User login credentials are not valid.');
	WHEN invalidCustomerPhoneNo THEN
		DBMS_OUTPUT.PUT_LINE('Phone number invalid.');
	--WHEN OTHERS THEN
	--	DBMS_OUTPUT.PUT_LINE('OTHER ERRORS FOUND');	
END;
/	
	