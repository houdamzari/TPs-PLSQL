------PROCEDUES----------
------Question 1---------

SET SERVEROUTPUT ON;

DECLARE

id_warehouse warehouses.warehouse_id%TYPE;
name_warehouse warehouses.warehouse_name%TYPE;
id_location warehouses.location_id%TYPE;
COUNTER NUMBER;

PROCEDURE add_warehouse(id_warehouse IN warehouses.warehouse_id%TYPE, name_warehouse IN warehouses.warehouse_name%TYPE, id_location IN warehouses.location_id%TYPE) IS
BEGIN
INSERT INTO warehouses (warehouse_id, warehouse_name, location_id) VALUES (id_warehouse, name_warehouse, id_location);
END;
BEGIN
SELECT MAX(warehouse_id) INTO COUNTER FROM warehouses;
id_warehouse:=COUNTER + 1;
name_warehouse:='&name_warehouse';
id_location:=&id_location;
add_warehouse(id_warehouse,name_warehouse,id_location);

END;
-------------------------
-------------------------

------Question 2---------

SET SERVEROUTPUT ON;

DECLARE

id_warehouse warehouses.warehouse_id%TYPE;
name_warehouse warehouses.warehouse_name%TYPE;
id_location warehouses.location_id%TYPE;

PROCEDURE update_warehouse(id_warehouse IN warehouses.warehouse_id%TYPE, name_warehouse IN warehouses.warehouse_name%TYPE, id_location IN warehouses.location_id%TYPE) IS
BEGIN

UPDATE warehouses SET warehouse_name=name_warehouse WHERE location_id = id_location;
END;

BEGIN
id_warehouse:=&id_warehouse;
id_location:=&id_location;
name_warehouse:='&name_warehouse';
update_warehouse(id_warehouse,name_warehouse,id_location);
END;
-------------------------
-------------------------

------Question 3---------
SET SERVEROUTPUT ON;

DECLARE
id_warehouse warehouses.warehouse_id%TYPE;
PROCEDURE delete_warehouse(id_warehouse IN warehouses.warehouse_id%TYPE) IS
BEGIN
DELETE FROM warehouses WHERE warehouse_id = id_warehouse;
END;
BEGIN
id_warehouse:=&id_warehouse;
delete_warehouse(id_warehouse);
END;
-------------------------
-------------------------

------Question 4---------
SET SERVEROUTPUT ON;

DECLARE

id_warehouse warehouses.warehouse_id%TYPE;
name_warehouse warehouses.warehouse_name%TYPE;
id_location warehouses.location_id%TYPE;
CURSOR c_warehouses IS SELECT warehouse_name FROM warehouses WHERE location_id=id_location;

PROCEDURE check_warehouse(id_location IN warehouses.location_id%TYPE) IS
BEGIN
FOR N IN c_warehouses LOOP
dbms_output.put_line(N.warehouse_name);
END LOOP;
END;

BEGIN
id_location:=&id_location;
check_warehouse(id_location);
END;
-------------------------
-------------------------

------Question 5---------
SET SERVEROUTPUT ON
DECLARE
id_employee employees.employee_id%TYPE;
ca NUMBER;
PROCEDURE calcul_ca(id_employee IN employees.employee_id%TYPE, ca OUT NUMBER) IS
BEGIN
SELECT SUM(QUANTITY*UNIT_PRICE) INTO ca FROM orders INNER JOIN order_items USING(order_id) WHERE orders.salesman_id = id_employee;
END;
BEGIN
    id_employee:=&id_employee;
    calcul_ca(id_employee, ca);
    DBMS_OUTPUT.PUT_LINE('Le chiffre d affaire de l employe  '||id_employee||' est : '||ca);
END;
-------------------------
-------------------------

------Fonctions----------
------Question 1---------
SET SERVEROUTPUT ON
DECLARE
id_customer orders.customer_id%TYPE;
total_price NUMBER;

Function total_cmd(id_customer IN orders.customer_id%TYPE) 
return NUMBER 
IS 
total NUMBER;
BEGIN
SELECT SUM(QUANTITY*UNIT_PRICE) INTO total
FROM orders
INNER JOIN order_items USING(order_id)
WHERE orders.customer_id = id_customer AND (STATUS='Pending' or STATUS='Shipped'); 
return total;
END;
BEGIN 
    id_customer:=&id_customer;
    total_price:=total_cmd(id_customer);
    DBMS_OUTPUT.PUT_LINE('Le prix total d une commande du client '|| id_customer || ' est: '||total_price);
END;
-------------------------
-------------------------

------Question 2---------
SET SERVEROUTPUT ON
DECLARE
nbr NUMBER;
Function nbr_cmd
return NUMBER 
IS 
nbr NUMBER;
BEGIN
SELECT count(*) INTO nbr FROM orders WHERE STATUS='Pending';
return nbr;
END;

BEGIN 
    nbr:=nbr_cmd;
    DBMS_OUTPUT.PUT_LINE('Le nombre de commande qui ont le status Pending est: ' || nbr);
END;
-------------------------
-------------------------

------Declencheurs----------
------Question 1---------
CREATE OR REPLACE TRIGGER resume_cmd
    BEFORE INSERT ON ORDERS_ITEMS
    FOR EACH ROW
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE(' Resumee d une commande: ');
    DBMS_OUTPUT.PUT_LINE('ORDER ID    : ' || :NEW.ORDER_ID);
    DBMS_OUTPUT.PUT_LINE('QUANTITY : ' || :NEW.QUANTITY);
    DBMS_OUTPUT.PUT_LINE('ITEM ID   : ' || :NEW.ITEM_ID);
    DBMS_OUTPUT.PUT_LINE('PRODUCT ID : ' || :New.PRODUCT_ID);
    DBMS_OUTPUT.PUT_LINE('UNIT PRICE  : ' || :NEW.UNIT_PRICE);
END;
-------------------------
-------------------------

------Question 2---------
CREATE OR REPLACE TRIGGER alert_stock
    AFTER UPDATE OR DELETE ON INVENTORIES
    FOR EACH ROW
DECLARE
BEGIN
    IF (:NEW.QUANTITY <10) THEN
        DBMS_OUTPUT.PUT_LINE(' ALERT STOCK: Quantity  < 10 !!');
    END IF;
END;
-------------------------
-------------------------

------Question 3---------
CREATE OR REPLACE TRIGGER stop_modify
BEFORE UPDATE OF credit_limit  ON customers
DECLARE
v_today NUMBER;
BEGIN
    v_today := EXTRACT(DAY FROM sysdate);
    IF v_today BETWEEN 28 AND 31 THEN
      raise_application_error(-20100,'Cannot update customer credit from 28th to 31st');
    END IF;
END;
-------------------------
-------------------------

------Question 4---------
CREATE OR REPLACE TRIGGER stop_add  
BEFORE insert ON customers
FOR EACH ROW

BEGIN

    IF sysdate < :NEW.HIRE_DATE THEN
        raise_application_error(-20102,'ERROR date exceeds today s date');
    END IF;
END;
-------------------------
-------------------------

------Question 5---------
CREATE OR REPLACE TRIGGER remise
    BEFORE INSERT ON order_items
    FOR EACH ROW
DECLARE
new_price number;
BEGIN
    if :New.unit_price*:NEW.Quantity > 10000 then
        new_price:=:New.unit_price*:NEW.Quantity*0.95;
            DBMS_OUTPUT.PUT_LINE(' Vous etes note fidele client, une remise de 5% est appliquee ' ||s);
    end if;

END;
