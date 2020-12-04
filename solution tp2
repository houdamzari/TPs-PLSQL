SET SERVEROUTPUT ON;
DECLARE
     cursor cusRec is select * from EMPLOYEES;
     counter integer := 0;
     v_manager EMPLOYEES%rowtype;
BEGIN
             for i in cusRec LOOP
             DBMS_OUTPUT.PUT_LINE('employé ' || n.first_name || ' '  || n.last_name || '(id ' || n.employee_id
             || ')' || 'travaille comme ' || n.job_title || 'depuis ' || n.hire_date);
                 if n.manager_id is not null then
                 select * into r_manager from employees where employee_id = n.manager_id;
                 DBMS_OUTPUT.PUT_LINE('sous la direction de ' || r_manager.last_name || ' ( id '|| r_manager.employee_id
                 || ' )' );
                 end if;
                 DBMS_OUTPUT.PUT_LINE('   ');
 END;



-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-

SET SERVEROUTPUT ON;    

DECLARE
/* Curseur de customers */
      CURSOR c_customer (v_customer_id orders.customer_id%type ) is
      SELECT * from orders where customer_id=v_customer_id;
/*Curseur des employées */
      CURSOR c_employee (v_salesman_id orders.salesman_id%type ) is
      SELECT * from orders where salesman_id=v_salesman_id;

     c_id orders.customer_id%type;
    counter integer;
      counter2 integer;
   
begin
c_id:=&c_id;
counter :=0;
for i in c_customer(c_id) loop
counter := counter + 1;
end loop;

DBMS_OUTPUT.PUT_LINE('The Customer ' || c_id || ' had ' || counter || ' Orders');

c_id:=&c_id;
counter :=0;
for i in c_employee(c_id) loop
counter := counter + 1;
end loop;

DBMS_OUTPUT.PUT_LINE('The Employee ' || c_id || ' had ' || counter || ' Sales');


END;


-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-

SET SERVEROUTPUT ON;    

DECLARE
/* Curseur de customers */
      CURSOR c_customer is
      SELECT
      customer_id , SUM(QUANTITY*UNIT_PRICE)
      FROM orders
      INNER JOIN order_items USING( order_id )
      group by customer_id
      having SUM(QUANTITY*UNIT_PRICE) > 2000;
    
c integer;
    
begin
c:=0;
 for i in c_customer loop
   update customers set credit_limit=credit_limit+50
   where customer_id=i.customer_id;
   c:=c+1;
   end loop;
   DBMS_OUTPUT.PUT_LINE('Nombre de lignes affectés est : ' || sql%rowcount);
   
   DBMS_OUTPUT.PUT_LINE('Nombre de lignes affectés est :' || c);
END;

-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 4 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-


SET SERVEROUTPUT ON;    

DECLARE
/* Curseur de customers */
      CURSOR c_customer is
      SELECT
      customer_id , SUM(QUANTITY*UNIT_PRICE)
      FROM orders
      INNER JOIN order_items USING( order_id )
      group by customer_id
      having SUM(QUANTITY*UNIT_PRICE) > 10000;
    
c integer;
    
begin
c:=0;
 for i in c_customer loop
   update customers set credit_limit=credit_limit+50
   where customer_id=i.customer_id;
   c:=c+1;
   end loop;

   
   DBMS_OUTPUT.PUT_LINE('Nombre de lignes affectés est :' || c);
END;

-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 5 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-


SET SERVEROUTPUT ON;    

DECLARE

        v_salesman orders.salesman_id%type;
        date_start orders.order_date%type;
        date_end orders.order_date%type;
        taux float;
        sum1 integer;

/* Curseur de l'employé spécifique */ 

      Cursor c_salesman is
      select  sum(QUANTITY*unit_price) as total_salesman from orders 
      INNER JOIN order_items USING( order_id )
      WHERE order_date BETWEEN date_start AND date_end 
      AND salesman_id=v_salesman;
      
BEGIN

        v_salesman:=&v_salesman;
        date_start:='&date_start';
        date_end:='&date_end';
        
        select sum(QUANTITY*unit_price) into sum1 from orders 
        INNER JOIN order_items USING( order_id )
        WHERE order_date BETWEEN date_start AND  date_end;

        DBMS_OUTPUT.PUT_LINE('le taux total de vente dans cette periode est' || sum1 || '$');
        
        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
    for j in c_salesman loop
        taux:=j.total_salesman/sum1;
        DBMS_OUTPUT.PUT_LINE('le taux de '|| v_salesman || ' est ' || round(taux,2) || '%');
    end loop;

END;

-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Question 6 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-

SET SERVEROUTPUT ON;    

DECLARE
 v_manager_id employees.manager_id%type;
 booleen integer;  
 total integer;

     CURSOR managers is
        select manager_id  from employees
        where manager_id is not null
        group by manager_id;
        
       
        
     CURSOR employees_list is             
     select employee_id,count(salesman_id) as total from employees
     LEFT JOIN orders ON employees.employee_id = orders.salesman_id
     where manager_id=&v_manager_id
     group by employee_id;

      
BEGIN
v_manager_id:=&v_manager_id;

for i in managers loop
    if i.manager_id=v_manager_id then
            booleen:=1;
            exit;
    else 
            booleen:=0;
            end if;
end loop;
        if booleen=0 then
            DBMS_OUTPUT.PUT_LINE('ID non trouvable');
        else
            for m in employees_list loop
              DBMS_OUTPUT.PUT_LINE('le nombre de vente de ' || m.employee_id || ' est ' || m.total);
           end loop;
        end if ;
END;
