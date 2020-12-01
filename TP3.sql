----------------------------------------------PROCEDURES---------------------------------------------------------------------
-------------------QST1--------------------------
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE ajouter_warehouse(
v_warehouse_id IN WAREHOUSES.WAREHOUSE_ID%TYPE,
v_warehouse_name IN WAREHOUSES.WAREHOUSE_NAME%TYPE,
v_location_id IN WAREHOUSES.LOCATION_ID%TYPE)IS
BEGIN
INSERT INTO WAREHOUSES (WAREHOUSE_ID,WAREHOUSE_NAME,LOCATION_ID) VALUES (v_warehouse_id,v_warehouse_name,v_location_id);
END;
DECLARE
v1_warehouse_id  WAREHOUSES.WAREHOUSE_ID%TYPE;
v1_warehouse_name WAREHOUSES.WAREHOUSE_NAME%TYPE;
v1_location_id WAREHOUSES.LOCATION_ID%TYPE;
BEGIN
select max(warehouse_id)+1 INTO v_warehouse_id FROM WAREHOUSES;
v1_warehouse_name:='&v1_warehouse_name';
v1_location_id:=&v1_location_id;
ajouter_warehouse(v1_warehouse_id,v1_warehouse_name,v1_location_id);
END;
-------------------QST2----------------------------
SET SERVEROUTPUT ON;
PROCEDURE modifier_warehouse(
v_warehouse_name IN WAREHOUSES.WAREHOUSE_NAME%TYPE,
v_location_id IN WAREHOUSES.WAREHOUSE_ID%TYPE)IS
BEGIN
UPDATE  WAREHOUSES SET WAREHOUSE_NAME = v_warehouse_name WHERE WAREHOUSE_ID = v_warehouse_id;
END;

DECLARE
v1_warehouse_name WAREHOUSES.WAREHOUSE_NAME%TYPE;
v1_warehouse_id WAREHOUSES.WAREHOUSE_ID%TYPE;
BEGIN
v1_location_id:=&v1_location_id;
v1_warehouse_name:='&v1_warehouse_name';
modifier_warehouse(v1_warehouse_name,v1_location_id);
END;
--------------------QST3------------------------------
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE supprimer_warehouse(
v_warehouse_id IN WAREHOUSES.WAREHOUSE_ID%TYPE)IS
BEGIN
DELETE FROM  WAREHOUSES WHERE WAREHOUSE_ID = v_warehouse_id;
END;
DECLARE
v1_warehouse_id WAREHOUSES.WAREHOUSE_ID%TYPE;
BEGIN
v1_warehouse_id:=&v1_warehouse_id;
supprimer_warehouse(v1_warehouse_id);
END;
----------------------QST4----------------------------
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE afficher(v_location_id IN warehouses.location_id%TYPE ) IS
CURSOR tab_names IS
SELECT WAREHOUSE_ID, WAREHOUS_NAME FROM WAREHOUSES WHERE LOCATION_ID = v_location_id;
BEGIN
for i in tab_names loop
DBMS_OUTPUT.PUT_LINE('la ligne '||i|| ': '||i.warehouse_id ||','||i.warehouse_name);
end loop;
END;
DECLARE

BEGIN
afficher(11);
END;
----------------------QST5----------------------------
SET SERVEROUTPUT ON;
DECLARE
v_employee_id EMPLOYEES.EMPLOYEE_ID%TYPE;
somme1 number;
PROCEDURE calcul_CA(id_employe IN EMPLOYEES.EMPLOYEE_ID%TYPE,
somme OUT number)IS
BEGIN
SELECT SUM(QUANTITY*UNIT_PRICE)INTO somme
FROM ORDERS
INNER JOIN ORDER_ITEMS USING(ORDER_ID)
WHERE SALESMAN_ID=v_employee_id;
END;
BEGIN
v_employee_id:=&v_employee_id;
calcul_CA(v_employee_id,somme1);
dbms_output.put_line('Le chiffre d affaire de l employe  '||v_employee_id||' est : '||somme1);
END;
----------------------------------------------FONCTIONS---------------------------------------------------------------------
-------------------QST1----------------------
SET SERVEROUTPUT ON;
DECLARE
v_customer_id ORDERS.CUSTOMER_ID%TYPE;
prix_total number;

