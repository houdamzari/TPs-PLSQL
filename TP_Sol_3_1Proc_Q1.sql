DECLARE
    r_Warehouse         WAREHOUSES%ROWTYPE;

    PROCEDURE p_InputWarehouse IS
    BEGIN
        r_Warehouse.WAREHOUSE_NAME  :=: WAREHOUSE_NAME;
        r_Warehouse.LOCATION_ID     :=: LOCATION_ID;
    end p_InputWarehouse;

BEGIN
    p_InputWarehouse();
    P_ADDWAREHOUSE(r_Warehouse);
END;