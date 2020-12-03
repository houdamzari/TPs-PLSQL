set serveroutput on;


create or replace Procedure delete_warehouse(v_warehouse_name in warehouses.warehouse_name%type , v_location_id in warehouses.location_id%type )is

exist number;
maximum number;
begin

select count(location_id) into exist from LOCATIONS where location_id = v_location_id;
select max(warehouse_id) into maximum from warehouses;

if exist > 0 then
delete from warehouses where warehouse_name = v_warehouse_name and location_id = v_location_id;
     dbms_output.put_line('-----------------------------');
     dbms_output.put_line('warehouse supprimer !' );
     dbms_output.put_line('-----------------------------');
else
     dbms_output.put_line('-----------------------------');
     dbms_output.put_line('location doesn''t exist !' );
     dbms_output.put_line('-----------------------------');
end if;
end;



/
declare 
v_warehouse_name  warehouses.warehouse_name%type;
v_location_id  warehouses.location_id%type;

begin
v_warehouse_name:= '&v_warehouse_name';
v_location_id:='&v_location_id';
delete_warehouse(v_warehouse_name,v_location_id);

end;