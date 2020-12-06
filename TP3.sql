--procedures
--question1:
SET SERVEROUTPUT ON;
DECLARE

lll locations.CITY%type;
location_id WAREHOUSES.LOCATION_ID%type;
nom WAREHOUSES.WAREHOUSE_NAME%type;
war  WAREHOUSES.WAREHOUSE_ID%type;
cursor c_location is 
select CITY from LOCATIONS where LOCATION_ID = location_id  ;

procedure ajoute ( id_location  in out  WAREHOUSES.LOCATION_ID%type,name in WAREHOUSES.WAREHOUSE_NAME%type,war in  WAREHOUSES.WAREHOUSE_ID%type)is

begin
select CITY  into lll  from locations where LOCATION_ID = id_location  ;

insert into  WAREHOUSES values (war,name,id_location ) ;
 DBMS_OUTPUT.PUT_LINE('werhouses ajouter '  );
 exception
 when no_data_found then
 DBMS_OUTPUT.PUT_LINE(' id ocation n existe pas '  );
 when others then 
 DBMS_OUTPUT.PUT_LINE(' id  werhouses deja existe '  );
end;
begin
 location_id   := '&v_location_id';
 nom := '&v_nom';
 war := '&v_war';
ajoute(location_id, nom, war);
end;
 
 ---------------------------------------------------------------------------------------------------------------------------------
 --question2;
 SET SERVEROUTPUT ON;
DECLARE
 location_id WAREHOUSES.LOCATION_ID%type;
nom WAREHOUSES.WAREHOUSE_NAME%type;
name WAREHOUSES.WAREHOUSE_NAME%type;
procedure mise_jour ( id_location  in   WAREHOUSES.LOCATION_ID%type,name in WAREHOUSES.WAREHOUSE_NAME%type,nv in WAREHOUSES.WAREHOUSE_NAME%type)is

begin
update WAREHOUSES set WAREHOUSE_NAME = nv  where LOCATION_ID =id_location and WAREHOUSE_NAME =name;
end;

begin
 location_id   := '&v_location_id';
 nom := '&v_nom';
 name := '&nv_nom';
mise_jour (location_id, nom, name);
 DBMS_OUTPUT.PUT_LINE(' mise a jour succées '  );
end;
-------------------------------------------------------------------------------------------------------------------------
--question3
SET SERVEROUTPUT ON;
DECLARE
war_id  WAREHOUSES.WAREHOUSE_ID%type;
nom WAREHOUSES.WAREHOUSE_NAME%type;
procedure supprimer ( war in  WAREHOUSES.WAREHOUSE_ID%type)is
begin
delete from WAREHOUSES  where WAREHOUSE_ID = war ;
end;
begin
war_id   := '&v_warehouses_id';
 select WAREHOUSE_NAME into nom from WAREHOUSES  where WAREHOUSE_ID = war_id ;
 supprimer(war_id);
 exception 
when no_data_found then
DBMS_OUTPUT.PUT_LINE('id introuvable '  );
 end;
 --------------------------------------------------------------------------------------------------------------------
 --question4:
 
 SET SERVEROUTPUT ON;
DECLARE
location_id WAREHOUSES.LOCATION_ID%type;
nom WAREHOUSES.WAREHOUSE_NAME%type;
warhouses_id  WAREHOUSES.WAREHOUSE_ID%type;
procedure affiche( id_location  in WAREHOUSES.LOCATION_ID%type,name out WAREHOUSES.WAREHOUSE_NAME%type,war_id out  WAREHOUSES.WAREHOUSE_ID%type)is
cursor c_werhouses is 
select WAREHOUSE_ID,WAREHOUSE_NAME from warehouses where LOCATION_ID = id_location ;
begin
open c_werhouses;
loop
fetch c_werhouses into war_id,name;
exit when c_werhouses%notfound;
 DBMS_OUTPUT.PUT_LINE(' le nom de warehouses  est:' || name );
DBMS_OUTPUT.PUT_LINE('de id :' || war_id );
end loop;
close c_werhouses;
end;
 begin
 location_id := '&v_location_id';
 affiche(location_id,nom ,warhouses_id );
 end;
 
----------------------------------------------------------------------------------------------------------------------------
--question 5:
SET SERVEROUTPUT ON;
DECLARE
employe_id   orders.SALESMAN_ID%type;
procedure ca( id_employe  in orders.SALESMAN_ID%type)is
cursor c_orders is 
select ORDER_ID from orders where SALESMAN_ID = id_employe ;
TOTAL_ACHAT int :=0;
  PRIX int :=0;
 id_orde  ORDERS.ORDER_ID%type;
 begin
 open c_orders;
loop
fetch c_orders into id_orde;
exit when c_orders%notfound;
 SELECT sum(unit_price*quantity) INTO PRIX FROM order_items  WHERE order_items.order_id = id_orde;
        TOTAL_ACHAT := TOTAL_ACHAT+PRIX;
        end loop;
        close c_orders;
        dbms_output.put_line('ca de employee est' ||TOTAL_ACHAT);
 end;
 begin
 employe_id := '&id_employee';
  ca( employe_id);
 end;
 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 ---fonction
 --question1:
 
 SET SERVEROUTPUT ON;
