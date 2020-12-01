+++++ Procédures ;

-----Question 1:

CREATE or replace PROCEDURE question_1(var_warehouse IN warehouses%rowtype,var_location_id in number)
IS
CURSOR is_there is SELECT location_id from locations where location_id=var_location_id;
j number := 0;
BEGIN
for n in is_there loop
insert into warehouses (WAREHOUSE_ID,WAREHOUSE_NAME,LOCATION_ID) values (var_warehouse.WAREHOUSE_ID,var_warehouse.WAREHOUSE_NAME,var_location_id);
dbms_output.put_line('inserted');
j:=1;
end loop;
if j=0 then
dbms_output.put_line('error');
end if;
END question_1;

//////

SET SERVEROUTPUT ON
DECLARE
z warehouses%rowtype;
n number := 224;
begin
z.WAREHOUSE_NAME :='Mare7babikom';
z.WAREHOUSE_ID:= 21;
question_1(z,n);
end;

-----Question 2:

CREATE or replace PROCEDURE question_2(var_location_id in number,var_warehouse in warehouses%rowtype) IS 
BEGIN
UPDATE warehouses SET WAREHOUSE_NAME=var_warehouse.WAREHOUSE_NAME  WHERE LOCATION_ID=var_location_id;
if sql%found then
dbms_output.put_line('le nombre des lignes met a jour est: ');
dbms_output.put_line(sql%rowcount);
else
dbms_output.put_line('error');
end if;
END question_2;

///////////////////////

SET SERVEROUTPUT ON
DECLARE
z warehouses%rowtype;
n number := 11;
begin
z.WAREHOUSE_NAME :='dar darkom';
z.WAREHOUSE_ID:= 21;
question_2(n,z);
end;

-----Question 3:

CREATE or replace PROCEDURE question_3(var_warehouse_id in number) IS 
BEGIN
delete from warehouses where warehouse_id=var_warehouse_id;
if sql%found then
dbms_output.put_line('le nombre des lignes supprimees est: ');
dbms_output.put_line(sql%rowcount);
else
dbms_output.put_line('error ??? ');
end if;
END question_3;

/////////////////////////

SET SERVEROUTPUT ON
DECLARE
z warehouses%rowtype;
n number := 9;
begin
z.WAREHOUSE_NAME :='dar darkom';
z.WAREHOUSE_ID:= 21;
question_3(n);
end;

-----Question 4:

CREATE or replace PROCEDURE question_4(var_location_id in locations.location_id%type) IS 
CURSOR c_question_4 IS SELECT * from warehouses where location_id = var_location_id;
j number := 0;
BEGIN
for n in c_question_4 loop 
dbms_output.put_line('warehouse de ID('||n.WAREHOUSE_ID||') son nom est : '||n.WAREHOUSE_NAME||' ID de leur location est : '||n.location_id);
j:= 1;
end loop;
if j = 0 then
dbms_output.put_line('Location de ID('||var_location_id||') n a pas des warehouses');
end if;
END question_4;

////////////

SET SERVEROUTPUT ON
DECLARE
z warehouses%rowtype;
n number := 4;
begin
z.WAREHOUSE_NAME :='dar darkom';
z.WAREHOUSE_ID:= 21;
question_4(n);
end;


-----Question 5:

CREATE or replace PROCEDURE question_5(var_employee_id in employees.EMPLOYEE_ID%type) IS 
CURSOR c_question_5 IS SELECT employees.EMPLOYEE_ID as v_employee_id,sum(unit_price*quantity) as v_vente from order_items,employees,orders where employees.EMPLOYEE_ID = orders.salesman_id and orders.order_id = order_items.order_id and employees.EMPLOYEE_ID=var_employee_id group by  employees.EMPLOYEE_ID;
j number := 0;
BEGIN
for n in c_question_5 loop 
dbms_output.put_line('Le CA de l employee de ID('||n.v_employee_id||') est : '||n.v_vente);
j:= 1;
end loop;
if j = 0 then
dbms_output.put_line('Le CA de cet employee est : 0 ou cet employee n existe pas');
end if;
END question_5;

////////////////

SET SERVEROUTPUT ON
DECLARE
n number := 4;
begin
question_5(60);
end;

+++++ Fonctions ;

-----Question 1:

CREATE OR REPLACE FUNCTION question_f1(var_customer_id in customers.customer_id%type)
RETURN NUMBER IS
CURSOR c_question_1 IS SELECT customers.customer_id as v_customer,sum(unit_price*quantity) as v_prix from order_items,customers,orders where customers.customer_id = orders.customer_id and orders.order_id = order_items.order_id and customers.customer_id=var_customer_id  group by  customers.customer_id;
j number := 0;
BEGIN
for n in c_question_1 loop 
RETURN n.v_prix;
j:= 1;
end loop;
if j = 0 then
RETURN -1;
end if;
END;

