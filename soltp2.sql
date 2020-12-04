qst1:
DECLARE
c_id employees.employee_id%TYPE;
c_firstname employees.first_name%TYPE;
c_lastname employees.last_name%TYPE;
c_job employees.job_title%TYPE;
c_hiredate employees.hire_date%TYPE;
c_mana_id employees.manager_id%TYPE;
CURSOR c_employees is
SELECT employee_id,first_name,last_name,job_title,hire_date,manager_id FROM employees;
BEGIN
OPEN  c_employees;
LOOP
FETCH c_employees INTO c_id,c_firstname,c_lastname,c_job,c_hiredate,c_mana_id;
EXIT WHEN c_employees%notfound;
dbms_output.put_line('Employé :' || c_firstname || ' ' || c_lastname || '(ID: ' || c_id || ')' ||
'travaille comme ' || c_job || 'depuis '|| c_hiredate || 'sous le direction de ' || c_lastname ||
'(matricule : ' || c_mana_id || ').');
END LOOP;
CLOSE c_employees;
END;
_____________________________________________________________________
qst2:
DECLARE
nbr INT;
nbr1 INT;
CURSOR nbr_commande(c_customers customers.customer_id%TYPE) IS
SELECT COUNT(*) FROM orders WHERE customer_id=c_customers;
CURSOR nbr_vente(c_salesman employees.salesman_id%TYPE) IS
SELECT COUNT(*) FROM orders WHERE salesman_id=c_salesman;
BEGIN
OPEN nbr_commande(c_customers);
FETCH nbr_commande INTO nbr;
dbms_output.put_line('nombre de commandes de client est :' || nbr);
CLOSE nbr_commande ;
OPEN nbr_commande(c_salesman);
FETCH nbr_vente INTO nbr1;
dbms_output.put_line('nombre de ventes de l employée est :' || nbr1);
CLOSE nbr_commande ;
END;
___________________________________________________________________
qst3:
DECLARE
nbr INT;
CURSOR nbr_commande2 IS
SELECT customer_id, SUM(quantity * unit_price) FROM orders INNER JOIN order_items USING(order_id) 
GROUP BY customers_id HAVING  SUM(quantity * unit_price)>2000;
BEGIN
nbr:=0;
for i in nbr_commande2
UPDATE customers
SET credit_limit = credit_limit+50;
nbr:=nbr+1;
END LOOP;
CLOSE nbr_commande2;
dbms_output.put_line('le nombre de ligne misent a jour sont :'|| nbr);
END;
_________________________________________________________________________________
qst4:
DECLARE
nbr INT;
CURSOR nbr_commande2 IS
SELECT customer_id, SUM(quantity * unit_price) FROM orders INNER JOIN order_items USING(order_id) 
GROUP BY customers_id HAVING  SUM(quantity * unit_price)>1000;
BEGIN
nbr:=0;
for i in nbr_commande2
UPDATE customers
SET credit_limit = credit_limit+50;
nbr:=nbr+1;
END LOOP;
CLOSE nbr_commande2;
dbms_output.put_line('le nombre de ligne misent a jour sont :'|| nbr);
END;
---------------------------------------------------------------
QST5:
DECLARE
taux_vente float(6);
c_salesman orders.salesman_id%TYPE;
first_date orders.order_date%TYPE;
last_date orders.order_date%TYPE;
table2 float(6);
CURSOR Vente IS
SELECT SUM(quantity * unit_price) AS T12 FROM orders INNER JOIN order_items USING(order_id) 
WHERE salesman_id=c_saleman AND order_date BETWEEN to_date('17-NOV-16','DD-MON-RR') AND to_date('15-FEB-17','DD-MON-RR') ;
BEGIN
SELECT SUM(quantity * unit_price) INTO table2 FROM orders INNER JOIN order_items USING(order_id) WHERE order_date
BETWEEN to_date('17-NOV-16','DD-MON-RR') AND to_date('15-FEB-17','DD-MON-RR');
for i in Vente
LOOP
taux_vente:=100 * ( i.T12 / table2 );
END LOOP;
dbms_output.put_line('le taux de vente est :'|| taux_vente || '%');
END;
________________________________________________________________________________
QST6:
DECLARE
nbr2 INT;
total INT;
CURSOR c_manager_id IS
SELECT employee_id FROM employees WHERE manager_id =47;
BEGIN
total:=0;
if sql%found THEN
for i in c_manager_id
LOOP
SELECT COUNT (*)  INTO nbr2 FROM orders WHERE salesman_id=i.employee_id;
total:= total+nbr2;
END LOOP;
dbms_output.put_line('le nombre de vente est :'|| total);
ELSIF sql%notfound THEN
dbms_output.put_line('ID not found !');
END IF;
END;



