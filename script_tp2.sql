---Question 1---
SET SERVEROUTPUT ON
DECLARE 
    CURSOR c_employees IS
        SELECT first_name, last_name, employee_id, job_title, hire_date, manager_id from EMPLOYEES;
        last_name_mg employees.last_name%type;
   
    BEGIN
        FOR i IN c_employees LOOP
            IF i.manager_id IS NOT NULL THEN
                SELECT last_name INTO last_name_mg FROM employees WHERE employee_id=i.manager_id;
                DBMS_OUTPUT.PUT_LINE('La situation de l employee est: EMPLOYEE ' || i.first_name || i.last_name || ' de ID ' || i.employee_id || ' travaille comme ' || i.job_title || ' depuis ' || i.hire_date || ' sous la direction de ' || last_name_mg || ' de matricule:' || i.manager_id);
            ELSE
                DBMS_OUTPUT.PUT_LINE('La situation de l employee est: EMPLOYEE ' || i.first_name || i.last_name || ' de ID ' || i.employee_id || ' travaille comme ' || i.job_title || ' depuis ' || i.hire_date || ' le directeur n a pas de manager');
            END IF;
        END LOOP;
END;

---Question 2 partie 1---
SET SERVEROUTPUT ON
DECLARE 
cus_id orders.customer_id%type;
n_orders NUMBER:=0;
    CURSOR c_nbr_orders IS
        SELECT * from orders where customer_id = cus_id;
    CURSOR c_nbr_customers IS
        SELECT * from customers;
 
BEGIN
    FOR i IN c_nbr_customers LOOP
        cus_id := i.customer_id;
        FOR j IN c_nbr_orders LOOP
            n_orders := n_orders+1;
        END LOOP;
            DBMS_OUTPUT.PUT_LINE(' Le nombre de commandes du client ' || i.name ||' est: ' || n_orders);
            n_orders:=0;
    END LOOP;
END;

---Question 2 partie 2---
SET SERVEROUTPUT ON
DECLARE 
e_id number;
n_ventes NUMBER:=0;
    CURSOR c_nbr_orders IS
        SELECT * from orders where salesman_id=e_id;
        
    CURSOR c_nbr_employees IS
        SELECT * from employees;
 
BEGIN
    FOR i IN c_nbr_employees LOOP
        e_id := i.employee_id;
        FOR j IN c_nbr_orders LOOP
            n_ventes := n_ventes+1;
        END LOOP;
            DBMS_OUTPUT.PUT_LINE(' Le nombre de ventes de l employee qui a l id : ' || i.employee_id ||' est: ' || n_ventes);
            n_ventes:=0;
    END LOOP;
END;

---Question 2 another method---
SET SERVEROUTPUT ON
DECLARE 
    /* Cursor of customers */
    CURSOR c_nbr_orders (cus_id orders.customer_id%TYPE)IS
        SELECT * from orders where customer_id = cus_id;
        
    /* Cursor of employees */
    CURSOR c_nbr_sales (emp_id orders.salesman_id%TYPE)IS
        SELECT * from orders where salesman_id = emp_id;
        
c_id orders.customer_id%TYPE;
e_id orders.salesman_id%TYPE;
        
n_orders INTEGER;
n_sales INTEGER;

BEGIN
    c_id:=&c_id;
    n_orders:=0;
    FOR i IN c_nbr_orders(c_id) LOOP
        n_orders := n_orders+1;   
    END LOOP;
            DBMS_OUTPUT.PUT_LINE(' Le nombre de commandes du client id: ' || c_id ||' est: ' || n_orders);
            
    e_id:=&e_id;
    n_sales:=0;
    FOR i IN c_nbr_sales(e_id) LOOP
        n_sales := n_sales+1;   
    END LOOP;
            DBMS_OUTPUT.PUT_LINE(' Le nombre de ventes de l employee id: ' || e_id ||' est: ' || n_sales);
END;

---Question 3---
SET SERVEROUTPUT ON
DECLARE 
    CURSOR c_client IS
        SELECT customer_id, SUM(unit_price * quantity) 
        FROM ORDERS
        INNER JOIN ORDER_ITEMS USING(ORDER_ID)
        GROUP BY customer_id
        having SUM(unit_price * quantity) > 2000;
    
n INTEGER;
BEGIN
    n:=0;
    FOR i IN c_client LOOP
        UPDATE CUSTOMERS 
        SET credit_limit= credit_limit+50
        WHERE customer_id= i.customer_id;
        n:=n+1;    
    END LOOP;
            DBMS_OUTPUT.PUT_LINE(' Le nombre de clients mis a jour est: ' || n); 
END;

---Question 4---
SET SERVEROUTPUT ON
DECLARE 
    CURSOR c_client IS
        SELECT customer_id, SUM(unit_price * quantity) 
        FROM ORDERS
        INNER JOIN ORDER_ITEMS USING(ORDER_ID)
        GROUP BY customer_id
        having SUM(unit_price * quantity) > 10000;
    
n INTEGER;
BEGIN
    n:=0;
    FOR i IN c_client LOOP
        UPDATE CUSTOMERS 
        SET credit_limit= credit_limit+50
        WHERE customer_id= i.customer_id;
        n:=n+1;    
    END LOOP;
            DBMS_OUTPUT.PUT_LINE(' Le nombre de clients mis a jour est: ' || n); 
END;

---Question 5---
SET SERVEROUTPUT ON
DECLARE 
        v_seller orders.salesman_id%type;
        first_date orders.order_date%type;
        last_date orders.order_date%type;
        taux_vente float(10);
        sum1 float(10);

/*Cursor of a specific salesman */
    CURSOR c_salesman IS
        SELECT SUM(unit_price * quantity) AS total_sales FROM ORDERS
        INNER JOIN ORDER_ITEMS USING(ORDER_ID)
        WHERE order_date BETWEEN first_date AND last_date
        AND salesman_id = v_seller;
        
BEGIN
    v_seller:=&v_seller;
    first_date:='&first_date';
    last_date:='&last_date';
    sum1:=0;
    
        SELECT SUM(unit_price * quantity) INTO sum1 FROM ORDERS
        INNER JOIN ORDER_ITEMS USING(ORDER_ID)
        WHERE order_date BETWEEN first_date AND last_date;
    
    DBMS_OUTPUT.PUT_LINE(' Le total de vente entre ces deux dates est: ' || sum1 || '$'); 
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------');
    FOR j in c_salesman LOOP
        taux_vente := 100 * j.total_sales/sum1;
        DBMS_OUTPUT.PUT_LINE('le taux de vente de l employee d id: '|| v_seller || ' est egale a: ' || taux_vente || '%');
    END LOOP;
END;

---Question 6---
SET SERVEROUTPUT ON;    
DECLARE
 m_id employees.manager_id%type;
 exist integer;  
 total integer;

     CURSOR managers is
        select manager_id  from employees
        where manager_id is not null
        group by manager_id;
             
     CURSOR listing_emp is 
     select employee_id,count(salesman_id) as total from employees
     LEFT JOIN orders ON employees.employee_id = orders.salesman_id
     where manager_id=m_id
     group by employee_id;
     
BEGIN
m_id:=&m_id;
for i in managers loop
    if i.manager_id=m_id then
            exist:=1;
            exit;
    else 
            exist:=0;
            end if;
end loop;
        if  exist=0 then
            DBMS_OUTPUT.PUT_LINE('ID non trouvable');
        else
            for j in listing_emp loop
              DBMS_OUTPUT.PUT_LINE('le nombre de vente de ' || j.employee_id || ' est ' || j.total);
           end loop;
        end if ;
END;
