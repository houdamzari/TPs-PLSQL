------PROCEDUES----------
------Question 1---------

SET SERVEROUTPUT ON;

DECLARE

id_warehouse warehouses.warehouse_id%TYPE;
name_warehouse warehouses.warehouse_name%TYPE;
id_location warehouses.location_id%TYPE;
COUNTER NUMBER;

PROCEDURE add_warehouse(id_warehouse IN warehouses.warehouse_id%TYPE, name_warehouse IN warehouses.warehouse_name%TYPE, id_location IN warehouses.location_id%TYPE) IS
BEGIN
INSERT INTO warehouses (warehouse_id, warehouse_name, location_id) VALUES (id_warehouse, name_warehouse, id_location);
END;
BEGIN
SELECT MAX(warehouse_id) INTO COUNTER FROM warehouses;
id_warehouse:=COUNTER + 1;
name_warehouse:='&name_warehouse';
id_location:=&id_location;
add_warehouse(id_warehouse,name_warehouse,id_location);

END;
-------------------------
-------------------------

------Question 2---------

SET SERVEROUTPUT ON;

DECLARE

id_warehouse warehouses.warehouse_id%TYPE;
name_warehouse warehouses.warehouse_name%TYPE;
id_location warehouses.location_id%TYPE;

PROCEDURE update_warehouse(id_warehouse IN warehouses.warehouse_id%TYPE, name_warehouse IN warehouses.warehouse_name%TYPE, id_location IN warehouses.location_id%TYPE) IS
BEGIN

UPDATE warehouses SET warehouse_name=name_warehouse WHERE location_id = id_location;
END;

BEGIN
id_warehouse:=&id_warehouse;
id_location:=&id_location;
name_warehouse:='&name_warehouse';
update_warehouse(id_warehouse,name_warehouse,id_location);
END;
-------------------------
-------------------------

------Question 3---------
SET SERVEROUTPUT ON;

DECLARE
id_warehouse warehouses.warehouse_id%TYPE;
PROCEDURE delete_warehouse(id_warehouse IN warehouses.warehouse_id%TYPE) IS
BEGIN
DELETE FROM warehouses WHERE warehouse_id = id_warehouse;
END;
BEGIN
id_warehouse:=&id_warehouse;
delete_warehouse(id_warehouse);
END;
-------------------------
-------------------------

------Question 4---------
SET SERVEROUTPUT ON;

DECLARE

id_warehouse warehouses.warehouse_id%TYPE;
name_warehouse warehouses.warehouse_name%TYPE;
id_location warehouses.location_id%TYPE;
CURSOR c_warehouses IS SELECT warehouse_name FROM warehouses WHERE location_id=id_location;

PROCEDURE check_warehouse(id_location IN warehouses.location_id%TYPE) IS
BEGIN
FOR N IN c_warehouses LOOP
dbms_output.put_line(N.warehouse_name);
END LOOP;
END;

BEGIN
id_location:=&id_location;
check_warehouse(id_location);
END;
-------------------------
-------------------------

------Question 5---------
