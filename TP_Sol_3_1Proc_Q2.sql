DECLARE
    r_UpdatedWarehouse          WAREHOUSES%ROWTYPE;

BEGIN
    r_UpdatedWarehouse.WAREHOUSE_ID    :=: WAREHOUSE_ID;
    r_UpdatedWarehouse.WAREHOUSE_NAME  :=: WAREHOUSE_NAME;
    r_UpdatedWarehouse.LOCATION_ID     :=: LOCATION_ID;

    P_UPDATEWAREHOUSE(r_UpdatedWarehouse);
END;