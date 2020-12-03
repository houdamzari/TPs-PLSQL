set serveroutput on;


create or replace Procedure add_warehouse(v_warehouse_name in warehouses.warehouse_name%type , v_location_id in warehouses.location_id%type )is

exist number;
maximum number;
begin

select count(location_id) into exist from LOCATIONS where location_id = v_location_id;
select max(warehouse_id) into maximum from warehouses;

if exist > 0 then
  insert into warehouses(warehouse_id,warehouse_name,location_id) values (maximum+1 ,v_warehouse_name,v_location_id);
  
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
add_warehouse(v_warehouse_name,v_location_id);

end;