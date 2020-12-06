----procedures--------------------------------------------------------------------------------------------------------------
----question1---------------------------------------------------------------------------------------------------------------
set serveroutput on;
DECLARE 
v_id warehouses.location_id%type;
w_name warehouses.warehouse_name%type;
w_id warehouses.warehouse_id%type;
loc_id warehouses.location_id%type;
PROCEDURE add_warehouse(x in warehouses.location_id%type, y in warehouses.warehouse_id%type, z in warehouses.warehouse_name%type ) is
begin
select location_id into loc_id from locations where location_id=x;
insert into warehouses values (y,z,x);
dbms_output.put_line('ligne ajoutée');
exception 
when no_data_found then
dbms_output.put_line('aucune location correspond à ce id ');
when others then
dbms_output.put_line('erreur wharehouse existe');
end;
begin
v_id:='&v_id';
w_name:='&w_name';
w_id:='&w_id';
add_warehouse(v_id,w_id,w_name);
end;
--/////////////////////////////////////////////////////////////////
set serveroutput on;
DECLARE 
v_id warehouses.location_id%type;
w_name warehouses.warehouse_name%type;
w_id warehouses.warehouse_id%type;
loc_id warehouses.location_id%type;
PROCEDURE add_warehouse(x in warehouses.location_id%type, y in warehouses.warehouse_id%type, z in warehouses.warehouse_name%type ) is
cursor c_warehouse  is select warehouse_name FROM warehouses where warehouse_id=y;
names warehouses.warehouse_name%type;
begin
open c_warehouse;
loop 
fetch c_warehouse into names;
exit when c_warehouse%notfound;
dbms_output.put_line(y||' : warehouse id existant sous le nom de '||names);
end loop;
select location_id into loc_id from locations where location_id=x;
insert into warehouses values (y,z,x);
dbms_output.put_line('ligne ajoutée');
exception 
when no_data_found then
dbms_output.put_line('aucune location correspond à ce id ');
when others then
dbms_output.put_line('erreur!! ');
end;
begin
v_id:='&v_id';
w_name:='&w_name';
w_id:='&w_id';
add_warehouse(v_id,w_id,w_name);
end;

---------------------------

----question 2---------------------------------------------------------------------

set serveroutput on;
DECLARE 
warehouse_id warehouses.warehouse_id%type;
location_id warehouses.location_id%type;
new_name warehouses.warehouse_name%type;
PROCEDURE Update_warehouse(x in warehouses.location_id%type, y in warehouses.warehouse_id%type, z in warehouses.warehouse_name%type ) is
names warehouses.warehouse_name%type;
begin
select warehouse_name into names FROM warehouses where warehouse_id=y and location_id=x ;
update warehouses set warehouse_name=z where location_id=x and warehouse_id=y;
dbms_output.put_line('ligne modifiée avec succée');
exception
when no_data_found then 
dbms_output.put_line('warehouse nexiste pas');
when others then 
dbms_output.put_line('erreur');
end;
begin
location_id:='&location_id';
new_name:='&new_name';
warehouse_id:='&w_id';
Update_warehouse(location_id,warehouse_id,new_name);
end;
----question 3----------------------------------------------------------------------------------
set serveroutput on;
DECLARE 
ware_id warehouses.warehouse_id%type;
v_ware warehouses.warehouse_name%type;
PROCEDURE delete_warehouse(x in warehouses.warehouse_id%type) is
begin
delete from warehouses where warehouse_id=x;
end;
begin
ware_id:='&ware_id';
select warehouse_name into v_ware from warehouses where warehouse_id=ware_id;
delete_warehouse(ware_id);
dbms_output.put_line(v_ware||' is deleted successfully');
exception 
when no_data_found then 
dbms_output.put_line('warehouse does not exist');
when others then 
dbms_output.put_line('error!!');
end;

----question 4------------------------------------------------------------------------------------------
set serveroutput on;
DECLARE 
loca_id warehouses.location_id%type;
PROCEDURE affichage(x in warehouses.location_id%type) is
cursor c_ware is select warehouse_name FROM warehouses where location_id=x;
names warehouses.warehouse_name%type;
begin
open c_ware;
loop 
fetch c_ware into names;
exit when c_ware%notfound;
dbms_output.put_line('le nom de warehouse est '||names);
end loop;
end;
begin
loca_id:='&loca_id';
affichage(loca_id);
end;


----question 5--------------------------------------------------------------------------------------------------

