---PROCEDURE ------------------------------------------------------------------------------
---question 1------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE ADD_WAREHOUSE(r_warehouse IN WAREHOUSES%ROWTYPE) IS
BEGIN
INSERT INTO WAREHOUSES (WAREHOUSE_ID, WAREHOUSE_NAME, LOCATION_ID) VALUES (ISEQ$$_73358.NEXTVAL, r_warehouse.WAREHOUSE_NAME, r_warehouse.LOCATION_ID);
END ADD_WAREHOUSE;
--~~~~~~~~~
SET SERVEROUTPUT ON
DECLARE
rec_warehouse WAREHOUSES%ROWTYPE;
BEGIN
rec_warehouse.WAREHOUSE_NAME:='&WAREHOUSE_NAME';
rec_warehouse.LOCATION_ID:='&LOCATION_ID';
ADD_WAREHOUSE(rec_warehouse);
END;
--question2-------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE UPDATE_WAREHOUSE(r_warehouse IN WAREHOUSES%ROWTYPE)IS
BEGIN
UPDATE WAREHOUSES SET WAREHOUSE_NAME = r_warehouse.WAREHOUSE_NAME, LOCATION_ID = r_warehouse.LOCATION_ID
WHERE WAREHOUSE_ID = r_warehouse.WAREHOUSE_ID;
END UPDATE_WAREHOUSE;
--~~~~~~~~~
SET SERVEROUTPUT ON
DECLARE
rec_warehouse WAREHOUSES%ROWTYPE;
BEGIN
rec_warehouse.WAREHOUSE_ID:='&WAREHOUSE_ID';
rec_warehouse.WAREHOUSE_NAME:='&WAREHOUSE_NAME';
rec_warehouse.LOCATION_ID:='&LOCATION_ID';
UPDATE_WAREHOUSE(rec_warehouse);
END;
--question3-------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE DELETE_WAREHOUSE(id_wh IN WAREHOUSES.WAREHOUSE_ID%TYPE)IS
BEGIN
DELETE FROM WAREHOUSES WHERE WAREHOUSE_ID = id_wh;
END DELETE_WAREHOUSE;
--~~~~~~~~~
SET SERVEROUTPUT ON
DECLARE
ID_WH WAREHOUSES.WAREHOUSE_ID%TYPE;
BEGIN
ID_WH :='&ID_WH';
DELETE_WAREHOUSE(ID_WH);
END;
--question4-------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SHOW_WAREHOUSES(id_lct IN WAREHOUSES.LOCATION_ID%TYPE)IS
CURSOR c_wh IS
SELECT * FROM WAREHOUSES WHERE LOCATION_ID = id_lct;
BEGIN
DBMS_OUTPUT.PUT_LINE('Voici les WAREHOUSES de la location :'||id_lct);
FOR r_wh IN c_wh LOOP
DBMS_OUTPUT.PUT_LINE('WAREHOUSE_ID : '||r_wh.WAREHOUSE_ID||' WAREHOUSE_NAME : '||r_wh.WAREHOUSE_NAME);
END LOOP;
END SHOW_WAREHOUSES;
--~~~~~~~~~
SET SERVEROUTPUT ON
DECLARE
ID_LCT WAREHOUSES.LOCATION_ID%TYPE;
BEGIN
ID_LCT :='&ID_LCT';
SHOW_WAREHOUSES(ID_LCT);
END;
--question5-------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE CA(id_salesman ORDERS.SALESMAN_ID%TYPE) IS
nbr NUMBER;
BEGIN
SELECT SUM(QUANTITY*UNIT_PRICE) INTO nbr FROM ORDER_ITEMS
INNER JOIN ORDERS USING (ORDER_ID)
WHERE SALESMAN_ID = id_salesman;
DBMS_OUTPUT.PUT_LINE('Le chiffre d affaire est : '||nbr||'$');
END CA;
--~~~~~~~~~
SET SERVEROUTPUT ON
DECLARE
id_salesman ORDERS.SALESMAN_ID%TYPE;
BEGIN
id_salesman :='&id_salesman';
CA(id_salesman);
END;
--FONCTION -------------------------------------------------------------------------------------
--question1-------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION PRICE(id_ordr IN ORDERS.ORDER_ID%TYPE, id_cstm IN ORDERS.CUSTOMER_ID%TYPE)
RETURN NUMBER IS
prix NUMBER;
BEGIN
SELECT SUM(QUANTITY*UNIT_PRICE) INTO prix FROM ORDER_ITEMS
INNER JOIN ORDERS USING (ORDER_ID)
WHERE  ORDER_ID = id_ordr AND CUSTOMER_ID = id_cstm;
RETURN prix;
END;
--~~~~~~~~~~~
SET SERVEROUTPUT ON
DECLARE
id_customer ORDERS.CUSTOMER_ID%TYPE;
id_ordr ORDERS.ORDER_ID%TYPE;
p_total NUMBER;
BEGIN
id_ordr :='&id_ordr';
id_customer :='&id_customer';
p_total :=PRICE(id_ordr,id_customer);
DBMS_OUTPUT.PUT_LINE('Le prix total de la commande : '||id_ordr||' du client : '||id_customer||' est : '||p_total||'$');
END;
--question2-------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION STATUS_PENDING
RETURN NUMBER IS
NBR NUMBER;
BEGIN
SELECT COUNT(*) INTO NBR FROM ORDERS WHERE STATUS = 'Pending';
RETURN NBR;
END;
--~~~~~~~~~~~
SET SERVEROUTPUT ON
DECLARE
NBR NUMBER;
BEGIN
NBR:=STATUS_PENDING;
DBMS_OUTPUT.PUT_LINE('Le nombre de commande qui ont le status pending est : '||NBR);
END;
--DECHLENCHEUR--------------------------------------------------------------------------------------
--question1-------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER affichage
AFTER INSERT ON ORDER_ITEMS 
FOR EACH ROW
BEGIN
DBMS_OUTPUT.PUT_LINE('ORDER_ID   : '||:NEW.ORDER_ID);
DBMS_OUTPUT.PUT_LINE('ITEM_ID    : '||:NEW.ITEM_ID);
DBMS_OUTPUT.PUT_LINE('PRODUCT_ID : '||:NEW.PRODUCT_ID);
DBMS_OUTPUT.PUT_LINE('QUANTITY   : '||:NEW.QUANTITY);
DBMS_OUTPUT.PUT_LINE('UNIT_PRICE : '||:NEW.UNIT_PRICE);
END;

