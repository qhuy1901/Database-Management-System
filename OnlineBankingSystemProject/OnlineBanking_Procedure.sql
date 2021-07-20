SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE DEPOSIT_TO_ACCOUNT(V_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE,
V_AMOUNT NUMBER)
AS
BEGIN
    UPDATE ACCOUNT 
    SET CURRENT_BALANCE = CURRENT_BALANCE + V_AMOUNT
    WHERE ACCOUNT_ID = V_ACCOUNT_ID;
    
    INSERT INTO TRANSACTION VALUES(TRANSACTION_ID_SEQUENCE.NEXTVAL, 'NT01', SYSDATE, V_AMOUNT, V_ACCOUNT_ID);
    
    COMMIT;
END;
--Test
BEGIN
    DEPOSIT_TO_ACCOUNT(2012001, 100000);
END;

--Procedure delete customer
CREATE OR REPLACE PROCEDURE DELETE_CUSTOMER(V_CUSTOMER_ID CUSTOMER.CUSTOMER_ID%TYPE)
AS
    V_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE;
    V_USERLOGIN_ID USER_LOGIN.USERLOGIN_ID%TYPE;
BEGIN
    SELECT USERLOGIN_ID INTO V_USERLOGIN_ID
    FROM CUSTOMER
    WHERE CUSTOMER_ID = V_CUSTOMER_ID;
    
    SELECT ACCOUNT_ID INTO V_ACCOUNT_ID
    FROM ACCOUNT
    WHERE CUSTOMER_ID = V_CUSTOMER_ID;

    DELETE FROM TRANSFER_DETAIL WHERE SENDER_ACCOUNT = V_ACCOUNT_ID OR RECEIVER_ACCOUNT = V_ACCOUNT_ID;
    DELETE FROM TRANSACTION WHERE ACCOUNT_ID = V_ACCOUNT_ID;
    DELETE FROM BILL WHERE CUSTOMER_ID = V_CUSTOMER_ID;
    DELETE FROM ACCOUNT WHERE CUSTOMER_ID = V_CUSTOMER_ID;
    DELETE FROM CUSTOMER WHERE CUSTOMER_ID = V_CUSTOMER_ID;
    --Delete this customer's user login
    DELETE FROM USER_LOGIN WHERE USERLOGIN_ID = V_USERLOGIN_ID;
    COMMIT;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Truong hop khach hang khong co tai khoan va khong thuc hien bat ki giao dich nao
            DELETE FROM CUSTOMER WHERE CUSTOMER_ID = V_CUSTOMER_ID;
            DELETE FROM USER_LOGIN WHERE USERLOGIN_ID = V_USERLOGIN_ID;
            COMMIT;     
END;
--Test
BEGIN
    DELETE_CUSTOMER(102010);
END;

--Procedure update nha cung cap
CREATE OR REPLACE PROCEDURE UPDATE_SUPPLIER(V_SUPPLIER_ID SUPPLIER.SUPPLIER_ID%TYPE,
V_SUPPLIER_NAME SUPPLIER.SUPPLIER_NAME%TYPE,
V_SERVICE_TYPE SUPPLIER.SERVICE_TYPE%TYPE,
V_CONTRACT_SIGNING_DATE SUPPLIER.CONTRACT_SIGNING_DATE%TYPE,
V_ADDRESS SUPPLIER.ADDRESS%TYPE,
V_PHONE_NUMBER SUPPLIER.PHONE_NUMBER%TYPE)
AS
BEGIN
    UPDATE SUPPLIER
    SET SUPPLIER_NAME = V_SUPPLIER_NAME, 
    SERVICE_TYPE = V_SERVICE_TYPE,
    CONTRACT_SIGNING_DATE = V_CONTRACT_SIGNING_DATE,
    ADDRESS = V_ADDRESS,
    PHONE_NUMBER = V_PHONE_NUMBER
    WHERE SUPPLIER_ID = V_SUPPLIER_ID;
    DBMS_OUTPUT.PUT_LINE('Update nha cung cap thanh cong');
    COMMIT;
