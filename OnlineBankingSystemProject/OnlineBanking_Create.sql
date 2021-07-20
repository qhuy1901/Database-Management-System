CREATE TABLE USER_LOGIN
(
    USERLOGIN_ID NUMBER(7)CONSTRAINT USERLOGIN_ID_PK PRIMARY KEY,
    USERNAME VARCHAR(20) UNIQUE,
    PASSWORD VARCHAR(20) NOT NULL,
    ROLE VARCHAR(20) CHECK(ROLE IN('Customer', 'Admin')),
    NUMBER_OF_FAILED_LOGIN NUMBER DEFAULT(0) CHECK (NUMBER_OF_FAILED_LOGIN <= 3),
    LAST_ACCESS_TIME DATE
);

CREATE TABLE CUSTOMER 
(
    CUSTOMER_ID NUMBER(10) CONSTRAINT CUSTOMER_ID_PK PRIMARY KEY,
    FIRST_NAME VARCHAR2(50) NOT NULL,
    LAST_NAME VARCHAR2(50) NOT NULL,
    GENDER VARCHAR2(6) CHECK (GENDER IN('Male', 'Female')),
    DATE_OF_BIRTH DATE NOT NULL,
    ADDRESS VARCHAR2(400) NOT NULL,
    PHONE_NUMBER VARCHAR2(11)NOT NULL,
    ID_CARD NUMBER(20) NOT NULL,
    USERLOGIN_ID NUMBER(7),
    REVENUE NUMBER(12) DEFAULT(0),
    CONSTRAINT CUSTOMER_USERLOGINID_FK FOREIGN KEY(USERLOGIN_ID) REFERENCES USER_LOGIN(USERLOGIN_ID)
);


CREATE TABLE ACCOUNT_TYPE
(
    ACCOUNT_TYPE_ID CHAR(5) CONSTRAINT ACCOUNTTYPE_ID_PK PRIMARY KEY,
    NAME VARCHAR2(200) NOT NULL,
    INTEREST_RATE NUMBER(4, 4)
);

CREATE TABLE ACCOUNT
(
    ACCOUNT_ID NUMBER(7) CONSTRAINT ACCOUNT_ID_PK PRIMARY KEY,
    ACCOUNT_TYPE_ID CHAR(5) NOT NULL,
    CURRENT_BALANCE NUMBER(12) CHECK(CURRENT_BALANCE >= 0) NOT NULL,
    OPEN_DAY DATE NOT NULL,
    MATURITY_DATE DATE,
    ANTICIPATED_INTEREST NUMBER(12),
    STATUS VARCHAR2(20) CHECK(STATUS IN ('Active', 'Locked')),
    CUSTOMER_ID NUMBER(10) NOT NULL,
    CONSTRAINT ACCOUNT_CUSTOMERID_FK FOREIGN KEY(CUSTOMER_ID)REFERENCES CUSTOMER(CUSTOMER_ID),
    CONSTRAINT ACCOUNT_ACCOUNTTYPEID_FK FOREIGN KEY(ACCOUNT_TYPE_ID)REFERENCES ACCOUNT_TYPE(ACCOUNT_TYPE_ID)
); 

CREATE TABLE TRANSACTION_TYPE
(
    TRANSACTION_TYPE_ID CHAR(4) CONSTRAINT TRANSACTIONTYPE_ID_PK PRIMARY KEY,
    NAME VARCHAR2(50) NOT NULL,
    FEE NUMBER(12)
);

CREATE TABLE TRANSACTION
(
    TRANSACTION_ID NUMBER(7) CONSTRAINT TRANSACTION_ID_PK PRIMARY KEY,
    TRANSACTION_TYPE_ID CHAR(4) NOT NULL,
    TRANSACTION_DATE DATE NOT NULL,
    TOTAL_TRANSACTION_AMOUNT NUMBER(12) NOT NULL,
    ACCOUNT_ID NUMBER(7) NOT NULL,
    CONSTRAINT TRANSACTION_TRANSACTIONTYPEID_FK FOREIGN KEY(TRANSACTION_TYPE_ID) REFERENCES TRANSACTION_TYPE(TRANSACTION_TYPE_ID),
    CONSTRAINT TRANSACTION_ACCOUNTID_FK FOREIGN KEY(ACCOUNT_ID) REFERENCES ACCOUNT(ACCOUNT_ID)
    --UserLoginID NUMBER(7),
    --CONSTRAINT TransactionLog_UserLoginID_FK FOREIGN KEY(UserLoginID) REFERENCES Account(ID)
);

