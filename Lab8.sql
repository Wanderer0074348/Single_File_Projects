use 20220274db;

-- before update
CREATE TABLE customer (
   acc_no INTEGER PRIMARY KEY,
   cust_name VARCHAR(20),
   avail_balance DECIMAL
);

CREATE TABLE mini_statement (
   acc_no INTEGER,
   avail_balance DECIMAL,
   FOREIGN KEY(acc_no) REFERENCES customer(acc_no) ON DELETE CASCADE
);

INSERT INTO customer VALUES (1000, 'Fanny', 7000);
INSERT INTO customer VALUES (1001, 'Peter', 12000);

DELIMITER //
CREATE TRIGGER update_cus
BEFORE UPDATE ON customer
FOR EACH ROW
BEGIN
   INSERT INTO mini_statement VALUES (OLD.acc_no, OLD.avail_balance);
END; //
DELIMITER ; 

UPDATE customer SET avail_balance = avail_balance + 3000 WHERE acc_no = 1001; 
UPDATE customer SET avail_balance = avail_balance + 3000 WHERE acc_no = 1000;

select * from customer;
select * from mini_statement;

-- 2. After Update Trigger
CREATE TABLE customer2 (
   acc_no INTEGER PRIMARY KEY,
   cust_name VARCHAR(20),
   avail_balance DECIMAL
);

CREATE TABLE micro_statement (
   acc_no INTEGER,
   avail_balance DECIMAL,
   FOREIGN KEY(acc_no) REFERENCES customer2(acc_no) ON DELETE CASCADE
);

INSERT INTO customer2 VALUES (1002, 'Janitor', 4500);

DELIMITER //
CREATE TRIGGER update_after
AFTER UPDATE ON customer2
FOR EACH ROW
BEGIN
   INSERT INTO micro_statement VALUES(NEW.acc_no, NEW.avail_balance);
END; //
DELIMITER ;

UPDATE customer2 SET avail_balance = avail_balance + 1500 WHERE acc_no = 1002;

select *from micro_statement;

-- before insert trigger
CREATE TABLE contacts1 (
   contact_id INT(11) NOT NULL AUTO_INCREMENT,
   last_name VARCHAR(30) NOT NULL,
   first_name VARCHAR(25),
   birthday DATE,
   created_date DATE,
   created_by VARCHAR(30),
   CONSTRAINT contacts1_pk PRIMARY KEY (contact_id)
);

DELIMITER //
CREATE TRIGGER contacts1_before_insert
BEFORE INSERT ON contacts1
FOR EACH ROW
BEGIN
   DECLARE vUser VARCHAR(50);
   SELECT USER() INTO vUser;
   SET NEW.created_date = SYSDATE();
   SET NEW.created_by = vUser;
END; //
DELIMITER ;

INSERT INTO contacts1 (last_name, first_name, birthday) 
VALUES ('Newton', 'Enigma', STR_TO_DATE('19-08-1999', '%d-%m-%Y'));

select *from contacts1;

-- 4. After Insert Trigger
CREATE TABLE contacts2 (
   contact_id INT(11) NOT NULL AUTO_INCREMENT,
   last_name VARCHAR(30) NOT NULL,
   first_name VARCHAR(25),
   birthday DATE,
   CONSTRAINT contacts2_pk PRIMARY KEY (contact_id)
);

CREATE TABLE contacts2_audit (
   contact_id INTEGER,
   created_date DATE,
   created_by VARCHAR(30)
);

DELIMITER //
CREATE TRIGGER contacts2_after_insert
AFTER INSERT ON contacts2
FOR EACH ROW
BEGIN
   DECLARE vUser VARCHAR(50);
   SELECT USER() INTO vUser;
   INSERT INTO contacts2_audit
   (contact_id,
    created_date,
    created_by)
   VALUES
   (NEW.contact_id,
    SYSDATE(),
    vUser);
END; //
DELIMITER ;

INSERT INTO contacts2 (last_name, first_name, birthday) 
VALUES ('Kumar', 'Rupesh', STR_TO_DATE('20-06-1999', '%d-%m-%Y'));

select *from contacts2_audit;

-- before delete
CREATE TABLE contacts3 (
   contact_id INT(11) NOT NULL AUTO_INCREMENT,
   last_name VARCHAR(30) NOT NULL,
   first_name VARCHAR(25),
   birthday DATE,
   created_date DATE,
   created_by VARCHAR(30),
   CONSTRAINT contacts3_pk PRIMARY KEY (contact_id)
);
CREATE TABLE contacts3_audit (
   contact_id INTEGER,
   deleted_date DATE,
   deleted_by VARCHAR(20)
);

DELIMITER //
CREATE TRIGGER contacts3_before_delete
BEFORE DELETE ON contacts3
FOR EACH ROW
BEGIN
   DECLARE vUser VARCHAR(50);
   SELECT USER() INTO vUser;
   INSERT INTO contacts3_audit
   (contact_id,
    deleted_date,
    deleted_by)
   VALUES
   (OLD.contact_id,
    SYSDATE(),
    vUser);
END; //
DELIMITER ;

INSERT INTO contacts3 (last_name, first_name, birthday, created_date, created_by)
VALUES ('Bond', 'Ruskin', STR_TO_DATE('19-08-1995', '%d-%m-%Y'), STR_TO_DATE('27-04-2018', '%d-%m-%Y'), 'xyz');

-- safe mode issue
DELETE FROM contacts3 WHERE last_name = 'Bond';

select *from contacts3_audit;