END;
--Test
BEGIN
    UPDATE_SUPPLIER(1050, 'Huy Quang', 'Water', TO_DATE('21/02/2020','dd/MM/yyyy'), 'a','113');
END;
--Xem thong tin khach hang
CREATE OR REPLACE PROCEDURE VIEW_CUSTOMER_INFORMATION(V_CUSTOMER_ID CUSTOMER.CUSTOMER_ID%TYPE,
V_MONTH NUMBER, V_YEAR NUMBER)
AS
    TYPE r_customer_info 
    IS
        RECORD
        (
            full_name VARCHAR(50),
            gender CUSTOMER.GENDER%TYPE,
            date_of_birth CUSTOMER.DATE_OF_BIRTH%TYPE,
            id_card CUSTOMER.ID_CARD%TYPE,
            payment_account_id ACCOUNT.ACCOUNT_ID%TYPE,
            current_balance ACCOUNT.CURRENT_BALANCE%TYPE,
            number_of_transactions NUMBER,
            revenue CUSTOMER.REVENUE%TYPE);
    -- declare record
    r_customer r_customer_info;
BEGIN
    SELECT FIRST_NAME || ' ' || LAST_NAME, GENDER, DATE_OF_BIRTH, ID_CARD, A.ACCOUNT_ID, CURRENT_BALANCE, COUNT(T.TRANSACTION_ID), REVENUE 
    INTO r_customer
    FROM (CUSTOMER C JOIN ACCOUNT A ON C.CUSTOMER_ID = A.CUSTOMER_ID)
            JOIN TRANSACTION T ON T.ACCOUNT_ID = A.ACCOUNT_ID
    WHERE C.CUSTOMER_ID = V_CUSTOMER_ID 
    AND EXTRACT(MONTH FROM TRANSACTION_DATE) = V_MONTH
    AND EXTRACT(YEAR FROM TRANSACTION_DATE) = V_YEAR
    GROUP BY FIRST_NAME || ' ' || LAST_NAME, GENDER, DATE_OF_BIRTH, ID_CARD, A.ACCOUNT_ID, CURRENT_BALANCE, REVENUE; 
    
    DBMS_OUTPUT.PUT_LINE('Thong tin khach hang co ma KH ' || V_CUSTOMER_ID || ' la:');
    DBMS_OUTPUT.PUT_LINE('**Ho va ten: ' || r_customer.full_name);
    DBMS_OUTPUT.PUT_LINE('**Gioi tinh: ' || r_customer.gender);
    DBMS_OUTPUT.PUT_LINE('**Ngay sinh: ' || to_char(r_customer.date_of_birth,'DD-MM-YYYY'));
    DBMS_OUTPUT.PUT_LINE('**So CMND: ' || r_customer.id_card);
    DBMS_OUTPUT.PUT_LINE('**So tai khoan: ' || r_customer.payment_account_id);
    DBMS_OUTPUT.PUT_LINE('**So du hien tai: ' || TRIM(to_char(r_customer.current_balance, '9,999,999,999')) || ' VND');
    DBMS_OUTPUT.PUT_LINE('**So lan thuc hien giao dich trong thang '|| V_MONTH || '/' || V_YEAR ||': '|| r_customer.number_of_transactions);
    DBMS_OUTPUT.PUT_LINE('**Doanh thu: ' || TRIM(to_char(r_customer.revenue, '9,999,999,999')) || ' VND');
    
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20008, 'Ma khach hang khong lop le');
END;
--Test
BEGIN
    VIEW_CUSTOMER_INFORMATION(10952003, 5, 2021);
END;