DECLARE
id_comm ORDERS.ORDER_ID%type;
c number;
function total(id_order in ORDERS.ORDER_ID%type) return number is 
prix_total int :=0;
prix int :=0;
cursor c_orders is 
select sum(unit_price*quantity) from order_items where ORDER_ID = id_order ;
begin
 open c_orders;
loop
fetch c_orders into prix;
exit when c_orders%notfound;
prix_total := prix_total+prix;

    end loop;
        close c_orders;
        return prix_total;
end;
 begin
 id_comm := '&id_commande';
c:= total ( id_comm);
dbms_output.put_line('prix total de la commande ' ||id_comm|| 'est' ||c);
 end;
 ----------------------------------------------------------------------------------------------------------------
  --question2:
SET SERVEROUTPUT ON;
DECLARE
c number;
function nombre_pending return number is 
nombre number;
begin
 select COUNT(*) into nombre FROM ORDERS where STATUS='Pending';
 return nombre;
 end;
 begin
 c:= nombre_pending;
dbms_output.put_line(' nombre de commande qui ont le statut : Pending  ' || c);
 end; 

 -------------------------------------------------------------------------------------------------------
 --------------------Déclencheurs :
 --question1:
 create or replace trigger resume
 before insert on orders 
 for each row
 --declare 
 begin
 dbms_output.put_line(' la commande de id' || :NEW.ORDER_ID);
 dbms_output.put_line(' la commande de satut' || :NEW.STATUS);
 dbms_output.put_line('  id de client ' || :NEW.CUSTOMER_ID);
 dbms_output.put_line(' la date de commande' || :NEW.ORDER_DATE);
 end;


 insert into ORDERS (ORDER_ID,CUSTOMER_ID,STATUS,SALESMAN_ID,ORDER_DATE) values (200,1,'sHIPPED',54,to_date('17-juin-16','DD-MON-RR'));
--------------------------------------------------------------------------------------------------------------------------------------------
--questin2;
 create or replace trigger alert
 after update on inventories 
 for each row
 --declare 
 begin
 if :new.QUANTITY <10 then
 
 dbms_output.put_line(' alert');
 end if;
 end;
---------------------------------------------------------------------------------------------------------------------------------------
--question3:
 create or replace trigger limit
 before update of CREDIT_LIMIT on CUSTOMERS
 declare
 date number;
 begin
date := EXTRACT (DAY from sysdate);
if date between 1 and 8 then
  raise_application_error(-20100,'Cannot update customer credit from 28th to 31st');
   --rollback;
 end if;
 end;
 update customers set CREDIT_LIMIT =2 where CUSTOMER_ID= 262;
-----------------------------------------------------------------------------------------------------------------------------
--question4:
CREATE OR REPLACE TRIGGER interdit
    AFTER INSERT ON EMPLOYEES
    FOR EACH ROW
DECLARE
    v_Day  NUMBER := EXTRACT(DAY   FROM SYSDATE);
    v_Month  NUMBER := EXTRACT(MONTH FROM SYSDATE);
    v_Year   NUMBER := EXTRACT(YEAR  FROM SYSDATE);
    v_HiredDAY    NUMBER := EXTRACT(DAY   FROM :new.HIRE_DATE);
    v_HiredMONTH  NUMBER := EXTRACT(MONTH FROM :new.HIRE_DATE);
    v_HiredYEAR   NUMBER := EXTRACT(YEAR  FROM :new.HIRE_DATE);

    PROCEDURE Insertemploye IS
    BEGIN
        raise_application_error(-20827, 'impossible ajouter cette employee '  ');
    END Insertemploye;

BEGIN
    IF v_HiredYEAR > v_Year THEN
        Insertemploye();
    ELSIF v_HiredYEAR = v_Year THEN

        IF v_HiredMONTH > v_Month THEN
             Insertemploye();
        ELSIF v_HiredMONTH = v_Month THEN

            IF v_HiredDAY > v_Day THEN
               Insertemploye();
            END IF;
        END IF;
    END IF;
END;


insert into  EMPLOYEES values (200,'mes','sHIPPED','gfdsq',2345678,to_date('17-juin-12','DD-MON-RR'),23,'stock');
-----------------------------------------------------------------------------------------------------------------
--question5:
CREATE OR REPLACE TRIGGER remise
    before insert on order_items
    FOR EACH ROW
DECLARE
c float;
function total(id_order in ORDERS.ORDER_ID%type) return float is 
prix_total float :=0;
prix float :=0;
cursor c_orders is 
select sum(unit_price*quantity) from order_items where ORDER_ID = id_order ;
begin
 open c_orders;
loop
fetch c_orders into prix;
exit when c_orders%notfound;
prix_total := prix_total+prix;

    end loop;
        close c_orders;
        return prix_total;
        --dbms_output.put_line('prix total de la commande ' ||id_order|| 'est' ||prix_total);
end;

BEGIN
 c:= total (:new.ORDER_ID);
 if c > 10000 then
  :new.UNIT_PRICE :=:new.UNIT_PRICE -(:new.UNIT_PRICE*0.05);
 end if ;
 
end;
 

insert into  order_items values (69,10,177,30,1759.99);







 
 
 
 