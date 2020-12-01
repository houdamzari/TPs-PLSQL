CREATE PROCEDURE p_UpdateWarehouse(r_UpdatedWarehouse IN WAREHOUSES%ROWTYPE) IS
BEGIN
    UPDATE WAREHOUSES
        SET WAREHOUSE_NAME  = r_UpdatedWarehouse.WAREHOUSE_NAME,
            LOCATION_ID     = r_UpdatedWarehouse.LOCATION_ID
        WHERE WAREHOUSE_ID  = r_UpdatedWarehouse.WAREHOUSE_ID;
END p_UpdateWarehouse;