--Them khach hang 
CREATE OR REPLACE PROCEDURE ADD_NEW_CUSTOMER(V_FIRST_NAME CUSTOMER.FIRST_NAME%TYPE,
V_LAST_NAME CUSTOMER.LAST_NAME%TYPE, V_GENDER CUSTOMER.GENDER%TYPE,
V_DATE_OF_BIRTH DATE,
V_ADDRESS CUSTOMER.ADDRESS%TYPE,
V_PHONE_NUMBER CUSTOMER.PHONE_NUMBER%TYPE,
V_ID_CARD CUSTOMER.ID_CARD%TYPE)
AS
BEGIN
    INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME,GENDER, DATE_OF_BIRTH, ADDRESS, PHONE_NUMBER, ID_CARD)
    VALUES(CUSTOMER_ID_SEQUENCE.NEXTVAL, V_FIRST_NAME, V_LAST_NAME, V_GENDER, V_DATE_OF_BIRTH, V_ADDRESS, V_PHONE_NUMBER, V_ID_CARD);
    COMMIT;
END; 

--Procedure 1: Thanh toan hoa don
CREATE OR REPLACE PROCEDURE PAYMENT(V_ACCOUNTID ACCOUNT.ACCOUNT_ID%TYPE, V_BILLID BILL.BILL_ID%TYPE)
AS
    r_account ACCOUNT%ROWTYPE;
    r_bill BILL%ROWTYPE;
BEGIN   
    SELECT * INTO r_account
    FROM ACCOUNT
    WHERE ACCOUNT_ID = V_ACCOUNTID;
    
    SELECT * INTO r_bill
    FROM BILL
    WHERE BILL_ID = v_BILLID;
    
    IF(r_bill.STATUS = 'Paid') THEN
        RAISE_APPLICATION_ERROR(-20000, 'Hoa don nay da duoc thanh toan');
    END IF;
    
    
    IF(r_account.CURRENT_BALANCE >= r_bill.BILL_AMOUNT) THEN
        -- Tru tien tai khoan
        UPDATE ACCOUNT
        SET CURRENT_BALANCE = CURRENT_BALANCE - r_bill.BILL_AMOUNT
        WHERE ACCOUNT_ID = V_ACCOUNTID;
        
        -- Cap nhap trang thai hoa don
        UPDATE BILL
        SET STATUS = 'Paid', PAYMENT_DATE = SYSDATE
        WHERE BILL_ID = v_BILLID;
        
        -- Ghi lai thong tin giao dich
        INSERT INTO TRANSACTION VALUES(TRANSACTION_ID_SEQUENCE.NEXTVAL, 'TT03', SYSDATE, r_bill.BILL_AMOUNT, V_ACCOUNTID);
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'So du hien tai khong du de thanh toan hoa don');
    END IF;
    
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'Khong tim thay hoa don');
END; 

--Procedure 2: Chuyen tien
CREATE OR REPLACE FUNCTION identifiedTransferType(V_AMOUNT TRANSFER_DETAIL.AMOUNT%TYPE, 
V_RECEIVER_BANK TRANSFER_DETAIL.RECEIVER_BANK%TYPE ) RETURN VARCHAR2
AS
BEGIN
    IF(V_RECEIVER_BANK = 'Vietcombank') THEN
        --Internal Bank Transfer under 50 million VND
        IF(V_AMOUNT < 50000000) THEN
            RETURN 'CT01';
        --Internal Bank Transfer over 50 million
        ELSE
            RETURN 'CT02';
        END IF;
    ELSE
        --Interbank Transfer under 50 million VND
        IF(V_AMOUNT < 50000000) THEN
            RETURN 'CT03';
        --Interbank Transfer over 50 million VND
        ELSE
            RETURN 'CT04';
        END IF;
    END IF;
END;

CREATE OR REPLACE PROCEDURE TRANSFER(V_SENDER_ACCOUNT ACCOUNT.ACCOUNT_ID%TYPE,
V_RECEIVER_ACCOUNT ACCOUNT.ACCOUNT_ID%TYPE,   
V_RECEIVER_BANK TRANSFER_DETAIL.RECEIVER_BANK%TYPE, 
V_AMOUNT TRANSFER_DETAIL.AMOUNT%TYPE,
V_CONTENT TRANSFER_DETAIL.CONTENT%TYPE,
V_TRANSACTION_ID OUT NUMBER)
AS
    r_sender_account ACCOUNT%ROWTYPE;
    r_receiver_account ACCOUNT%ROWTYPE;
    v_transfer_type TRANSACTION.TRANSACTION_TYPE_ID%TYPE;
    v_total_fee NUMBER;
    v_transfer_fee NUMBER;
    v_next_sender_transactionid TRANSACTION.TRANSACTION_ID%TYPE;
    v_next_receiver_transactionid TRANSACTION.TRANSACTION_ID%TYPE;
