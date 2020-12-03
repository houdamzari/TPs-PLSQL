create or replace trigger resume
after insert on orders
for each row

begin 
DBMS_OUTPUT.PUT_LINE('order id :  '||:new.order_id);
DBMS_OUTPUT.PUT_LINE('customer id :  '||:new.customer_id);
DBMS_OUTPUT.PUT_LINE('status  '||:new.status);
DBMS_OUTPUT.PUT_LINE('salesman id : '||:new.salesman_id);
DBMS_OUTPUT.PUT_LINE('order date :   '||:new.order_date);
end;
/

insert into orders(order_id,customer_id,status,salesman_id,order_date) values ( 999 , 1 , 'pending' , 60 , '01/01/2020' );
/



