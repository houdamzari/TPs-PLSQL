----------------------------------TP3--------------------------------------------
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~Les Procedures ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 1 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-
SET SERVEROUTPUT ON;
DECLARE
v_warehouse_id  WAREHOUSES.WAREHOUSE_ID%TYPE;
v_warehouse_name WAREHOUSES.WAREHOUSE_NAME%TYPE;
v_location_id WAREHOUSES.LOCATION_ID%TYPE;

PROCEDURE ADD_WAREHOUSE(
v_warehouse_id IN WAREHOUSES.WAREHOUSE_ID%TYPE,
v_warehouse_name IN WAREHOUSES.WAREHOUSE_NAME%TYPE,
v_location_id IN WAREHOUSES.LOCATION_ID%TYPE)IS
BEGIN
INSERT INTO WAREHOUSES (WAREHOUSE_ID,WAREHOUSE_NAME,LOCATION_ID) 
VALUES (v_warehouse_id,v_warehouse_name,v_location_id);
END;


BEGIN

select max(warehouse_id)+1 INTO v_warehouse_id FROM WAREHOUSES;
v_warehouse_name:='&v_warehouse_name';
v_location_id:=&v_location_id;
ADD_WAREHOUSE(v_warehouse_id,v_warehouse_name,v_location_id);

END;

-~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-

SET SERVEROUTPUT ON;

DECLARE
v_warehouse_name WAREHOUSES.WAREHOUSE_NAME%TYPE;
v_warehouse_id WAREHOUSES.WAREHOUSE_ID%TYPE;

PROCEDURE UPDATE_WAREHOUSE(
v_warehouse_name IN WAREHOUSES.WAREHOUSE_NAME%TYPE,
v_location_id IN WAREHOUSES.WAREHOUSE_ID%TYPE)IS

BEGIN
UPDATE WAREHOUSES SET WAREHOUSE_NAME = v_warehouse_name WHERE WAREHOUSE_ID = v_warehouse_id;
END;


BEGIN
v_location_id:=&v_location_id;
v_warehouse_name:='&v_warehouse_name';
UPDATE_WAREHOUSE(v_warehouse_name,v_location_id);
END;

-~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-

SET SERVEROUTPUT ON;

DECLARE
v_warehouse_id WAREHOUSES.WAREHOUSE_ID%TYPE;

PROCEDURE DELETE_WAREHOUSE(
v_warehouse_id IN WAREHOUSES.WAREHOUSE_ID%TYPE)IS
BEGIN
DELETE FROM  WAREHOUSES WHERE WAREHOUSE_ID = v_warehouse_id;
END;

BEGIN
v_warehouse_id:=&v_warehouse_id;
DELETE_WAREHOUSE(v_warehouse_id);
END;


-~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 4~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-

SET SERVEROUTPUT ON;
DECLARE
v_location_id warehouses.location_id%TYPE ;

PROCEDURE Afficher(v_location_id IN warehouses.location_id%TYPE ) IS
CURSOR tab_names IS
SELECT WAREHOUSE_ID, WAREHOUSE_NAME 
FROM WAREHOUSES WHERE LOCATION_ID = v_location_id;
BEGIN
for i in tab_names loop
DBMS_OUTPUT.PUT_LINE('Warehouse ID : '||i.warehouse_id ||' - '||i.warehouse_name);
end loop;
END;
BEGIN
v_location_id:=&v_location_id;
Afficher(v_location_id);
END;

-~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 5 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-

SET SERVEROUTPUT ON;
DECLARE
v_employee_id EMPLOYEES.EMPLOYEE_ID%TYPE;
somme1 number;
PROCEDURE calcul_CA(id_employe IN EMPLOYEES.EMPLOYEE_ID%TYPE,
somme OUT number)IS
BEGIN
SELECT SUM(QUANTITY*UNIT_PRICE) INTO somme
FROM ORDERS
INNER JOIN ORDER_ITEMS USING(ORDER_ID)
WHERE SALESMAN_ID=v_employee_id;
END;
BEGIN
v_employee_id:=&v_employee_id;
calcul_CA(v_employee_id,somme1);
dbms_output.put_line('Le chiffre d affaire de l employe  '||v_employee_id||' est : '||somme1);

END;

-~~~~~~~~~~~~~~~~~~~~~~~~~~~~Les Fonctions~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 1~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-

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

-~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 2~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-
SET SERVEROUTPUT ON;
DECLARE
nombre_commande number;

FUNCTION calcul_commande
RETURN number 
IS
nombre number;

BEGIN
select count(*) INTO nombre from orders where STATUS='Pending' or STATUS='Shipped';
return nombre;
END;

BEGIN
nombre_commande:=calcul_commande;
dbms_output.put_line('Le nombre de commande qui ont comme status: Pending est:  '||nombre_commande);
END;

-~~~~~~~~~~~~~~~~~~~~~~~~~~~~TRIGGERS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 1~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-


create or replace NONEDITIONABLE TRIGGER dec_commande
    BEFORE INSERT ON ORDER_ITEMS
    FOR EACH ROW
DECLARE
BEGIN
DBMS_OUTPUT.PUT_LINE('L id '|| :NEW.order_id);
DBMS_OUTPUT.PUT_LINE('L id '|| :new.quantity);
DBMS_OUTPUT.PUT_LINE('L id '|| :new.unit_price);
END;

-~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 2~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-

create or replace NONEDITIONABLE TRIGGER dec_alerte
   AFTER  UPDATE ON INVENTORIES
    FOR EACH ROW
DECLARE
BEGIN
if :NEW.quantity<10 then
DBMS_OUTPUT.PUT_LINE('ALERTE  : Quantity < 10');
end if ;
END;


-~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-

create or replace NONEDITIONABLE TRIGGER customers_credit_trg
    BEFORE UPDATE OF credit_limit  
    ON customers
DECLARE
    l_day_of_month NUMBER;
BEGIN
    -- determine the transaction type
    l_day_of_month := EXTRACT(DAY FROM sysdate);

    IF l_day_of_month BETWEEN 28 AND 31 THEN
        raise_application_error(-20100,'Cannot update customer credit from 28th to 31st');
    END IF;
END;

-~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 4~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-

create or replace NONEDITIONABLE TRIGGER customers_credit_trg2
    BEFORE INSERT ON EMPLOYEES 
    FOR EACH ROW

BEGIN
    -- determine the transaction type

    IF sysdate < :NEW.hire_date THEN
        raise_application_error(-20102,'Cannot insert until hire date');
    END IF;
END;

-~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 5~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-

create or replace NONEDITIONABLE TRIGGER commande_remise
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




