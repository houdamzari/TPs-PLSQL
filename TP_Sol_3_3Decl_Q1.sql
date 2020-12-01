CREATE OR REPLACE TRIGGER t_OrderSummary
    BEFORE INSERT OR UPDATE ON ORDERS
    FOR EACH ROW
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('==> New Order Added:  ');
    DBMS_OUTPUT.PUT_LINE('Order ID      : ' || :new.ORDER_ID);
    DBMS_OUTPUT.PUT_LINE('Customer ID   : ' || :new.CUSTOMER_ID);
    DBMS_OUTPUT.PUT_LINE('Status ID     : ' || :new.STATUS);
    DBMS_OUTPUT.PUT_LINE('Salesman ID   : ' || :new.SALESMAN_ID);
    DBMS_OUTPUT.PUT_LINE('Order Date    : ' || :new.ORDER_DATE);
END;
