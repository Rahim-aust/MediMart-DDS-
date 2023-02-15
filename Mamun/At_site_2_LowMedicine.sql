/* LOW MEDICINE CHECK FROM SITE 2 */
CLEAR SCREEN;
SET VERIFY OFF;
SET LINESIZE 32767;
SET SERVEROUTPUT ON;

DROP VIEW LowMedicine;
CREATE OR REPLACE VIEW At_site_2_lowMedicine(batchNo, medicineName, category, quantity) AS
(
	SELECT allMedicines.batchNo, allMedicines.medicineName, allMedicines.category, allMedicines.quantity 
	FROM At_site_2_medicine allMedicines
	WHERE quantity<50
);

SELECT batchNo, medicineName, category, quantity FROM At_site_2_lowMedicine ORDER BY quantity;
COMMIT;