CREATE TABLE EMPLOYEE
(
    EMPLOYEE_ID NUMBER(7, 0) CONSTRAINT EMPLOYEE_ID_PK PRIMARY KEY,
    FIRST_NAME VARCHAR2(50) NOT NULL,
    LAST_NAME VARCHAR2(50) NOT NULL,
    USERLOGIN_ID NUMBER(7),
    CONSTRAINT EMPLOYEE_USERLOGINID_FK FOREIGN KEY(USERLOGIN_ID) REFERENCES USER_LOGIN(USERLOGIN_ID)
);

CREATE TABLE SUPPLIER
(
    SUPPLIER_ID NUMBER(7) CONSTRAINT SUPPLIER_ID_PK PRIMARY KEY,
    SUPPLIER_NAME VARCHAR2(100) NOT NULL,
    SERVICE_TYPE VARCHAR2(100) CHECK(SERVICE_TYPE IN ('Water', 'Electricity', 'Internet', 'Phone card')),
    CONTRACT_SIGNING_DATE DATE NOT NULL,
    ADDRESS VARCHAR2(100),
    PHONE_NUMBER VARCHAR2(10)
);

CREATE TABLE BILL
(
    BILL_ID NUMBER(10) CONSTRAINT BILL_ID_PK PRIMARY KEY,
    SUPPLIER_ID NUMBER(7) NOT NULL,
    CUSTOMER_ID NUMBER(10)NOT NULL,
    BILL_AMOUNT NUMBER(12)NOT NULL,
    INVOICE_DATE DATE NOT NULL,
    PAYMENT_DATE DATE,
    STATUS VARCHAR(50) CHECK (STATUS IN ('Paid', 'Unpaid')),
    CONSTRAINT BILL_CUSTOMERID_FK FOREIGN KEY(CUSTOMER_ID)REFERENCES CUSTOMER(CUSTOMER_ID),
    CONSTRAINT BILL_SUPPLIERID_FK FOREIGN KEY(SUPPLIER_ID)REFERENCES SUPPLIER(SUPPLIER_ID)
);

CREATE TABLE TRANSFER_DETAIL
(
    TRANSFER_DETAIL_ID NUMBER (7) CONSTRAINT TRANSFERDETAILS_ID_PK PRIMARY KEY, 
    SENDER_ACCOUNT NUMBER(7) NOT NULL,
    RECEIVER_ACCOUNT NUMBER(7) NOT NULL,
    RECEIVER_BANK VARCHAR(100),
    AMOUNT NUMBER(12) NOT NULL,
    CONTENT VARCHAR(200),
    TRANSACTION_ID NUMBER(7),
    CONSTRAINT TRANSFERDETAILS_RECEIVER_ACCOUNT_FK FOREIGN KEY(RECEIVER_ACCOUNT) REFERENCES ACCOUNT(ACCOUNT_ID),
    CONSTRAINT TRANSFERDETAILS_SENDER_ACCOUNT_FK FOREIGN KEY(SENDER_ACCOUNT) REFERENCES ACCOUNT(ACCOUNT_ID),
    CONSTRAINT TRANSFERDETAILS_TRANSCTION_ID_FK FOREIGN KEY(TRANSACTION_ID) REFERENCES TRANSACTION(TRANSACTION_ID)
);

--CREATE SEQUENCE
CREATE SEQUENCE CUSTOMER_ID_SEQUENCE
      INCREMENT BY 1
      START WITH 10952050
      MAXVALUE 10952999
      NOCYCLE;
      
CREATE SEQUENCE ACCOUNT_ID_SEQUENCE
      INCREMENT BY 1
      START WITH 2012050
      MAXVALUE 2012999
      NOCYCLE;
      
CREATE SEQUENCE TRANSACTION_ID_SEQUENCE
      INCREMENT BY 1
      START WITH 1052050
      MAXVALUE 1052999
      NOCYCLE;
        
