---Procedures---
---Question 1---
SET SERVEROUTPUT ON
DECLARE 
    v_ware_id warehouses.warehouse_id%TYPE;
    v_ware_name warehouses.warehouse_name%TYPE;
    v_loc_id warehouses.location_id%TYPE;
    PROCEDURE add_warehouse(v_ware_id IN warehouses.warehouse_id%TYPE,  v_ware_name IN warehouses.warehouse_name%TYPE, v_loc_id IN warehouses.location_id%TYPE) IS 
    BEGIN 
        INSERT INTO WAREHOUSES (warehouse_id, warehouse_name, location_id) VALUES(v_ware_id, v_ware_name, v_loc_id);
    END;
BEGIN
    v_ware_id:=&v_ware_id;
    v_loc_id:=&v_loc_id;
    v_ware_name:='&v_ware_name';
    SELECT MAX(warehouse_id)+1 INTO v_ware_name FROM WAREHOUSES;
    add_warehouse(v_ware_id, v_ware_name, v_loc_id);
END;

---Question 2---
SET SERVEROUTPUT ON
DECLARE 
    v_ware_id warehouses.warehouse_id%TYPE;
    v_ware_name warehouses.warehouse_name%TYPE;
    v_loc_id warehouses.location_id%TYPE;
    PROCEDURE modify_warehouse(v_ware_id IN warehouses.warehouse_id%TYPE, v_loc_id IN warehouses.location_id%TYPE, v_ware_name IN warehouses.warehouse_name%TYPE) IS 
    BEGIN 
        UPDATE WAREHOUSES SET warehouse_name = v_ware_name WHERE location_id = v_loc_id;
    END;
BEGIN
    v_ware_id:=&v_ware_id;
    v_loc_id:=&v_loc_id;
    v_ware_name:='&v_ware_name';
    modify_warehouse(v_ware_id, v_loc_id, v_ware_name);
END;

---Question 3---
SET SERVEROUTPUT ON
DECLARE 
    v_ware_id warehouses.warehouse_id%TYPE;
    PROCEDURE delete_warehouse(v_ware_id warehouses.warehouse_id%TYPE) IS 
    BEGIN 
        DELETE FROM WAREHOUSES WHERE warehouse_id = v_ware_id;
    END;
BEGIN
    v_ware_id:=&v_ware_id;
    delete_warehouse(v_ware_id);
END;

---Question 4---
SET SERVEROUTPUT ON
DECLARE 
    v_loc_id warehouses.location_id%TYPE;
    PROCEDURE show_warehouses(v_loc_id IN locations.location_id%TYPE) IS
        CURSOR warehouses_names IS
            SELECT warehouse_id, warehouse_name FROM WAREHOUSES WHERE location_id = v_loc_id;
    BEGIN
            for i in warehouses_names loop
                DBMS_OUTPUT.PUT_LINE('les informations de location_id egale a ' || v_loc_id || ' sont: ' || i.warehouse_id || ' ' || i.warehouse_name);
            end loop;
    END;
BEGIN
    v_loc_id:=&v_loc_id;
    show_warehouses(v_loc_id);
END;

---Question 5---
SET SERVEROUTPUT ON
DECLARE
    emp_id employees.employee_id%TYPE;
    count1 NUMBER;
    PROCEDURE cal_ca(emp_id IN employees.employee_id%TYPE, count1 OUT NUMBER) IS
    BEGIN
      SELECT SUM(QUANTITY*UNIT_PRICE) INTO count1
      FROM orders
      INNER JOIN order_items USING(order_id) 
      WHERE orders.salesman_id = emp_id;
    END;
BEGIN
    emp_id:=&emp_id;
    cal_ca(emp_id, count1);
    DBMS_OUTPUT.PUT_LINE('Le chiffre d affaire de l employe  '||emp_id||' est : '||count1);
END;