BEGIN
    SELECT * INTO r_sender_account
    FROM ACCOUNT 
    WHERE ACCOUNT_ID = V_SENDER_ACCOUNT;

    SELECT * INTO r_receiver_account
    FROM ACCOUNT 
    WHERE ACCOUNT_ID = V_RECEIVER_ACCOUNT;

    IF(r_sender_account.CURRENT_BALANCE >= V_AMOUNT) THEN
        --Xac dinh loai giao dich (chuyen tien) de tinh phi chuyen tien
        v_transfer_type :=  identifiedTransferType(V_AMOUNT, V_RECEIVER_BANK);
        --Tinh tong phi chuyen tien
        SELECT FEE INTO v_transfer_fee
        FROM TRANSACTION_TYPE 
        WHERE TRANSACTION_TYPE_ID = v_transfer_type;
        v_total_fee := V_AMOUNT + v_transfer_fee;
        --Tru tien nguoi gui
        UPDATE ACCOUNT
        SET CURRENT_BALANCE = CURRENT_BALANCE - v_total_fee
        WHERE ACCOUNT_ID = V_SENDER_ACCOUNT;

        --Cong tien nguoi nhan
        UPDATE ACCOUNT
        SET CURRENT_BALANCE = CURRENT_BALANCE + V_AMOUNT
        WHERE ACCOUNT_ID = V_RECEIVER_ACCOUNT;

        --Them giao dich vua thuc hien vao bang lich su giao dich
        v_next_sender_transactionid := TRANSACTION_ID_SEQUENCE.NEXTVAL;
        v_next_receiver_transactionid := TRANSACTION_ID_SEQUENCE.NEXTVAL;
        V_TRANSACTION_ID := v_next_sender_transactionid; -- gan transactionID cho bien OUT de lap bien lai chuyen tien
        INSERT INTO TRANSACTION VALUES(v_next_sender_transactionid, v_transfer_type, SYSDATE, v_total_fee, V_SENDER_ACCOUNT);
        INSERT INTO TRANSACTION VALUES(v_next_receiver_transactionid, 'NT01', SYSDATE, V_AMOUNT, V_RECEIVER_ACCOUNT);
        --Them cac thong tin khac vao bang transfer_detail
        INSERT INTO TRANSFER_DETAIL VALUES(TRANSFER_DETAILS_ID_SEQUENCE.NEXTVAL, V_SENDER_ACCOUNT, V_RECEIVER_ACCOUNT, V_RECEIVER_BANK, V_AMOUNT,  V_CONTENT, v_next_sender_transactionid);
        INSERT INTO TRANSFER_DETAIL VALUES(TRANSFER_DETAILS_ID_SEQUENCE.NEXTVAL, V_SENDER_ACCOUNT, V_RECEIVER_ACCOUNT, V_RECEIVER_BANK, V_AMOUNT,  V_CONTENT, v_next_receiver_transactionid);
    ELSE
        RAISE_APPLICATION_ERROR(-20000, 'So du hien tai khong du de thuc hien chuyen tien');
    END IF;
    
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Thong tin chuyen tien khong hop le!');
END;

-- Procedure 3: Mo tai khoan tiet kiem
CREATE OR REPLACE PROCEDURE OPEN_SAVINGS_ACCOUNT(V_CUSTOMER_ID CUSTOMER.CUSTOMER_ID%TYPE,
V_ACCOUNT_TYPE_ID ACCOUNT.ACCOUNT_TYPE_ID%TYPE, 
V_AMOUNT NUMBER,
V_MATURITY_DATE ACCOUNT.MATURITY_DATE%TYPE,
V_ANTICIPATED_INTEREST ACCOUNT.ANTICIPATED_INTEREST%TYPE)
AS
    r_payment_account ACCOUNT%ROWTYPE;