FUNCTION calcul_prix(id_customer IN ORDERS.CUSTOMER_ID%TYPE)
RETURN number 
IS
prix number;

BEGIN
SELECT SUM(QUANTITY*UNIT_PRICE)INTO prix
FROM ORDERS
INNER JOIN ORDER_ITEMS USING(ORDER_ID)
WHERE ORDERS.CUSTOMER_ID=v_customer_id AND (STATUS='Pending' or STATUS='Shipeed');
return prix;
END;

BEGIN
v_customer_id:=&v_customer_id;
prix_total:=calcul_prix(v_customer_id);
dbms_output.put_line('Le prix total  de '||v_customer_id||' est : '||prix_total);
END;
-------------------QST2----------------------
SET SERVEROUTPUT ON;
DECLARE
nombre_commande number;

FUNCTION calcul_commande
RETURN number 
IS
nombre number;

BEGIN
select count(*) INTO nombre from orders where STATUS='Pending';
return nombre;
END;

BEGIN
nombre_commande:=calcul_commande;
dbms_output.put_line('Le nombre de commande qui ont comme status: Pending est:  '||nombre_commande);
END;
----------------------------------------------DECLENCHEURS---------------------------------------------------------------------
-------------------QST1----------------------
CREATE OR REPLACE TRIGGER t_order
    BEFORE INSERT ON ORDER_ITEMS
    FOR EACH ROW
DECLARE
BEGIN
DBMS_OUTPUT.PUT_LINE('RESUME DU COMMANDE:  ');
DBMS_OUTPUT.PUT_LINE('ORDER ID    : ' || :NEW.ORDER_ID);
DBMS_OUTPUT.PUT_LINE('QUANTITY : ' || :NEW.QUANTITY);
DBMS_OUTPUT.PUT_LINE('ITEM ID   : ' || :NEW.ITEM_ID);
DBMS_OUTPUT.PUT_LINE('PRODUCT ID : ' || :New.PRODUCT_ID);
DBMS_OUTPUT.PUT_LINE('UNIT PRICE  : ' || :NEW.UNIT_PRICE);
END;
/
Insert INTO OT.ORDER_ITEMS (ORDER_ID,ITEM_ID,PRODUCT_ID,QUANTITY,UNIT_PRICE) values (106,1,235,123,41.99);
-------------------QST2----------------------
CREATE OR REPLACE TRIGGER commande_alerte
    AFTER UPDATE OR DELETE ON INVENTORIES
    FOR EACH ROW
DECLARE
BEGIN
    IF (:NEW.QUANTITY <10) THEN
        DBMS_OUTPUT.PUT_LINE(' ALERT: Quantity  < 10 ');
    END IF;
END;
/
UPDATE INVENTORIES set quantity=9 where product_id=262;
-------------------QST3---------------------------
CREATE OR REPLACE TRIGGER modifier_credit
BEFORE UPDATE OF credit_limit  ON customers
DECLARE
day_of_month NUMBER;
BEGIN

    day_of_month := EXTRACT(DAY FROM sysdate);

    IF day_of_month BETWEEN 28 AND 31 THEN
        raise_application_error(-20100,'Cannot update customer credit from 28th to 31st');
    END IF;
END;
-------------------QST4---------------------------
CREATE OR REPLACE TRIGGER ajout_interdit
BEFORE insert ON customers
FOR EACH ROW

BEGIN

    IF sysdate < :NEW.HIRE_DATE THEN
        raise_application_error(-20102,'Cannot insert until hire date');
    END IF;
END;
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE,HIRE_DATE,MANAGER_ID,JOB_TITLE) values 
(200,'test','test','summer.payne@example.com','515.123.8181',to_date('07-JUN-22','DD-MON-RR'),106,'Public Accountant');
-------------------QST5---------------------------
CREATE OR REPLACE TRIGGER commande_remise
    BEFORE INSERT ON order_items
    FOR EACH ROW
DECLARE
sum1 number;
BEGIN
      if :New.unit_price*:NEW.Quantity > 10000 then
     sum1:=:New.unit_price*:NEW.Quantity*0.95;
      DBMS_OUTPUT.PUT_LINE(' le montant est ' ||sum1);
      end if;

END;
/
Insert into OT.ORDER_ITEMS (ORDER_ID,ITEM_ID,PRODUCT_ID,QUANTITY,UNIT_PRICE)values (77,9,2,990,2554.99);
