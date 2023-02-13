/* MEDICINE SELL FROM SITE */
CLEAR SCREEN;
SET VERIFY OFF;
SET LINESIZE 32767;
SET SERVEROUTPUT ON;

ACCEPT input_medicineName	PROMPT 'ENTER MEDICINE NAME: ';
ACCEPT input_category		PROMPT 'ENTER CATEGORY: ';
ACCEPT input_quantity		PROMPT 'ENTER QUANTITY: ';
ACCEPT input_customerPhone	PROMPT 'ENTER Customer Phone Number: ';

DECLARE
	inputMedicineName	At_site_1_Medicine.medicineName%TYPE := '&input_medicineName';
	inputCategory		At_site_1_Medicine.category%TYPE := '&input_category';
	inputQuantity		At_site_1_Medicine.quantity%TYPE := '&input_quantity';
    inputCustomerPhone	At_site_1_Customer.customerNo%TYPE := '&input_customerPhone';

    cusName At_site_1_Customer.customerName%TYPE;
    prevBonus At_site_1_Customer.customerBonus%TYPE :=0;
    prevQuantity At_site_1_Medicine.quantity%TYPE :=0;
    pricePerUnitSell At_site_1_Medicine.pricePerUnit%TYPE :=0;
    tempID INTEGER;
	
	invalidMedicineCategory EXCEPTION;

BEGIN
	-----MEDICINE UPDATE TABLE AFTER SELL-----
    Select quantity,pricePerUnit into prevQuantity,pricePerUnitSell from (select * from At_site_1_medicine union select * from At_site_2_medicine@medimart_link) WHERE medicineName = inputMedicineName and Category = inputCategory;

	IF(inputCategory = 'Syrup' OR inputCategory = 'SYRUP') THEN
		UPDATE At_site_2_Medicine@medimart_link SET quantity=prevQuantity-inputQuantity WHERE medicineName = inputMedicineName and Category = inputCategory; 

	ELSIF(inputCategory = 'Tablet' OR inputCategory = 'TABLET') THEN
		UPDATE At_site_1_Medicine SET QUANTITY=prevQuantity-inputQuantity WHERE medicineName = inputMedicineName and Category = inputCategory; 
	ELSE
		RAISE invalidMedicineCategory;
	END IF;

	SELECT customerName, customerBonus INTO cusName, prevBonus from (select * from At_site_1_Customer union select * from At_site_2_Customer@medimart_link) WHERE customerNo = inputCustomerPhone; 


	tempID := (SYSDATE - TO_DATE('01-Jan-1970 00:00:00', 'dd-Mon-yyyy hh24:mi:ss')) *24*3600;
	INSERT INTO At_site_2_Invoice@medimart_link VALUES(tempID,cusName,inputQuantity*pricePerUnitSell,SYSDATE);
	INSERT INTO At_site_1_Invoice VALUES(tempID,'MAMUN',inputQuantity*pricePerUnitSell,SYSDATE);

	IF(inputCustomerPhone is not null AND prevBonus<=50 AND (prevBonus+inputQuantity*pricePerUnitSell*0.2)>50) THEN
		INSERT INTO At_site_1_Customer VALUES(inputCustomerPhone, cusName, prevBonus+inputQuantity*pricePerUnitSell*0.2);
		DELETE At_site_2_Customer@medimart_link WHERE customerNo = inputCustomerPhone;
	ELSIF(inputCustomerPhone is not null AND prevBonus<=50 AND (prevBonus+inputQuantity*pricePerUnitSell*0.2)<50) THEN
		UPDATE At_site_2_Customer@medimart_link SET customerBonus=(customerBonus+inputQuantity*pricePerUnitSell*0.2) WHERE customerNo = inputCustomerPhone;
	ELSIF(inputCustomerPhone is not null AND prevBonus>50) THEN
		UPDATE At_site_1_Customer SET customerBonus=(customerBonus+inputQuantity*pricePerUnitSell*0.2) WHERE customerNo = inputCustomerPhone;
	END IF;

	COMMIT;
	
	EXCEPTION
	WHEN invalidMedicineCategory THEN
		DBMS_OUTPUT.PUT_LINE('It seems that medicine category is wrong. It must be ''Syrup'' or ''Tablet''');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('OTHER ERRORS FOUND');	
END;
/	
	