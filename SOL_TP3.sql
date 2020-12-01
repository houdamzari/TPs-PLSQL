
--________ANSSAIEN Ayat____________
--1


CREATE OR REPLACE PROCEDURE  add_warehouse( warehouse_name IN warehouses.warehouse_name%TYPE, location_id IN warehouses.location_id%TYPE)IS
BEGIN
INSERT INTO WAREHOUSES(WAREHAOUSE_NAME,LOCATION_ID) VALUSE (warehouse_name,location_id) 
END;

--APELL
BEGIN
add_warehouse('&warehouse_name',&loc_id);
END;
--2
select * from  WAREHOUSES ;
DECLARE

CREATE OR REPLACE PROCEDURE update_data(wh_name IN warehouses.warehouse_name%TYPE , wh_id IN warehouses.WAREHOUSE_ID%TYPE)IS
BEGIN
UPDATE WAREHOUSES
SET WAREHOUSE_NAME = wh_name
WHERE WAREHOUSE_ID = wh_id ;
END;
--APELL
BEGIN
update_data('&warehouse_name',&loc_id);
END;
--3
DECLARE
CREATE OR REPLACE PROCEDURE  Supprimer(wh_id IN warehouses.warehouse_id%TYPE )IS
BEGIN
DELETE FROM WAREHOUSES
WHERE WAREHOUSE_NAME = wh_name ;
END;
BEGIN
Supprimer(&wh_id);
END;
--4
CREATE OR REPLACE PROCEDURE afficher(loc_id IN warehouses.location_id%TYPE ) IS
CURSOR  ids_names IS
SELECT warehouse_id , warehouse_name from warehouses where location_id=loc_id;
BEGIN

for i in ids_names loop
DBMS_OUTPUT.PUT_LINE('WAREHOUSES  :');
DBMS_OUTPUT.PUT_LINE( i.warehouse_id || ' ' || i.warehouse_name);
end loop;
END;
--APELL
BEGIN
afficher(&loc_id);
END;
--5
CREATE OR REPLACE PROCEDURE CA( emp_id IN EMPLOYEES.employee_id%TYPE , CA OUT INT) IS
BEGIN
SELECT SUM ( order_items.quantity * order_items.unit_price ) into CA
        FROM orders
            INNER JOIN order_items
            ON orders.order_id = order_items.order_id  
        WHERE    orders.salesman_id = emp_id;      
END;
--APELL
DECLARE
ca INT;
BEGIN
CA(&emp_id,ca);
dbms_output.put_line(ca);
END;
--__________________________________FUNCTIONS_________________________________
--1 

CREATE OR REPLACE FUNCTION prix_total(ord_id IN orders.order_id%TYPE ,cust_id IN orders.customer_id%TYPE) 
RETURN INT
 IS  
 prix INT;
BEGIN
 SELECT SUM ( order_items.quantity * order_items.unit_price ) into prix
        FROM orders
            INNER JOIN order_items
            ON orders.order_id = order_items.order_id  
        WHERE    orders.order_id = ord_id AND  orders.customer_id = cust_id;
 RETURN prix; 
END;
--APELL
BEGIN
dbms_output.put_line('le prix total est : '|| prix_total(&ord_id,&cust_id) );
END;

--2
CREATE OR REPLACE FUNCTION Pending
RETURN number
 IS  
 nombre number;
BEGIN
 SELECT COUNT(*) into nombre FROM orders where  status = 'Pending' ;
 RETURN nombre; 
END;
--APELL
BEGIN
dbms_ou tput.put_line(Pending());
END;
--__________________________________TRIGGERS_________________________________

--1
create or replace  TRIGGER resume
AFTER INSERT ON orders
FOR EACH ROW
   BEGIN
dbms_output.put_line('ORDER_ID: '||:NEW.ORDER_ID );
dbms_output.put_line('CUSTOMER_ID: '||:NEW.CUSTOMER_ID );
dbms_output.put_line('STATUS: '||:NEW.STATUS );
dbms_output.put_line('SALESMAN_ID: '||:NEW.SALESMAN_ID );
dbms_output.put_line('ORDER_DATE: '||:NEW.ORDER_DATE );
   END;
 --2
CREATE OR REPLACE TRIGGER  alert
AFTER INSERT OR UPDATE ON INVENTORIES
FOR EACH ROW
WHEN :NEW.QUANTITY <10 ;
   BEGIN
   dbms_output.put_line('stock < 10 !! ');
   END;
--3
CREATE OR REPLACE TRIGGER non_autoriser
BEFORE UPDATE ON CUSTOMERS
FOR EACH ROW
WHEN  ( EXTRACT(day FROM SYSDATE)>=28 AND EXTRACT(day FROM SYSDATE)<=30 )
   BEGIN
   raise_application_error(-20120,'Cannot update customer credit from 28th to 31st');
   END;
--4 
CREATE OR REPLACE  TRIGGER  interdit 
BEFORE INSERT ON EMPLOYEES
FOR EACH ROW
WHEN SYSDATE < :NEW.HIRE_DATE ; 
   BEGIN
     raise_application_error(-20101,'HIRE_DATE  > Current DATE ');
   END;
--5
CREATE OR REPLACE TRIGGER remise
AFTER INSERT ON order_items
FOR EACH ROW
 WHEN New.unit_price*:NEW.Quantity > 10000 
BEGIN
     DBMS_OUTPUT.PUT_LINE(' votre montant est ' ||:New.unit_price*:NEW.Quantity*0.95);
END;
