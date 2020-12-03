SET SERVEROUTPUT ON;

create or replace trigger hire
before insert on employees
for each row
declare
    

begin


    IF SYSDATE < :new.hire_date then
        raise_application_error(-20102,'vous pouver pas ajouter un employee qui a la hire_date > a la date d''aujourd''hui ');
    end if;

end;
/



insert into employees values (999,'soufian','chabou','soufainchabou1996@gmail.com','0607864253','04/12/20',1,'student');