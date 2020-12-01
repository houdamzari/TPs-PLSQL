CREATE FUNCTION f_CountPendingOrders RETURN NUMBER IS v_TotalPendingOrders NUMBER;
    BEGIN
        SELECT COUNT(ORDER_ID) INTO v_TotalPendingOrders FROM ORDERS WHERE STATUS = 'Pending';
        RETURN v_TotalPendingOrders;
    END f_CountPendingOrders;