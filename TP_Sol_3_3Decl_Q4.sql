CREATE OR REPLACE TRIGGER t_DeclineEmployeeInsert
    AFTER INSERT ON EMPLOYEES
    FOR EACH ROW
DECLARE
    v_CurrentDay            NUMBER := EXTRACT(DAY   FROM SYSDATE);
    v_CurrentMonth          NUMBER := EXTRACT(MONTH FROM SYSDATE);
    v_CurrentYear           NUMBER := EXTRACT(YEAR  FROM SYSDATE);
    v_EmployeeHiredDAY      NUMBER := EXTRACT(DAY   FROM :new.HIRE_DATE);
    v_EmployeeHiredMONTH    NUMBER := EXTRACT(MONTH FROM :new.HIRE_DATE);
    v_EmployeeHiredYEAR     NUMBER := EXTRACT(YEAR  FROM :new.HIRE_DATE);

    PROCEDURE p_AlertInsertDenied IS
    BEGIN
        raise_application_error(-20827, 'ALERT!!: Nope! You gotta wait till ' || :new.HIRE_DATE || ' to hire this Employee !! ');
    END p_AlertInsertDenied;

BEGIN
    IF v_EmployeeHiredYEAR > v_CurrentYear THEN
        p_AlertInsertDenied();
    ELSIF v_EmployeeHiredYEAR = v_CurrentYear THEN

        IF v_EmployeeHiredMONTH > v_CurrentMonth THEN
            p_AlertInsertDenied();
        ELSIF v_EmployeeHiredMONTH = v_CurrentMonth THEN

            IF v_EmployeeHiredDAY > v_CurrentDay THEN
                p_AlertInsertDenied();
            END IF;
        END IF;
    END IF;
END;