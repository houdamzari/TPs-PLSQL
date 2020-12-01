CREATE OR REPLACE TRIGGER customers_credit_trg
    BEFORE UPDATE OF credit_limit
    ON customers
DECLARE
    l_day_of_month NUMBER;
BEGIN
    l_day_of_month := EXTRACT(DAY FROM sysdate);

    IF l_day_of_month BETWEEN 1 AND 3 THEN
        raise_application_error(-20100,'Cannot update customer credit from 28th to 31st');
    END IF;
END;