CREATE SEQUENCE USERLOGIN_ID_SEQUENCE
      INCREMENT BY 1
      START WITH 520050
      MAXVALUE 529999
      NOCYCLE;      
      
CREATE SEQUENCE SUPPLIER_ID_SEQUENCE
      INCREMENT BY 1
      START WITH 1050
      MAXVALUE 9999
      NOCYCLE; 
      
CREATE SEQUENCE BILL_ID_SEQUENCE
      INCREMENT BY 1
      START WITH 1520050
      MAXVALUE 1599999
      NOCYCLE; 
      
CREATE SEQUENCE TRANSFER_DETAILS_ID_SEQUENCE
      INCREMENT BY 1
      START WITH 1
      MAXVALUE 99999
      NOCYCLE; 
      
--INSERT DATAS
INSERT INTO USER_LOGIN VALUES(520001, 'admin1', '123456','Admin', 0, SYSDATE);
INSERT INTO USER_LOGIN VALUES(520002, 'admin2', '123456','Admin', 0, SYSDATE);
INSERT INTO USER_LOGIN VALUES(520003, 'admin3', '123456','Admin', 0, SYSDATE);
INSERT INTO USER_LOGIN VALUES(520004, 'admin4', '123456','Admin', 0, NULL);
INSERT INTO USER_LOGIN VALUES(520005, 'admin5', '123456', 'Admin', 0, SYSDATE);
INSERT INTO USER_LOGIN VALUES(520006, '0975244479', '123456', 'Customer', 0, SYSDATE);
INSERT INTO USER_LOGIN VALUES(520007, '0361234578', '123456', 'Customer', 0, SYSDATE);
INSERT INTO USER_LOGIN VALUES(520008, 'tuvnc', '123456', 'Customer', 0, SYSDATE);
INSERT INTO USER_LOGIN VALUES(520009, '0938776266', '123456', 'Customer', 0, SYSDATE); 
INSERT INTO USER_LOGIN VALUES(520010, '0938826866', '123456', 'Customer', 0, SYSDATE);
INSERT INTO USER_LOGIN VALUES(520011, '0937825255', '123456', 'Customer', 0, SYSDATE); 
INSERT INTO USER_LOGIN VALUES(520012, '0837822285', '123456', 'Customer', 0, SYSDATE); 
INSERT INTO USER_LOGIN VALUES(520013, '0237825224', '123456', 'Customer', 0, SYSDATE); 
INSERT INTO USER_LOGIN VALUES(520014, '0937885255', '123456', 'Customer', 0, SYSDATE); 
INSERT INTO USER_LOGIN VALUES(520015, '0837825251', '123456', 'Customer', 0, SYSDATE);  

