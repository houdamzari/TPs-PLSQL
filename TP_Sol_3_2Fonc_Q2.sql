DECLARE
    v_TotalPendingOrders   NUMBER;

BEGIN
    v_TotalPendingOrders := F_COUNTPENDINGORDERS();
    DBMS_OUTPUT.PUT_LINE('The Number of orders with status "Pending" is: ' || v_TotalPendingOrders);
END;