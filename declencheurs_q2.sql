set SERVEROUTPUT on;

create or replace trigger alert
after update on inventories
for each row
begin
    IF :NEW.quantity < 10 THEN
    dbms_output.put_line('attention la quantité est : '|| :new.quantity );
    END IF;
end;
/

update inventories set quantity = quantity - 112 where (product_id = 191 AND warehouse_id = 9);