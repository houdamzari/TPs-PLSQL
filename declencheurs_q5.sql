SET SERVEROUTPUT ON;


CREATE OR REPLACE TRIGGER REMISE
before insert on order_items
for each row

begin
    if (:new.unit_price * :new.quantity) > 10000 then
    :new.unit_price := :new.unit_price * 0.95;
    dbms_output.put_line('remise effectuee avec succes !');
    end if;


end;

/ 

insert into order_items values (70,8,32,200,1000);