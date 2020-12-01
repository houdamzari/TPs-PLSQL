DECLARE
    v_TargetLocationID      NUMBER;
    v_WarehouseExist        NUMBER;

BEGIN
    v_TargetLocationID :=: Enter_Location_ID;

    DBMS_OUTPUT.PUT_LINE('---> LOCATION ID : ' || v_TargetLocationID);
    v_WarehouseExist := F_CHECKWAREHOUSEEXISTINLOCATION(v_TargetLocationID);

    IF v_WarehouseExist = 0 THEN
        DBMS_OUTPUT.PUT_LINE('There are no Warehouses in this Location.');
    ELSE
            P_PRINTWAREHOUSESINLOCATION(v_TargetLocationID);
    END IF;
END;