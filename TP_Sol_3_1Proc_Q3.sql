DECLARE
    v_TargetWarehouseID         NUMBER;

BEGIN
    v_TargetWarehouseID :=: Enter_Warehouse_ID;
    P_DELETEWAREHOUSE(v_TargetWarehouseID);
END;