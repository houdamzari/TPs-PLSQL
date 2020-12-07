-- Procedures
-- Quest 1
CREATE PROCEDURE addWarehouse (data IN WAREHOUSES%ROWTYPE)
AS
BEGIN
    INSERT INTO WAREHOUSES
    VALUES (data.WAREHOUSE_ID, data.WAREHOUSE_NAME, data.LOCATION_ID);
END;

-- Quest 2
CREATE PROCEDURE updateWarehouseData (warehouseId IN WAREHOUSES.WAREHOUSE_ID%TYPE,
                                      locationId IN WAREHOUSES.LOCATION_ID%TYPE,
                                      nWare IN WAREHOUSES.WAREHOUSE_NAME%TYPE)
AS
BEGIN
    UPDATE WAREHOUSES
    SET WAREHOUSE_NAME = nWare WHERE WAREHOUSE_NAME = warehouseId AND LOCATION_ID = locationId;
END;

-- Quest 3
CREATE PROCEDURE deleteWarehouse (warehouseId IN WAREHOUSES.WAREHOUSE_ID%TYPE)
AS
BEGIN
    DELETE FROM WAREHOUSES WHERE WAREHOUSE_ID = warehouseId;
END;

-- Quest 4
CREATE PROCEDURE afficherWarehouse (locationId IN WAREHOUSES.LOCATION_ID%TYPE)
AS
    CURSOR warehouseCurs IS
        SELECT * FROM WAREHOUSES WHERE LOCATION_ID = locationId;
BEGIN
    DBMS_OUTPUT.PUT_LINE ('La location ' || locationId || ' a les warehouse suivant:') ;
    FOR data IN warehouseCurs
    LOOP
    DBMS_OUTPUT.PUT_LINE ('Id: ' || data.WAREHOUSE_ID || ', Nom: ' || data.WAREHOUSE_NAME);
    END LOOP;
END;

-- Quest 5
CREATE PROCEDURE calculeCA (idEmp IN EMPLOYEES.EMPLOYEE_ID%TYPE)
AS
    ca INTEGER;
BEGIN
    SELECT SUM (OI.QUANTITY * OI.UNIT_PRICE) INTO ca
    FROM ORDERS O JOIN ORDER_ITEMS OI
        ON O.ORDER_ID = OI.ORDER_ID
    WHERE salesman_id = idEmp
        AND (status = 'Shipped' OR status='Pending');
    DBMS_OUTPUT.PUT_LINE('Le chiffre d`affaire : ' || ca ||'$');
END;

-- Quest 6
CREATE FUNCTION calculPrixTotal (idClient IN CUSTOMERS.CUSTOMER_ID%TYPE)
RETURN INTEGER IS
    prix INTEGER := 0;
BEGIN
    SELECT SUM(P.LIST_PRICE * OI.QUANTITY) INTO prix
    FROM PRODUCTS P JOIN ORDER_ITEMS OI JOIN ORDERS O
    ON P.PRODUCT_ID = OI.PRODUCT_ID ON OI.ORDER_ID = O.ORDER_ID
    WHERE O.CUSTOMER_ID = idClient;
    RETURN prix;
END;

-- Quest 7
CREATE FUNCTION calculNbrCmdPending
RETURN INTEGER IS
    nbr INTEGER := 0;
BEGIN
    SELECT COUNT(*) INTO nbr FROM ORDERS WHERE STATUS = 'Pending';
    return nbr;
END;

-- Quest 8
CREATE TRIGGER ordResume
    AFTER INSERT ON ORDERS
    REFERENCING NEW AS n
    FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Order ID : ' || n.ORDER_ID || ' Customer ID : ' || n.CUSTOMER_ID || ' Salesman ID : ' || n.SALESMAN_ID || ' Order status : ' || n.STATUS || ' Order date : ' || n.ORDER_DATE );
END;

-- Quest 9
CREATE TRIGGER alertStock
    AFTER INSERT ON INVENTORIES
    REFERENCING NEW AS n
    FOR EACH ROW
BEGIN
    IF n.QUANTITY < 10 THEN
        DBMS_OUTPUT.PUT_LINE('l article ' || n.PRODUCT_ID || ' est presque fini.');
    END IF;
END;

-- Quest 10
CREATE TRIGGER modStop
    BEFORE UPDATE OF CREDIT_LIMIT ON CUSTOMERS
    FOR EACH ROW
DECLARE
    day INT;
BEGIN
    day := EXTRACT(DAY FROM SYSDATE);
    IF day BETWEEN 28 AND 30 THEN
        DBMS_OUTPUT.PUT_LINE('Cannot update {Credit_Limit} day between 28 and 30.');
    END IF;
END;

-- Quest 11
CREATE TRIGGER auth
    BEFORE INSERT ON EMPLOYEES
    REFERENCING NEW AS n
    FOR EACH ROW
BEGIN
    if sysdate < n.HIRE_DATE THEN
        DBMS_OUTPUT.PUT_LINE('Cannot add employee');
    END IF;
END;

-- Quest 12
CREATE TRIGGER promo
    BEFORE INSERT ON ORDER_ITEMS
    REFERENCING NEW AS n
    FOR EACH ROW
BEGIN
    if UNIT_PRICE * ORDER_ITEMS.QUANTITY > 10000 THEN
        n.UNIT_PRICE := n.UNIT_PRICE * 0.95;
    END IF;
END;