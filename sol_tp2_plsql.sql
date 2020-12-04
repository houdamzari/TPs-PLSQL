----------Question 1---------------------
SET SERVEROUTPUT ON;
DECLARE
CURSOR c_emp IS 
SELECT first_name, last_name, employee_id, job_title, hire_date, manager_id FROM employees;
l_name employees.last_name%TYPE;
BEGIN
FOR N IN c_emp LOOP
IF N.manager_id IS NOT NULL THEN
SELECT last_name INTO l_name FROM employees WHERE employee_id=N.manager_id;
dbms_output.put_line('Employee '|| N.first_name ||' '||N.last_name||' ID : '||N.employee_id||' travaille comme '||N.job_title||' depuis '||N.hire_date||' sous la direction de '||l_name||' de matricule '||N.manager_id);
ELSE
dbms_output.put_line('Employee '|| N.first_name ||' '||N.last_name||' ID : '||N.employee_id||' travaille comme '||N.job_title||' depuis '||N.hire_date||' C est le directeur!');
END IF;
END LOOP;
END;
----------------------------------

-------------Question 2-1 -----------------
SET SERVEROUTPUT ON
DECLARE 
i INTEGER:=0;

cus_id orders.customer_id%TYPE;
id_c number;
    CURSOR n_orders IS 
    SELECT * FROM orders WHERE customer_id=id_c;
    CURSOR n_customers IS 
    SELECT * FROM customers;
    BEGIN
    FOR N IN n_customers LOOP
    id_c := N.customer_id;
    FOR M IN n_orders LOOP
    i:=i+1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Nombre de commande du '||N.name||' est :'||i);
    i:=0;
    END LOOP;
    END;
-----------------------------------------------

---------------Question 2-2---------------------
SET SERVEROUTPUT ON

DECLARE 

i INTEGER:=0;
emp_id number;

    CURSOR n_orders IS 
    SELECT * FROM orders WHERE salesman_id=emp_id;
    
    CURSOR n_employees IS 
    SELECT * FROM employees;
    
    BEGIN
    FOR N IN n_employees LOOP
    emp_id := N.employee_id;
    FOR M IN n_orders LOOP
    i:=i+1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Nombre de ventes de l employee qui a l ID : '||N.employee_id||' est :'||i);
    i:=0;
    END LOOP;
    END;
------------------------------------------------------    

---------------Question 3---------------------
SET SERVEROUTPUT ON
DECLARE 
    CURSOR c_clients IS
        SELECT customer_id, SUM(unit_price * quantity) 
        FROM ORDERS
        INNER JOIN ORDER_ITEMS USING(ORDER_ID)
        GROUP BY customer_id
        having SUM(unit_price * quantity) > 2000;
    
counter INTEGER;
BEGIN
   counter:=0;
    FOR N IN c_clients LOOP
        UPDATE CUSTOMERS 
        SET credit_limit=credit_limit+50
        WHERE customer_id= N.customer_id;
        counter := counter + 1;    
    END LOOP;
            DBMS_OUTPUT.PUT_LINE(' Le nombre de clients mis a jour est: '|| counter ); 
END;

------------------------------------------------------  

---------------Question 4----------------------------

SET SERVEROUTPUT ON
DECLARE 
    CURSOR c_clients IS
        SELECT customer_id, SUM(unit_price * quantity) 
        FROM ORDERS
        INNER JOIN ORDER_ITEMS USING(ORDER_ID)
        GROUP BY customer_id
        having SUM(unit_price * quantity) > 10000;
    
counter INTEGER;
BEGIN
   counter:=0;
    FOR N IN c_clients LOOP
        UPDATE CUSTOMERS 
        SET credit_limit=credit_limit+50
        WHERE customer_id= N.customer_id;
        counter := counter + 1;    
    END LOOP;
            DBMS_OUTPUT.PUT_LINE(' Le nombre de clients mis a jour est: '|| counter ); 
END;

------------Question 5-----------------------------------

SET SERVEROUTPUT ON
DECLARE 
        v_agent orders.salesman_id%type;
        enter_date orders.order_date%type;
        end_date orders.order_date%type;
        taux_vente float(15);
        sum1 float(15);


    CURSOR c_salesman IS
        SELECT SUM(unit_price * quantity) AS total_s FROM ORDERS
        INNER JOIN ORDER_ITEMS USING(ORDER_ID)
        WHERE order_date BETWEEN enter_date AND end_date
        AND salesman_id = v_agent;
        
BEGIN
    v_agent:=&v_agent;
    enter_date:='&enter_date';
    end_date:='&end_date';
    sum1:=0;
 
 --calcul totalite de ventes des employees--
 
        SELECT SUM(unit_price * quantity) INTO sum1 FROM ORDERS
        INNER JOIN ORDER_ITEMS USING(ORDER_ID)
        WHERE order_date BETWEEN enter_date AND end_date;
    
    DBMS_OUTPUT.PUT_LINE(' Le total de vente entre ces deux dates est: ' || sum1 || ' dollars'); 
    
    FOR j in c_salesman LOOP
        taux_vente := 100 * j.total_s/sum1;
        DBMS_OUTPUT.PUT_LINE('le taux de vente de l employee d id: '|| v_agent || ' est egale a: ' || taux_vente || '%');
    END LOOP;
END;











