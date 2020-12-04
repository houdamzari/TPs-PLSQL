
QST1:
DECLARE
CREATE OR REPLACE PROCEDURE add_wharehouse(ware_name IN warehouses. warehouse_name%TYPE , loca_id IN warehouses.location_id%TYPE) IS
BEGIN
INSERT INTO warehouses(warehouse_name,location_id) values (ware_name,loca_id);
END;
BEGIN
add_wharehouse(&ware_name,&loca_id);
END;
____________________________________________________________________________________________
QST2:
DECLARE
CREATE OR REPLACE PROCEDURE update_wharehouse(ware_name IN warehouses. warehouse_name%TYPE,loca_id IN warehouses.location_id%TYPE) IS
BEGIN
SELECT (*) FROM warehouses;
UPDATE warehouses
SET warehouse_name=ware_name;
WHERE warehouses.location_id=loca_id;
END;
BEGIN
update_wharehouse('&ware_name',&loca_id);
END;
_______________________________________________________________________________________
QST3:
DECLARE
CREATE OR REPLACE PROCEDURE supp_wharehouse(loca_id IN warehouses.location_id%TYPE) IS
BEGIN
DELETE warehouses
WHERE warehouses.location_id=loca_id;
END;
BEGIN
supp_wharehouse(&loca_id);
END;
____________________________________________________________________________
QST4:
DECLARE
CREATE OR REPLACE PROCEDURE afficher_wharehouse(loca_id IN warehouses.location_id%TYPE) IS
BEGIN
CURSOR c_whar IS
SELECT (*) FROM wharehouse 
WHERE warehouses.location_id=loca_id;
END;
BEGIN
FOR i in c_whar
LOOP
dbms_output.put_line('WAREHOUSES');
dbms_output.put_line(i.warehouse_id || '  ' || i.warehouse_name || '  ' ||  i.location_id );
END LOOP;
END;
________________________________________________________________________________
QST5:
DECLARE
CA FLOAT(6);
CREATE OR REPLACE PROCEDURE calcul_CA(emplo_id IN employees.employee_id%TYPE, CA OUT FLOAT(6)) IS
BEGIN
SELECT employee_id, SUM(unit_price*quantity) INTO CA FROM employees INNER JOIN order_items USING(order_id) WHERE employee_id= emplo_id;
END;
BEGIN
calcul_CA(&CA);
dbms_output.put_line(CA);
END;
______________________________________________________________________________________
FONCTIONS:
1\
DECLARE
C float(6);
CREATE OR REPLACE FUNCTION prix_total(ord_id IN orders.order_id%TYPE ,custome_id IN customers.customers_id%TYPE)
RETURN float
IS
BEGIN
prix_total float(6);
SELECT customers_id, SUM(unit_price*quantity) INTO prix_total FROM customers INNER JOIN order_items USING(order_id)
WHERE customers_id= custome_id AND order_id=ord_id ;
RETURN prix_total;
END;
BEGIN
C:=prix_total(&prix_total,&ord_id);
dbms_output.put_line('le prix total: ' || C);
END;
2\
DECLARE
NBR INT;
CREATE OR REPLACE FUNCTION nbr_commande(satut IN orders.status%TYPE)
RETURN INT
IS
BEGIN
nbr INT;
SELECT COUNT order_id INTO nbr FROM orders WHERE status='PENDING' ;
RETURN nbr;
END;
BEGIN
NBR=nbr_commande();
dbms_output.put_line('le nombre des commandes est : ' || NBR);
END;
_______________________________________________________________________________________
1)
DECLARE
CREATE OR REPLACE TRIGGER t_commande
AFTER INSERT ON orders 
FOR EACH ROW
BEGIN
dbms_output.put_line('order ID :' || NEW.order_id);
dbms_output.put_line('Custumer ID :' || NEW.customer_id);
dbms_output.put_line('status :' || NEW.status);
dbms_output.put_line('Salesman ID :' || NEW.salesman_id);
dbms_output.put_line('order_date  :' || NEW.order_date);
END;
2)
DECLARE
CREATE OR REPLACE TRIGGER alerte
AFTER UPDATE ON inventories
FOR EACH ROW
WHEN(NEW. quantity  < 10)
BEGIN
dbms_output.put_line('ALERTE le nombre d article est < 10 !!!!!!!');
END;
3)
DECLARE
CREATE OR REPLACE TRIGGER modif_client
BEFORE UPDATE OR INSERT  ON customers
OF credit_limit
WHEN (EXTRACT(day FROM SYSDATE)>=28 AND EXTRACT(day FROM SYSDATE)<=30)
BEGIN
dbms_output.put_line('La mise est jour est impossible ');
END;
4)
DECLARE
CREATE OR REPLACE TRIGGER ajout_employe
BEFORE INSERT  ON employees
FOR EACH ROW
WHEN (SYSDATE < NEW.hire_date);
BEGIN
dbms_output.put_line('Impossible l ajout de ce employe !!! ');
END;
5)
DECLARE
CREATE OR REPLACE TRIGGER remise
AFTER UPDATE  ON order_items
OF unit_price
WHEN (NEW.unit_price * NEW.quantity) > 10000);
BEGIN
total:=unit_price*quantity;
total:= NEW.unit_price * NEW.quantity*(5/100);
dbms_output.put_line('votre montant est: ' || total);
END;


