CREATE PROCEDURE p_DeleteWarehouse(v_TargetWarehouseID IN NUMBER) IS
    BEGIN
        DELETE FROM WAREHOUSES WHERE WAREHOUSE_ID = v_TargetWarehouseID;
        DBMS_OUTPUT.PUT_LINE('DONE: Warehouse Deleted !!');
    END p_DeleteWarehouse;