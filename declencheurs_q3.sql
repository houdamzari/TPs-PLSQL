SET SERVEROUTPUT ON;

create or replace trigger credit_limit 
before update of credit_limit on customers

declare
    DAY_OF_MONTH number;

begin

    DAY_OF_MONTH := EXTRACT( DAY FROM SYSDATE);
    IF DAY_OF_MONTH between 28 and 30 then
        raise_application_error(-20100,'cannot update credit limit between 28 and 30');
    end if;

end;
/
update customers set credit_limit = 7777 where customer_id= 184;