BEGIN
    SELECT * INTO r_payment_account
    FROM ACCOUNT
    WHERE CUSTOMER_ID = V_CUSTOMER_ID
    AND ACCOUNT_TYPE_ID = 'PA';

    IF(r_payment_account.CURRENT_BALANCE >= V_AMOUNT) THEN
        -- Tru tien tai khoan thanh toan
        UPDATE ACCOUNT
        SET CURRENT_BALANCE = CURRENT_BALANCE - V_AMOUNT
        WHERE ACCOUNT_ID = r_payment_account.ACCOUNT_ID;

        -- Tao tai khoan tiet kiem
        INSERT INTO ACCOUNT 
        VALUES(ACCOUNT_ID_SEQUENCE.NEXTVAL, V_ACCOUNT_TYPE_ID, V_AMOUNT, SYSDATE, V_MATURITY_DATE ,V_ANTICIPATED_INTEREST, 'Active', V_CUSTOMER_ID);

        --Them thong tin giao dich vao table TRANSACTION
        INSERT INTO TRANSACTION
        VALUES(TRANSACTION_ID_SEQUENCE.NEXTVAL, 'TK01', SYSDATE, V_AMOUNT, r_payment_account.ACCOUNT_ID);
    ELSE
        RAISE_APPLICATION_ERROR(-20010, 'So du hien tai khong du de thuc hien mo tai khoan tiet kiem');
    END IF;

    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000, 'Khong tim thay tai khoan thanh toan cua khach hang.');
END;

-- Procedure 4: Tat toan tai khoan tiet kiem
CREATE OR REPLACE FUNCTION CALCULATE_INTEREST_BEFORE_DUE_DATE(V_OPEN_DAY ACCOUNT.OPEN_DAY%TYPE,
V_MATURITY_DATE ACCOUNT.MATURITY_DATE%TYPE,
V_ANTICIPATED_INTEREST ACCOUNT.ANTICIPATED_INTEREST%TYPE) RETURN NUMBER
AS
    --This function calculate interest if settle a non-term savings account before due date
    v_number_of_estimated_deposit_days NUMBER;
    v_number_of_actual_deposit_days NUMBER;
    v_interest NUMBER;
BEGIN
    v_number_of_estimated_deposit_days := CEIL(v_MATURITY_DATE - V_OPEN_DAY);
    v_number_of_actual_deposit_days := CEIL(SYSDATE - V_OPEN_DAY) - 1;
    v_interest := CEIL(v_number_of_actual_deposit_days/ v_number_of_estimated_deposit_days ) * V_ANTICIPATED_INTEREST * 0.75;
    RETURN v_interest;

    EXCEPTION
        WHEN ZERO_DIVIDE THEN
            RETURN 0;
END;
    
CREATE OR REPLACE PROCEDURE SETTLEMENT(V_SAVING_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE)
AS
    R_SAVING_ACCOUNT ACCOUNT%ROWTYPE;
    R_PAYMENT_ACCOUNT ACCOUNT%ROWTYPE;
    v_total_receiverd_amount NUMBER;