//////////////

SET SERVEROUTPUT ON
DECLARE
begin
dbms_output.put_line(question_f1(1));
end;

-----Question 2:

CREATE OR REPLACE FUNCTION question_f2
RETURN NUMBER IS
CURSOR c_question_2 IS SELECT COUNT(*) as v_pending FROM orders where status='Pending';
j number := 0;
BEGIN
for n in c_question_2 loop 
RETURN n.v_pending;
j:= 1;
end loop;
if j = 0 then
RETURN -1;
end if;
END;

////////////////////////

SET SERVEROUTPUT ON
DECLARE
begin
dbms_output.put_line(question_f2());
end;

+++++ Déclencheurs ;

-----Question 1:

CREATE OR REPLACE TRIGGER t_question_1
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
DBMS_OUTPUT.PUT_LINE('Commande ID '||:NEW.ORDER_ID||' -- Custumer ID '||:NEW.CUSTOMER_ID||' -- Status '||:NEW.STATUS||' -- Salesman ID '||:NEW.SALESMAN_ID||' -- Order date '||:NEW.ORDER_DATE);
DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
END;
///////////////////
SET SERVEROUTPUT ON
begin
insert into orders values (110,100,'Pending',60,'27/11/2020');
end;

-----Question 2:

CREATE OR REPLACE TRIGGER t_question_2_1
AFTER DELETE OR UPDATE OR INSERT ON inventories
FOR EACH ROW
DECLARE
CURSOR c_count is select * from inventories where quantity < 10; 
BEGIN
for n in c_count loop
DBMS_OUTPUT.PUT_LINE('Alerte du stocke !!!! le nombre d’article disponible en inventaire est < 10 pour le produit de ID ('|| n.PRODUCT_ID||')');
end loop;
END;

-----Question 3:

CREATE OR REPLACE TRIGGER t_question_3 
BEFORE UPDATE OF CREDIT_LIMIT ON customers
FOR EACH ROW
DECLARE
e_update_error EXCEPTION;
PRAGMA exception_init(e_update_error,-20001);
v_date number;
BEGIN
SELECT TO_CHAR(sysdate,'DD')into v_date FROM DUAL;
if v_date = 28 then
raise_application_error(-20001,'la modification du CREDIT_LIMIT des clients entre le 28 et 30 de chaque mois n est pas autorise');
elsif v_date = 29 then
raise_application_error(-20001,'la modification du CREDIT_LIMIT des clients entre le 28 et 30 de chaque mois n est pas autorise');
elsif v_date = 30 then
raise_application_error(-20001,'la modification du CREDIT_LIMIT des clients entre le 28 et 30 de chaque mois n est pas autorise');
end if;
END;

///////////////////

SET SERVEROUTPUT ON
DECLARE
begin
update customers set CREDIT_LIMIT = 501 where CUSTOMER_ID = 271;
end;

-----Question 4:

CREATE OR REPLACE TRIGGER t_question_4 
BEFORE INSERT ON employees
FOR EACH ROW
DECLARE
e_insert_error EXCEPTION;
PRAGMA exception_init(e_insert_error,-20002);
BEGIN
if :NEW.HIRE_DATE > sysdate then
raise_application_error(-20002,'interdit l’ajout d’un employé parceque HIRE_DATE est > a Date d’aujourd’hui');
end if;
END;

///////////////////

SET SERVEROUTPUT ON
DECLARE
begin
insert into employees values (55,'taha','raiss','taha-hahaw@gmail.com','0631547686','29/11/2020',49,'kan9ra');
end;

-----Question 5:

CREATE OR REPLACE TRIGGER t_question_5 
BEFORE INSERT  ON order_items
FOR EACH ROW
DECLARE
CURSOR c_product is select product_id from products where product_id=:NEW.product_id ;
CURSOR c_order is select order_id from orders where order_id=:NEW.order_id ;
CURSOR c_question_5 IS SELECT order_id,sum(UNIT_PRICE*QUANTITY) as v_prix from order_items GROUP BY order_id;
j number := 0;
BEGIN
for v in c_product loop
for m in c_order loop
j:=1;
end loop;
end loop;

if j=1 then
for n in c_question_5 loop
if n.order_id=:NEW.order_id then
if n.v_prix > 10000 then
DBMS_OUTPUT.PUT_LINE(n.v_prix-n.v_prix*0.05);
end if;
end if;
end loop;
else
DBMS_OUTPUT.PUT_LINE('error !!! order item introuvable');
end if;
END;
SET SERVEROUTPUT ON
DECLARE
begin
Insert into OT.ORDER_ITEMS (ORDER_ID,ITEM_ID,PRODUCT_ID,QUANTITY,UNIT_PRICE) 
values (770,900,2,990,2554.99);
end;