INSERT INTO CUSTOMER(CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, DATE_OF_BIRTH, ADDRESS, PHONE_NUMBER, ID_CARD, REVENUE) 
VALUES(10952001, 'Le Thi Hong', 'Cuc', 'Female', TO_DATE('11/8/2001', 'dd/mm/yyyy'), '117/2 Nguyen Trai, Q5, TpHCM', '0975244479', '272934278', 12000);     
INSERT INTO CUSTOMER(CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, DATE_OF_BIRTH, ADDRESS, PHONE_NUMBER, ID_CARD, REVENUE)  
VALUES(10952002, 'Le Ngoc', 'Tuan', 'Male', TO_DATE('1/2/2001', 'dd/mm/yyyy'), '731 Tran Hung Dao, Q5, TpHCM', '0361234578', '272930292', 22000);
INSERT INTO CUSTOMER(CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, DATE_OF_BIRTH, ADDRESS, PHONE_NUMBER, ID_CARD, REVENUE)  
VALUES(10952003, 'Vo Ngoc Cam', 'Tu', 'Female', TO_DATE('12/5/2001', 'dd/mm/yyyy'), '23/5 Nguyen Trai, Q5, TpHCM', '0365238774', '272957432', 8000);
INSERT INTO CUSTOMER(CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, DATE_OF_BIRTH, ADDRESS, PHONE_NUMBER, ID_CARD, REVENUE) 
VALUES(10952004, 'Le Hoai', 'Thuong', 'Male', TO_DATE('21/5/2000', 'dd/mm/yyyy'), '27/2 Nguyen Trai, Q5, TpHCM', '0938776266', '272993244', 12000);
INSERT INTO CUSTOMER(CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, DATE_OF_BIRTH, ADDRESS, PHONE_NUMBER, ID_CARD, REVENUE)
VALUES(10952005, 'Tran Ngoc', 'Linh', 'Male', TO_DATE('21/7/1998', 'dd/mm/yyyy'), '45 Nguyen Canh Chan, Q1, TPHCM', '0938826866', '272993323', 1000); 
INSERT INTO CUSTOMER(CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, DATE_OF_BIRTH, ADDRESS, PHONE_NUMBER, ID_CARD, REVENUE)  
VALUES(10952006, 'Tran Minh', 'Long', 'Male', TO_DATE('10/11/1990', 'dd/mm/yyyy'), '50/34 Le Dai Hanh, Q10, TPHCM', '0937825255', '272443521', 32000);
INSERT INTO CUSTOMER(CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, DATE_OF_BIRTH, ADDRESS, PHONE_NUMBER, ID_CARD, REVENUE)  
VALUES(10952007, 'Pham Nguyen Minh', 'Trang', 'Female', TO_DATE('15/12/1992', 'dd/mm/yyyy'), '837 Le Hong Phong,Q5,TPHCM', '0837822285', '272443521', 15000);
INSERT INTO CUSTOMER(CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, DATE_OF_BIRTH, ADDRESS, PHONE_NUMBER, ID_CARD, REVENUE)  
VALUES(10952008, 'Nguyen Thi', 'Huong', 'Female', TO_DATE('10/11/1991', 'dd/mm/yyyy'), '50/34 Le Dai Hanh, Q10, TPHCM', '0237825224', '272443521', 2000);
INSERT INTO CUSTOMER(CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, DATE_OF_BIRTH, ADDRESS, PHONE_NUMBER, ID_CARD, REVENUE)  
VALUES(10952009, 'Le Ha', 'Vinh', 'Male', TO_DATE('25/8/1990', 'dd/mm/yyyy'), '34/34B Nguyen Trai, Q5, TPHCM', '0937885255', '272443521', 12000);
INSERT INTO CUSTOMER(CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, DATE_OF_BIRTH, ADDRESS, PHONE_NUMBER, ID_CARD, REVENUE)  
VALUES(10952010, 'Nguyen Van', 'Tam', 'Male', TO_DATE('8/1/1989', 'dd/mm/yyyy'), '227 Nguyen Van Cu, Q5, TPHCM', '0837825251', '272443521', 18000);
INSERT INTO CUSTOMER(CUSTOMER_ID, FIRST_NAME, LAST_NAME, GENDER, DATE_OF_BIRTH, ADDRESS, PHONE_NUMBER, ID_CARD, REVENUE)  
VALUES(10952011, 'Le Thi Hong', 'Cuc', 'Female', TO_DATE('8/1/1989', 'dd/mm/yyyy'), '227 Nguyen Van Cu, Q5, TPHCM', '0837785251', '272443521', 2000);

UPDATE CUSTOMER
SET USERLOGIN_ID = 520006
WHERE CUSTOMER_ID = 10952001;

UPDATE CUSTOMER
SET USERLOGIN_ID = 520007
WHERE CUSTOMER_ID = 10952002;

UPDATE CUSTOMER
SET USERLOGIN_ID = 520008
WHERE CUSTOMER_ID = 10952003;

UPDATE CUSTOMER
SET USERLOGIN_ID = 520009
WHERE CUSTOMER_ID = 10952004;

UPDATE CUSTOMER
SET USERLOGIN_ID = 520010
WHERE CUSTOMER_ID = 10952006;

UPDATE CUSTOMER
SET USERLOGIN_ID = 520011
WHERE CUSTOMER_ID = 10952007;

UPDATE CUSTOMER
SET USERLOGIN_ID = 520012
WHERE CUSTOMER_ID = 10952008;

UPDATE CUSTOMER
SET USERLOGIN_ID = 520013
WHERE CUSTOMER_ID = 10952009;

UPDATE CUSTOMER
SET USERLOGIN_ID = 520014
WHERE CUSTOMER_ID = 10952010;