--question2-------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER alerte
BEFORE INSERT OR UPDATE ON INVENTORIES
FOR EACH ROW 
BEGIN
IF :NEW.QUANTITY < 10 THEN
DBMS_OUTPUT.PUT_LINE('Alerte!: quantity <10');
END IF;
END;

--question3-------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER T_MODIFY
BEFORE UPDATE OF CREDIT_LIMIT ON CUSTOMERS
FOR EACH ROW
DECLARE
LAdate NUMBER;
BEGIN
LAdate := EXTRACT(DAY FROM sysdate);
    IF LAdate BETWEEN 28 and 30 then
    raise_application_error(-20001,'Vous ne pouvez pas modifier le credit_limit entre le 28 et le 30');
    END IF;
END;    

--question4-------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER T_ADD
BEFORE INSERT ON EMPLOYEES
FOR EACH ROW
WHEN (NEW.HIRE_DATE > sysdate)
BEGIN
    raise_application_error(-20002,'Vous ne pouvez pas inserer! veuillez vérifier HIRE_DATE');
END;

--question5-------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER REMISE
BEFORE INSERT OR UPDATE ON ORDER_ITEMS
FOR EACH ROW 
BEGIN
IF :NEW.QUANTITY*:NEW.UNIT_PRICE > 10000 THEN
:NEW.UNIT_PRICE := :NEW.UNIT_PRICE*0.95;
END IF;
END;
