set serveroutput on;


create or replace procedure CA(v_salesman_id in orders.salesman_id%type) is
chiffre NUMBER;
begin
select sum(quantity*unit_price) INTO chiffre from orders inner join order_items on orders.customer_id= order_items.order_id AND salesman_id = v_salesman_id AND (status = 'Shipped' OR status='Pending');
DBMS_OUTPUT.PUT_LINE('LE CHIFFRE D''AFFAIRE EST : '|| chiffre||'$');

end;

/
declare 

v_salesman_id  orders.salesman_id%type;
begin

v_salesman_id := '&v_salesman_id';
 CA(v_salesman_id );
end;