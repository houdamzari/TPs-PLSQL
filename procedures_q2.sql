 set serveroutput on;
 
 
 create or replace procedure update_warehouse(v_warehouse_name in warehouses.warehouse_name%type , v_location_id in warehouses.location_id%type )is

exist number;
maximum number;
begin

select count(location_id) into exist from LOCATIONS where location_id = v_location_id;
select max(warehouse_id) into maximum from warehouses;

if exist > 0 then
UPDATE warehouses SET warehouse_name = v_warehouse_name where location_id = v_location_id;
   dbms_output.put_line('-----------------------------');
     dbms_output.put_line('mise a jour effectue avec succes' );
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
update_warehouse(v_warehouse_name,v_location_id);

end;