set serveroutput on;
DECLARE 
id_employee orders.salesman_id%type;
PROCEDURE calculeCA(x in orders.salesman_id%type) is
cursor c_order is select order_id FROM orders where salesman_id=x;
id_ord orders.salesman_id%type;
total float;
somme float;
begin
total:=0;
somme:=0;
open c_order;
loop 
fetch c_order into id_ord;
total:=total+somme;
exit when c_order%notfound;
select sum(quantity*unit_price) into somme from order_items where order_id=id_ord;
end loop;
dbms_output.put_line('le CA de lemployee '||x||' est : '||total||' $ ');
end;
begin
id_employee:='&id_employee';
calculeCA(id_employee);
end;
----fonctions-----------------------------------------------------------------------------------------------------------------
----question 1------------------------------------------------------------------------------------
set serveroutput on;
DECLARE
id_order orders.order_id%type;
cus_id orders.CUSTOMER_id%type;
total float;
Function calculePT(x in orders.order_id%type)
return float
is 
total float;
Begin
select sum(quantity*unit_price) into total from order_items where order_id=x;
return total ;
end;
begin
id_order:='&id_order';
select customer_id into cus_id from orders where order_id=id_order;
total:=calculePT(id_order);
dbms_output.put_line('le prix total de la commande '||id_order||' fait par le client numéro '||cus_id||' est : '||total);
end;

----question 2----------------------------------------------------------------------------------------------------------------

set serveroutput on;
DECLARE
Nombre int ;
Function pending_total
return int
is 
Nombre int;
Begin
select count(*) into Nombre from orders where status='Pending';
return Nombre ;
end;
begin
Nombre:=pending_total;
dbms_output.put_line('le nombre de commandes qui ont le statut pending est : '||Nombre);
end;

----declencheurs----------------------------------------------------------------------------------------------------------------

----question 1------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER resume_commande
after insert on ORDERS
for each row
Begin
dbms_output.put_line('la commande numéro : '||:NEW.order_id); 
dbms_output.put_line('Client numéro : '||:NEW.customer_id);
dbms_output.put_line('Status: '||:NEW.status); 
dbms_output.put_line('Salesman numéro : '||:NEW.salesman_id);
dbms_output.put_line('Date d order: '||:NEW.order_date); 
end;
insert into orders values(117,7,'pending',62,to_date('10-mars-20','dd-mon-rr')) 

insert into orders values(110,7,'pending',64,'17/02/2020');

----question 2-----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER alerte
after update on inventories
for each row
Begin
if :new.quantity < 10 then
dbms_output.put_line('alerte quantity is low <10');
end if;
end;

----question 3-----------------------------------------------------------------------------------------------------------------

--Ecrire un déclencheur qui n’autorise pas la modification du CREDIT_LIMIT des clients entre le 28 et 30 de chaque mois
--sol1
CREATE OR REPLACE TRIGGER autorisation
before update of CREDIT_LIMIT on customers
declare
l_day_of_month number;
Begin
l_day_of_month:=extract(day from sysdate);
if l_day_of_month between 1 and 5 then
  raise_application_error(-20100,'demande de modification non autorisé entre le 28 et le 30 de chaque mois');
end if;
end;
--sol2
CREATE OR REPLACE TRIGGER autorisation
before update of credit_limit on customers
for each row
when (extract(day from sysdate)>=1 and extract(day from sysdate)<=5)
Begin
dbms_output.put_line('erreur');
rollback;
end;

update customers set CREDIT_LIMIT=1330 where customer_id=124;

----question 4----------------------------------------------------------------------------------------------------
--Ecrire un déclencheur qui interdit l’ajout d’un employé si HIRE_DATE est > a Date d’aujourd’hui

CREATE OR REPLACE TRIGGER ajout_employee 
after insert on employees
for each row
declare
v_Day            NUMBER := EXTRACT(DAY   FROM SYSDATE);
v_Month          NUMBER := EXTRACT(MONTH FROM SYSDATE);
v_Year           NUMBER := EXTRACT(YEAR  FROM SYSDATE);
v_HiredDAY      NUMBER := EXTRACT(DAY   FROM :new.HIRE_DATE);
v_HiredMONTH    NUMBER := EXTRACT(MONTH FROM :new.HIRE_DATE);
v_HiredYEAR     NUMBER := EXTRACT(YEAR  FROM :new.HIRE_DATE);
PROCEDURE Alert IS
    BEGIN
        raise_application_error(-20827, 'interdit l’ajout de ce employé avant ' || :new.HIRE_DATE);
    END Alert;

BEGIN
IF v_HiredYEAR > v_Year THEN
 Alert();
ELSIF v_HiredYEAR = v_Year THEN

IF v_HiredMONTH > v_Month THEN
 Alert;
ELSIF v_HiredMONTH = v_Month THEN

IF v_HiredDAY > v_Day THEN
 Alert();
 END IF;
 END IF;
 END IF;
END;
----question 5----------------------------------------------------------------------------------------------------------------
--Ecrire un déclencheur qui applique une remise de 5% si le prix total de la commande est > 10000$

set serveroutput on;

create or replace trigger remise 
before insert on order_items
for each row
DECLARE
id_order orders.order_id%type;
cus_id orders.CUSTOMER_id%type;
total float;

Function calculePT(x in orders.order_id%type)
return float
is 
total float;
Begin
select sum(quantity*unit_price) into total from order_items where order_id=x;
return total ;
end;
Begin 
total:=calculePT(:new.Order_id);
if total > 10000 then
:new.unit_price:=:new.unit_price-(:new.unit_price*0.05);
dbms_output.put_line('vous avez benificier d une remise de 5%');
end if;
end;
insert into order_items values(69,10,177,30,1759.99);