BEGIN
    --Lay thong tin tai khoan tiet kiem
    SELECT * INTO R_SAVING_ACCOUNT
    FROM ACCOUNT
    WHERE ACCOUNT_ID = V_SAVING_ACCOUNT_ID;
    
    --Lay  thong tin tai khoan thanh toan 
    SELECT * INTO R_PAYMENT_ACCOUNT
    FROM ACCOUNT 
    WHERE CUSTOMER_ID = R_SAVING_ACCOUNT.CUSTOMER_ID
    AND ACCOUNT_TYPE_ID = 'PA';
    
    --Xu ly tat toan
    IF(R_SAVING_ACCOUNT.MATURITY_DATE > SYSDATE) THEN
        -- Tat toan truoc han
        IF(R_SAVING_ACCOUNT.ACCOUNT_TYPE_ID LIKE 'TSA%') THEN
            -- Doi voi tiet kiem co ky han thi khong duoc tat toan
            RAISE_APPLICATION_ERROR(-2010, 'Khong the tat toan do chua den ngay dao han');
        ELSE
            -- Doi voi tiet kiem khong ky han
            v_total_receiverd_amount := R_SAVING_ACCOUNT.CURRENT_BALANCE + CALCULATE_INTEREST_BEFORE_DUE_DATE(R_SAVING_ACCOUNT.OPEN_DAY, R_SAVING_ACCOUNT.MATURITY_DATE, R_SAVING_ACCOUNT.ANTICIPATED_INTEREST);
        END IF;
    ELSE
        --Dao han
        v_total_receiverd_amount := R_SAVING_ACCOUNT.CURRENT_BALANCE + R_SAVING_ACCOUNT.ANTICIPATED_INTEREST;
    END IF;
    
    --Cong tien vao tk thanh toan
    UPDATE ACCOUNT
    SET CURRENT_BALANCE = CURRENT_BALANCE + v_total_receiverd_amount
    WHERE ACCOUNT_ID = R_PAYMENT_ACCOUNT.ACCOUNT_ID;
    
    --Cap nhap tai trang thai tai khoan tiet kiem
    UPDATE ACCOUNT
    SET STATUS = 'Locked'
    WHERE ACCOUNT_ID = V_SAVING_ACCOUNT_ID;
    
    --Them thong tin tat toan vao table TRANSACTION
    INSERT INTO TRANSACTION
    VALUES(TRANSACTION_ID_SEQUENCE.NEXTVAL, 'TK02', SYSDATE, v_total_receiverd_amount, R_PAYMENT_ACCOUNT.ACCOUNT_ID);
    
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-2011, 'So tai khoan khong hop le');
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-2012, 'Thong tin tiet kiem khong hop le');
END;

-- Procedure 5: In 15 lich su giao dich gan nhat cua mot khach hang
CREATE OR REPLACE PROCEDURE DISPLAY_TRANSACTION_HISTORY(V_PAYMENT_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE)
AS
    CURSOR C_TRANSACTION IS
        SELECT *
        FROM (SELECT *
                FROM TRANSACTION JOIN TRANSACTION_TYPE USING(TRANSACTION_TYPE_ID)
                WHERE ACCOUNT_ID = V_PAYMENT_ACCOUNT_ID
                ORDER BY TRANSACTION_ID DESC)
        WHERE ROWNUM <= 15; -- Lay 15 hang dau tien
        
BEGIN
    FOR V_TRANSACTION IN C_TRANSACTION
    LOOP
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Ma giao dich: ' || V_TRANSACTION.TRANSACTION_ID);
        DBMS_OUTPUT.PUT_LINE('Ngay giao dich: ' || V_TRANSACTION.TRANSACTION_DATE);
        DBMS_OUTPUT.PUT_LINE('Loai giao dich: ' || V_TRANSACTION.NAME);
        IF(V_TRANSACTION.TRANSACTION_TYPE_ID = 'TK02' OR V_TRANSACTION.TRANSACTION_TYPE_ID = 'NT01') --Neu la loai giao dich nhan tien
        THEN
            DBMS_OUTPUT.PUT_LINE('So tien: +' || V_TRANSACTION.TOTAL_TRANSACTION_AMOUNT || ' VND');
        ELSE -- Neu la loai giao dich tru tien tai khoan
            DBMS_OUTPUT.PUT_LINE('So tien: -' || V_TRANSACTION.TOTAL_TRANSACTION_AMOUNT || ' VND');
        END IF;
    END LOOP;
    
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20100, 'Ma tai khoan khong ton tai');
END;
--Test
BEGIN
    DISPLAY_TRANSACTION_HISTORY(2012003);
END; 

COMMIT;