---Functins---
---Question 1---
SET SERVEROUTPUT ON
DECLARE
cus_id orders.customer_id%TYPE;
total_price NUMBER;

 Function total_cmd(cus_id IN orders.customer_id%TYPE)
    return NUMBER 
    IS total NUMBER;
    BEGIN
        SELECT SUM(QUANTITY*UNIT_PRICE) INTO total
        FROM orders
        INNER JOIN order_items USING(order_id)
        WHERE orders.customer_id = cus_id AND (STATUS='Pending' or STATUS='Shipped');
    return total;
    END;
BEGIN 
    cus_id:=&cus_id;
    total_price:=total_cmd(cus_id);
    DBMS_OUTPUT.PUT_LINE('Le prix total de '|| cus_id || ' est: '||total_price);
END;

---Question 2---
SET SERVEROUTPUT ON
DECLARE
nbr NUMBER;
 Function nbr_cmd
    return NUMBER 
    IS nbr NUMBER;
    BEGIN
        SELECT count(*) INTO nbr FROM orders WHERE STATUS='Pending';
    return nbr;
    END;
BEGIN 
    nbr:=nbr_cmd;
    DBMS_OUTPUT.PUT_LINE('Le nombre de commande qui ont le status Pending est: ' || nbr);
END;

---Declencheurs---
---Question 1---
CREATE OR REPLACE TRIGGER summary_order
    BEFORE INSERT ON ORDERS_ITEMS
    FOR EACH ROW
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE(' Summary of Order: ');
    DBMS_OUTPUT.PUT_LINE('ORDER ID    : ' || :NEW.ORDER_ID);
    DBMS_OUTPUT.PUT_LINE('QUANTITY : ' || :NEW.QUANTITY);
    DBMS_OUTPUT.PUT_LINE('ITEM ID   : ' || :NEW.ITEM_ID);
    DBMS_OUTPUT.PUT_LINE('PRODUCT ID : ' || :New.PRODUCT_ID);
    DBMS_OUTPUT.PUT_LINE('UNIT PRICE  : ' || :NEW.UNIT_PRICE);
END;
/
Insert INTO OT.ORDER_ITEMS (ORDER_ID,ITEM_ID,PRODUCT_ID,QUANTITY,UNIT_PRICE) values (106,1,235,123,41.99);

---Question 2---
CREATE OR REPLACE TRIGGER alert
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

---Question 3---
CREATE OR REPLACE TRIGGER modify_credit
BEFORE UPDATE OF credit_limit  ON customers
DECLARE
day_of_month NUMBER;
BEGIN

    day_of_month := EXTRACT(DAY FROM sysdate);

    IF day_of_month BETWEEN 28 AND 31 THEN
        raise_application_error(-20100,'Cannot update customer credit from 28th to 31st');
    END IF;
END;

---Question 4---
CREATE OR REPLACE TRIGGER forbid_add
BEFORE insert ON customers
FOR EACH ROW

BEGIN

    IF sysdate < :NEW.HIRE_DATE THEN
        raise_application_error(-20102,'Cannot insert until hire date');
    END IF;
END;
/
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE,HIRE_DATE,MANAGER_ID,JOB_TITLE) values 
(200,'test','test','summer.payne@example.com','515.123.8181',to_date('07-JUN-22','DD-MON-RR'),106,'Public Accountant');

---Question 5---
CREATE OR REPLACE TRIGGER discount_cmd
    BEFORE INSERT ON order_items
    FOR EACH ROW
DECLARE
s number;
BEGIN
    if :New.unit_price*:NEW.Quantity > 10000 then
        s:=:New.unit_price*:NEW.Quantity*0.95;
            DBMS_OUTPUT.PUT_LINE(' le montant est ' ||s);
    end if;

END;
/
Insert into OT.ORDER_ITEMS (ORDER_ID,ITEM_ID,PRODUCT_ID,QUANTITY,UNIT_PRICE) 
values (77,9,2,990,2554.99);
