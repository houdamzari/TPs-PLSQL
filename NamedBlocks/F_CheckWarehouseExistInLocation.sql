CREATE FUNCTION f_CheckWarehouseExistInLocation(v_LocationID IN NUMBER) RETURN NUMBER IS v_WarehouseExist NUMBER;
    BEGIN
        SELECT COUNT(WAREHOUSE_ID) INTO v_WarehouseExist FROM WAREHOUSES WHERE LOCATION_ID = v_LocationID;
        RETURN v_WarehouseExist;
    END f_CheckWarehouseExistInLocation;