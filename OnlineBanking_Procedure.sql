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

CREATE OR REPLACE PROCEDURE TRANSFER2(V_SENDER_ACCOUNT ACCOUNT.ACCOUNT_ID%TYPE,
V_RECEIVER_ACCOUNT ACCOUNT.ACCOUNT_ID%TYPE,   
V_RECEIVER_BANK TRANSFER_DETAIL.RECEIVER_BANK%TYPE, 
V_AMOUNT TRANSFER_DETAIL.AMOUNT%TYPE,
V_CONTENT TRANSFER_DETAIL.CONTENT%TYPE)
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
create or replace PROCEDURE OPEN_SAVINGS_ACCOUNT(V_CUSTOMER_ID CUSTOMER.CUSTOMER_ID%TYPE,
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
    END IF;

    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000, 'Khong tim thay tai khoan thanh toan cua khach hang.');
END;

-- Procedure 4: Tat toan tai khoan tiet kiem
CREATE OR REPLACE PROCEDURE Settlement(V_SAVING_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE)
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
            RAISE_APPLICATION_ERROR(-2010, 'Khong the tat toan do chua den ngay dao han');
        ELSE 
            v_total_receiverd_amount := R_SAVING_ACCOUNT.CURRENT_BALANCE;
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