INSERT INTO ACCOUNT_TYPE VALUES ('PA', 'Payment Account', 0);
INSERT INTO ACCOUNT_TYPE VALUES ('TSA01', 'Savings Account with a term of one month', 0.034);
INSERT INTO ACCOUNT_TYPE VALUES ('TSA03', 'Savings Account with a term of three months', 0.036);
INSERT INTO ACCOUNT_TYPE VALUES ('TSA06', 'Savings Account with a term of six months', 0.049);
INSERT INTO ACCOUNT_TYPE VALUES ('NSA01', 'Non-term Savings Account with a term of one month', 0.004);
INSERT INTO ACCOUNT_TYPE VALUES ('NSA03', 'Non-term Savings Account with a term of three months', 0.008);
INSERT INTO ACCOUNT_TYPE VALUES ('NSA06', 'Non-term Savings Account with a term of six months', 0.012);

INSERT INTO ACCOUNT VALUES(2012001, 'PA', 3000000, TO_DATE('21/02/2020','dd/MM/yyyy'), NULL, NULL, 'Active', 10952001); 
INSERT INTO ACCOUNT VALUES(2012002, 'PA', 35000000, TO_DATE('12/05/2020','dd/MM/yyyy'), NULL, NULL , 'Active', 10952002); 
INSERT INTO ACCOUNT VALUES(2012003, 'PA', 50000000, TO_DATE('25/07/2020','dd/MM/yyyy'), NULL, NULL, 'Active', 10952003); 
INSERT INTO ACCOUNT VALUES(2012004, 'PA', 500000, TO_DATE('05/10/2020','dd/MM/yyyy'), NULL, NULL, 'Active', 10952004); 
INSERT INTO ACCOUNT VALUES(2012005, 'PA', 8900000, TO_DATE('02/12/2020','dd/MM/yyyy'), NULL, NULL, 'Active', 10952005); 
INSERT INTO ACCOUNT VALUES(2012006, 'PA', 13000000, TO_DATE('25/12/2020','dd/MM/yyyy'), NULL, NULL, 'Active', 10952006);
INSERT INTO ACCOUNT VALUES(2012007, 'PA', 13000000, TO_DATE('25/12/2020','dd/MM/yyyy'), NULL, NULL, 'Active', 10952007);  

INSERT INTO TRANSACTION_TYPE VALUES('CT01', 'Internal Bank Transfer under 50 million VND', 2000);
INSERT INTO TRANSACTION_TYPE VALUES('CT02', 'Internal Bank Transfer over 50 million VND', 5000);
INSERT INTO TRANSACTION_TYPE VALUES('CT03', 'Interbank Transfer under 50 million VND', 7000);
INSERT INTO TRANSACTION_TYPE VALUES('CT04', 'Interbank Transfer over 50 million VND', 10000);
INSERT INTO TRANSACTION_TYPE VALUES('TT03', 'Pay the bill', 0);
INSERT INTO TRANSACTION_TYPE VALUES('TK01', 'Transfer money to a savings account',0);
INSERT INTO TRANSACTION_TYPE VALUES('TK02', 'Withdraw money from a savings account',0);
INSERT INTO TRANSACTION_TYPE VALUES('NT01', 'Receive money',0);

