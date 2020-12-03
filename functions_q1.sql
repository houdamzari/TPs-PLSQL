set serveroutput on;

create or replace function prix_total(v_customer_id in orders.customer_id%type)

return number is
total number;
begin
    select sum(quantity*unit_price) into total from orders inner join order_items on orders.order_id = order_items.order_id and orders.customer_id = v_customer_id and (status ='Pending' OR  status='Shipped');
    
    RETURN total;
    
end;
/


DECLARE
total number;

customer orders.customer_id%type;
begin
customer:='&customer';
total := prix_total(customer);
DBMS_OUTPUT.put_line(total);
end;



