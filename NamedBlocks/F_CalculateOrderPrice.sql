CREATE FUNCTION f_CalculateOrderPrice(v_OrderID IN ORDERS.ORDER_ID%TYPE) RETURN NUMBER IS
        v_OrderTotalPrice NUMBER;
    BEGIN
        SELECT SUM(QUANTITY*UNIT_PRICE) INTO v_OrderTotalPrice FROM ORDER_ITEMS WHERE ORDER_ID = v_OrderID;
        RETURN v_OrderTotalPrice;
    END f_CalculateOrderPrice;