INSERT INTO TRANSACTION VALUES(1052001, 'CT01', TO_DATE('01/05/2021','dd/MM/yyyy'), 80000, 2012001);
INSERT INTO TRANSACTION VALUES(1052002, 'CT02', TO_DATE('01/05/2021','dd/MM/yyyy'), 50000, 2012002);
INSERT INTO TRANSACTION VALUES(1052003, 'CT02', TO_DATE('01/05/2021','dd/MM/yyyy'), 200000, 2012003);
INSERT INTO TRANSACTION VALUES(1052004, 'CT03', TO_DATE('01/05/2021','dd/MM/yyyy'), 2000, 2012002);
INSERT INTO TRANSACTION VALUES(1052005, 'CT03', TO_DATE('02/05/2021','dd/MM/yyyy'), 25000, 2012001);
INSERT INTO TRANSACTION VALUES(1052006, 'CT03', TO_DATE('02/05/2021','dd/MM/yyyy'), 12000000, 2012003);
INSERT INTO TRANSACTION VALUES(1052007, 'CT01', TO_DATE('02/05/2021','dd/MM/yyyy'), 100000, 2012003);
INSERT INTO TRANSACTION VALUES(1052008, 'TT03', TO_DATE('02/05/2021','dd/MM/yyyy'), 7000000, 2012004);
INSERT INTO TRANSACTION VALUES(1052009, 'CT01', TO_DATE('02/05/2021','dd/MM/yyyy'), 5200000, 2012004);
INSERT INTO TRANSACTION VALUES(1052010, 'CT01', TO_DATE('03/05/2021','dd/MM/yyyy'), 8800000, 2012005);
INSERT INTO TRANSACTION VALUES(1052011, 'TT03', TO_DATE('03/05/2021','dd/MM/yyyy'), 120000, 2012002);
INSERT INTO TRANSACTION VALUES(1052012, 'CT02', TO_DATE('03/05/2021','dd/MM/yyyy'), 10000, 2012003);
INSERT INTO TRANSACTION VALUES(1052013, 'CT02', TO_DATE('04/05/2021','dd/MM/yyyy'), 3560000, 2012003);
INSERT INTO TRANSACTION VALUES(1052014, 'CT03', TO_DATE('04/05/2021','dd/MM/yyyy'), 850000, 2012004);
INSERT INTO TRANSACTION VALUES(1052015, 'TT03', TO_DATE('04/05/2021','dd/MM/yyyy'), 5500000, 2012002);
INSERT INTO TRANSACTION VALUES(1052016, 'CT01', TO_DATE('04/05/2021','dd/MM/yyyy'), 2500000, 2012004);
INSERT INTO TRANSACTION VALUES(1052017, 'CT01', TO_DATE('05/05/2021','dd/MM/yyyy'), 700000, 2012001);
INSERT INTO TRANSACTION VALUES(1052018, 'TT03', TO_DATE('05/05/2021','dd/MM/yyyy'), 500000, 2012004);
INSERT INTO TRANSACTION VALUES(1052019, 'TT03', TO_DATE('05/05/2021','dd/MM/yyyy'), 7000000, 2012001);
INSERT INTO TRANSACTION VALUES(1052020, 'CT03', TO_DATE('05/03/2021','dd/MM/yyyy'), 7000000, 2012001);

INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME)
VALUES(1001, 'Nguyen Thi Thuy', 'Nga'); 
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME)
VALUES(1002, 'Tran Nhat', 'Khue'); 
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME)
VALUES(1003, 'Huynh Cong', 'Manh'); 
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME)
VALUES(1004, 'Duong Ngoc', 'Yen'); 
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME)
VALUES(1005, 'Ta Quang', 'Huy'); 

UPDATE EMPLOYEE
SET USERLOGIN_ID = 520001
WHERE EMPLOYEE_ID = 1001;

UPDATE EMPLOYEE
SET USERLOGIN_ID = 520002
WHERE EMPLOYEE_ID = 1002;

UPDATE EMPLOYEE
SET USERLOGIN_ID = 520003
WHERE EMPLOYEE_ID = 1003;

UPDATE EMPLOYEE
SET USERLOGIN_ID = 520004
WHERE EMPLOYEE_ID = 1004;

UPDATE EMPLOYEE
SET USERLOGIN_ID = 520005
WHERE EMPLOYEE_ID = 1005;

