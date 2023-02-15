/* MEDICINE SELL FROM SITE 2*/
CLEAR SCREEN;
SET VERIFY OFF;
SET LINESIZE 32767;
SET SERVEROUTPUT ON;

ACCEPT input_medicineName	PROMPT 'ENTER MEDICINE NAME: ';
ACCEPT input_category		PROMPT 'ENTER CATEGORY: ';
ACCEPT input_quantity		PROMPT 'ENTER QUANTITY: ';
ACCEPT input_customerPhone	PROMPT 'ENTER Customer Phone Number: ';

DECLARE
	validUser NUMBER := 0;
	
	inputMedicineName	At_site_2_Medicine.medicineName%TYPE := '&input_medicineName';
	inputCategory		At_site_2_Medicine.category%TYPE := '&input_category';
	inputQuantity		At_site_2_Medicine.quantity%TYPE := '&input_quantity';
    inputCustomerPhone	At_site_2_Customer.customerNo%TYPE := '&input_customerPhone';

    prevBonus At_site_2_Customer.customerBonus%TYPE :=0;
    prevQuantity At_site_2_Medicine.quantity%TYPE :=0;
    pricePerUnitSell At_site_2_Medicine.pricePerUnit%TYPE :=0;
    tempID INTEGER;
    tempFlag NUMBER := 0;

	emptyField EXCEPTION;
	invalidUser EXCEPTION;
	invalidMedicineCategory EXCEPTION;

BEGIN
	SELECT validity INTO validUser FROM At_site_2_VerifyUser WHERE id=1;
	
	IF(validUser != 1) THEN
		RAISE invalidUser;
	ELSE
		-----MEDICINE UPDATE TABLE AFTER SELL-----
		IF(inputMedicineName IS NULL OR inputCategory IS NULL OR inputQuantity IS NULL) THEN
			RAISE emptyField;
		ELSIF((inputCategory != 'Syrup' AND inputCategory != 'SYRUP') AND (inputCategory != 'Tablet' AND inputCategory != 'TABLET')) THEN
			RAISE invalidMedicineCategory;
		ELSE
			IF(inputCategory = 'Syrup' OR inputCategory = 'SYRUP') THEN
				Select quantity,pricePerUnit into prevQuantity,pricePerUnitSell from (select * from At_site_1_medicine@medimart_link union select * from At_site_2_medicine) WHERE medicineName = inputMedicineName and Category = 'Syrup';
				UPDATE At_site_2_Medicine SET quantity=prevQuantity-inputQuantity WHERE medicineName = inputMedicineName and Category = 'Syrup'; 
				COMMIT;
			ELSIF(inputCategory = 'Tablet' OR inputCategory = 'TABLET') THEN
				Select quantity,pricePerUnit into prevQuantity,pricePerUnitSell from (select * from At_site_1_medicine@medimart_link union select * from At_site_2_medicine) WHERE medicineName = inputMedicineName and Category = 'Tablet';
				UPDATE At_site_1_Medicine@medimart_link SET QUANTITY=prevQuantity-inputQuantity WHERE medicineName = inputMedicineName and Category = 'Tablet'; 
				COMMIT;
			END IF;

			tempID := (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600;
			INSERT INTO At_site_2_Invoice VALUES(tempID,inputCustomerPhone,inputQuantity*pricePerUnitSell,SYSDATE);
			INSERT INTO At_site_1_Invoice@medimart_link VALUES(tempID,'Mamun',inputQuantity*pricePerUnitSell,SYSDATE);
			COMMIT;
			
			FOR R IN (select customerBonus FROM(SELECT * from At_site_1_Customer@medimart_link union select * from At_site_2_Customer) WHERE customerNo = inputCustomerPhone) LOOP
				prevBonus:= R.customerBonus;
				tempFlag := 1;
			END LOOP;
					
			IF(tempFlag=1) THEN
				IF(inputCustomerPhone is not null AND prevBonus>50) THEN
					UPDATE At_site_1_Customer@medimart_link SET customerBonus=(customerBonus+inputQuantity*pricePerUnitSell*0.2) WHERE customerNo = inputCustomerPhone;
				ELSIF(inputCustomerPhone is not null AND prevBonus<=50 AND (prevBonus+inputQuantity*pricePerUnitSell*0.2)<=50) THEN
					UPDATE At_site_2_Customer SET customerBonus=(customerBonus+inputQuantity*pricePerUnitSell*0.2) WHERE customerNo = inputCustomerPhone;
				ELSIF(inputCustomerPhone is not null AND prevBonus<=50 AND (prevBonus+inputQuantity*pricePerUnitSell*0.2)>50) THEN
					INSERT INTO At_site_1_Customer@medimart_link VALUES(inputCustomerPhone, prevBonus+inputQuantity*pricePerUnitSell*0.2);
					DELETE At_site_2_Customer WHERE customerNo = inputCustomerPhone;
				END IF;
			END IF;

			COMMIT;
		END IF;		
	END IF;
	
	EXCEPTION
	WHEN invalidUser THEN
		DBMS_OUTPUT.PUT_LINE('User login credentials are not valid.');
	WHEN emptyField THEN
		DBMS_OUTPUT.PUT_LINE('Input fields can not be empty.');
	WHEN invalidMedicineCategory THEN
		DBMS_OUTPUT.PUT_LINE('It seems that medicine category is wrong. It must be ''Syrup'' or ''Tablet''');
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Medicine is not available.');
	--WHEN OTHERS THEN
		--DBMS_OUTPUT.PUT_LINE('OTHER ERRORS FOUND');	
END;
/	
	