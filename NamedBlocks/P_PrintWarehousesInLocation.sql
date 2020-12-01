CREATE Procedure p_PrintWarehousesInLocation(v_LocationID IN NUMBER) IS
        CURSOR c_GetWarehousesInLocation IS
            SELECT * FROM WAREHOUSES WHERE LOCATION_ID = v_LocationID;
    BEGIN
        FOR Warehouse IN c_GetWarehousesInLocation LOOP
            DBMS_OUTPUT.PUT_LINE('Warehouse ID: ' || Warehouse.WAREHOUSE_ID ||
                                 '.. Warehouse Name: ' || Warehouse.WAREHOUSE_NAME);
        END LOOP;
    END p_PrintWarehousesInLocation;