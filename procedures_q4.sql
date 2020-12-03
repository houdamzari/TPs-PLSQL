
create or replace procedure show_warehouse(v_location_id in warehouses.location_id%type) is
cursor c_warehouse is
select * from warehouses;
begin

 for i in c_warehouse loop
    if i.location_id = v_location_id then
    DBMS_OUTPUT.PUT_LINE('warehouse id : '||i.warehouse_id);
    DBMS_OUTPUT.PUT_LINE('warehouse name : '||i.warehouse_name);
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    end if;
 end loop;

end;


/
declare 
v_location_id  warehouses.location_id%type;

begin

v_location_id:='&v_location_id';
show_warehouse(v_location_id);

end;


