DECLARE
    v_EmployeeID        NUMBER;
    v_EmployeeCashFlow  NUMBER;

BEGIN
    v_EmployeeID :=: Enter_Employee_ID;

     P_CALCULATECASHFLOW(v_EmployeeID, v_EmployeeCashFlow);
    DBMS_OUTPUT.PUT_LINE('The CashFlow of this employee (ID: ' || v_EmployeeID ||
                         ') is: ' || v_EmployeeCashFlow || ' $.');
END;