INSERT INTO SUPPLIER VALUES(1001, 'Dong Nai Water Supplier','Water', TO_DATE('05/05/2019','dd/MM/yyyy'), '52/3 An Duong Vuong, Q5, TpHCM' ,'18001124');
INSERT INTO SUPPLIER VALUES(1002, 'Thu Duc Water Supplier','Water', TO_DATE('03/04/2019','dd/MM/yyyy'), '08 Khong Tu , Q.ThuDuc, TpHCM' ,'18001212');
INSERT INTO SUPPLIER VALUES(1003, 'Ben Thanh Water Supplier','Water', TO_DATE('01/02/2007','dd/MM/yyyy'), '194 Pasteur , Q3, TpHCM' ,'18007147');
INSERT INTO SUPPLIER VALUES(1004, 'Da Nang Water Supplier','Water', TO_DATE('01/11/2016','dd/MM/yyyy'), '57 Xo Viet Nghe Tinh, Q.HaiChau, TpDaNang' ,'18006632');
INSERT INTO SUPPLIER VALUES(1005, 'Clean Water Ha Noi','Water', TO_DATE('22/01/2008','dd/MM/yyyy'), '44 Yen Phu, Q.Ba Dinh, TpHaNoi' ,'18003179');
INSERT INTO SUPPLIER VALUES(1006, 'Nothern Power Corp','Electricity', TO_DATE('05/02/2010','dd/MM/yyyy'), '20 Tran Nguyen Han , Q.HoanKiem, TpHaNoi' ,'19006769');
INSERT INTO SUPPLIER VALUES(1007, 'Southern Power Corp','Electricity', TO_DATE('30/06/2015','dd/MM/yyyy'), '72 Hai Ba Trung , Q1, TpHCM' ,'19001006');
INSERT INTO SUPPLIER VALUES(1008, 'Central Power Corp','Electricity', TO_DATE('07/10/1975','dd/MM/yyyy'), '78A Duy Tan , Q.HaiChau, TpDaNang' ,'19001909');
INSERT INTO SUPPLIER VALUES(1009, 'FPT Telecom','Internet', TO_DATE('31/07/1997','dd/MM/yyyy'), '10 Pham Van Bach  , Q.CauGiay, TpHaNoi' ,'19006600');
INSERT INTO SUPPLIER VALUES(1010, 'Viettel','Internet', TO_DATE('01/06/1989','dd/MM/yyyy'), '161-163 Tran Quoc Thao  , Q3, TpHCM' ,'18008000');
INSERT INTO SUPPLIER VALUES(1011, 'VNPT','Internet', TO_DATE('06/01/2011','dd/MM/yyyy'), '121 Pasteur, Q3, TpHCM' ,'18001091');

INSERT INTO BILL VALUES(1520001, 1001, 10952001, 25000, TO_DATE('01/03/2021','dd/MM/yyyy'), null, 'Unpaid' );
INSERT INTO BILL VALUES(1520002, 1002, 10952001, 500000, TO_DATE('01/03/2021','dd/MM/yyyy'), null, 'Unpaid' );
INSERT INTO BILL VALUES(1520003, 1003, 10952001, 246000, TO_DATE('01/03/2021','dd/MM/yyyy'), null, 'Unpaid' );
INSERT INTO BILL VALUES(1520004, 1004, 10952002, 241000, TO_DATE('01/03/2021','dd/MM/yyyy'), null, 'Unpaid' );
INSERT INTO BILL VALUES(1520005, 1005, 10952001, 230000, TO_DATE('01/03/2021','dd/MM/yyyy'), null, 'Unpaid' );
INSERT INTO BILL VALUES(1520006, 1006, 10952002, 63000, TO_DATE('01/03/2021','dd/MM/yyyy'), null, 'Unpaid' );
INSERT INTO BILL VALUES(1520007, 1007, 10952004, 600000, TO_DATE('01/04/2021','dd/MM/yyyy'), null, 'Unpaid' );
INSERT INTO BILL VALUES(1520008, 1008, 10952003, 46000, TO_DATE('01/04/2021','dd/MM/yyyy'), null, 'Unpaid' );
INSERT INTO BILL VALUES(1520009, 1009, 10952003, 405000, TO_DATE('01/04/2021','dd/MM/yyyy'), null, 'Unpaid' );
INSERT INTO BILL VALUES(1520010, 1010, 10952003, 230000, TO_DATE('01/04/2021','dd/MM/yyyy'), null, 'Unpaid' );
INSERT INTO BILL VALUES(1520011, 1011, 10952003, 100000, TO_DATE('01/04/2021','dd/MM/yyyy'), null, 'Unpaid' );
INSERT INTO BILL VALUES(1520012, 1001, 10952004, 50000, TO_DATE('01/04/2021','dd/MM/yyyy'), null, 'Unpaid' );
INSERT INTO BILL VALUES(1520013, 1002, 10952004, 80000, TO_DATE('01/04/2020','dd/MM/yyyy'), null, 'Unpaid' );
INSERT INTO BILL VALUES(1520014, 1005, 10952005, 150000, TO_DATE('01/04/2020','dd/MM/yyyy'), null, 'Unpaid' );
INSERT INTO BILL VALUES(1520015, 1011, 10952005, 250000, TO_DATE('01/04/2020','dd/MM/yyyy'), null, 'Unpaid' );

COMMIT;