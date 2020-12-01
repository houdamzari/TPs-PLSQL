CREATE FUNCTION f_CalculateCashFlow(v_EmployeeID IN NUMBER) RETURN NUMBER IS
        v_EmployeeCashFlow NUMBER;
    BEGIN
        SELECT SUM(QUANTITY * UNIT_PRICE) INTO v_EmployeeCashFlow
        FROM ORDER_ITEMS OI JOIN ORDERS O ON O.ORDER_ID = OI.ORDER_ID
        WHERE O.SALESMAN_ID=v_EmployeeID;

        IF v_EmployeeCashFlow IS NULL THEN
            v_EmployeeCashFlow := 0;
        END IF;
        RETURN v_EmployeeCashFlow;
    END f_CalculateCashFlow;