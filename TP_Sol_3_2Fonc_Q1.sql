DECLARE
    v_CustomerID        NUMBER;
    v_OrderID           NUMBER;
    v_OrderTotalPrice   NUMBER;

BEGIN
    v_CustomerID    :=: v_CustomerID;
    v_OrderID       :=: v_OrderID;

    v_OrderTotalPrice := F_CALCULATEORDERPRICE(v_OrderID);

    DBMS_OUTPUT.PUT_LINE('The total price for the Order N°' || v_OrderID || ' for the Customer N°'
                            || v_CustomerID || ' is: ' || v_OrderTotalPrice);

END;