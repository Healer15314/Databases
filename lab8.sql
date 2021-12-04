--Task 1
--a)Increments given values by 1 and returns it
CREATE FUNCTION increment(value INT)
RETURNS INT AS $$
    BEGIN
        RETURN value+1;
    END;$$
    LANGUAGE PLPGSQL;

SELECT increment(7);

--b)Returns sum of 2 numbers
CREATE FUNCTION sum(number1 INT,number2 INT)
RETURNS INT AS $$
    BEGIN
        RETURN number1+number2;
    END; $$
LANGUAGE  PLPGSQL;

SELECT sum(3,2);

--c)Returns true or false if numbers are divisible by 2
CREATE FUNCTION is_even(value INT)
RETURNS BOOL AS $$
    BEGIN
        IF value % 2 = 0 THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END; $$
LANGUAGE PLPGSQL;

SELECT is_even(6);

--d)Check some password for validity
CREATE FUNCTION check_pass(password VARCHAR)
RETURNS BOOL AS $$
    BEGIN
       IF password SIMILAR TO '\w+\d*' THEN
           RETURN TRUE;
       ELSE
           RETURN FALSE;
       END IF;
    END;$$
LANGUAGE PLPGSQL;

SELECT check_pass('bauka');
CREATE TYPE pair AS(pass VARCHAR,stat VARCHAR);
--e)Returns two outputs, but has one input
CREATE FUNCTION validity(password VARCHAR)
RETURNS PAIR AS $$
    DECLARE res PAIR;stat VARCHAR;
    BEGIN
        IF check_pass(password) THEN stat = 'valid';
        ELSE stat = 'invalid';
        END IF;
        SELECT password,stat INTO res;
        RETURN res;
    END;$$
LANGUAGE PLPGSQL;
--Task 2
CREATE TABLE person(
    id INT PRIMARY KEY,
    name VARCHAR,
    last_name VARCHAR,
    date_of_birth DATE,
    age INT,
    insertion_time timestamp
);
CREATE TABLE item(
    item_id INT PRIMARY KEY,
    item_name VARCHAR,
    price_initial NUMERIC,
    price_final NUMERIC
);
--a)Return timestamp of the occurred action within the database.
CREATE FUNCTION trig_func()
RETURNS TRIGGER AS $$
    BEGIN
        new.insertion_time = now();
        RETURN new;
    END;$$
LANGUAGE PLPGSQL;

CREATE TRIGGER time_of_action BEFORE INSERT OR UPDATE
    ON person
    FOR EACH ROW
    EXECUTE PROCEDURE trig_func();

--b)Computes the age of a person when persons’ date of birth is inserted.
CREATE FUNCTION calc_age_function()
RETURNS TRIGGER AS $$
    DECLARE year_c INT;
    BEGIN
        SELECT date_part('year', age(new.date_of_birth)) INTO year_c;
        new.age = year_c;
        RETURN new;
    END;$$
LANGUAGE PLPGSQL;

CREATE TRIGGER calc_age_trigger
    BEFORE INSERT
    ON person
    FOR EACH ROW
    EXECUTE PROCEDURE calc_age_function();

DROP TRIGGER calc_age_trigger ON person;
DROP FUNCTION calc_age_function;
DROP FUNCTION trig_func;
DROP TRIGGER time_of_action ON person;

INSERT INTO person VALUES(1,'Bauyrzhan','Balgaziyev','2003-04-08');

DELETE FROM person WHERE id = 1;

--c)Adds 12% tax on the price of the inserted item.
CREATE FUNCTION adding_tax()
RETURNS TRIGGER AS $$
    BEGIN
        new.price_final = new.price_initial*1.12;
        return new;
    END;$$
LANGUAGE PLPGSQL;

CREATE TRIGGER adding_tax_trigger
    BEFORE UPDATE OR INSERT
    ON item
    FOR EACH ROW
    EXECUTE PROCEDURE adding_tax();


INSERT INTO item VALUES(3,'something3',1000);
INSERT INTO item VALUES(4,'smth',1000);

--d)Prevents deletion of any row from only one table.
CREATE FUNCTION prev_del()
RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO item VALUES(old.item_id,old.item_name,old.price_initial);
        RETURN old;
    END;$$
LANGUAGE PLPGSQL;

CREATE TRIGGER prevent_deletion AFTER DELETE
    ON item
    FOR EACH ROW
    EXECUTE PROCEDURE prev_del();

DROP TRIGGER prevent_deletion ON item;
DROP FUNCTION prev_del;

DELETE FROM item WHERE item_id = 3;

CREATE TABLE accounts(
    acc_id INT PRIMARY KEY,
    acc_name VARCHAR,
    password VARCHAR
);

--e)Launches functions  1.d and 1.e
CREATE FUNCTION launch()
RETURNS TRIGGER AS $$
    DECLARE pass_val pair;
    BEGIN
        pass_val = validity(new.password);
        IF pass_val.stat = 'valid' THEN RETURN new;
        ELSE RAISE 'INVALID PASSWORD';
        END IF;
    END;$$
LANGUAGE PLPGSQL;

CREATE TRIGGER launch_trig BEFORE INSERT
    ON accounts
    FOR EACH ROW
    EXECUTE PROCEDURE launch();

INSERT INTO accounts VALUES(2,'Nurbol','ggwpez123!!!');

--Task 3 What is the difference between procedure and function?
--The main difference between procedure and function in postgresql is that function returns some value whereas procedure do not.

--Task 4
--a)Increases salary by 10% for every 2 years of work experience and provides 10% discount and after 5 years adds 1% to the discount.
CREATE TABLE employee(
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR,
    date_of_birth DATE,
    age INT,
    salary NUMERIC,
    work_experience INT,
    discount INT
);
CREATE PROCEDURE benefits(id INT) AS $$
    DECLARE
        cf2 INT;
        sal NUMERIC;
        wx INT;
    BEGIN
        SELECT work_experience INTO wx FROM employee WHERE employee_id = id;
        UPDATE employee SET discount = 10, salary = salary + (salary/10) * (work_experience/2) WHERE employee_id = id;
        IF wx>=5 THEN UPDATE employee SET discount = discount + 1 WHERE employee_id = id;
        END IF;
    END;$$
LANGUAGE PLPGSQL;

INSERT INTO employee VALUES(1,'Bauyrzhan','2003-08-04',18,100,5);
INSERT INTO employee VALUES(2,'Nurbol','2002-03-08',19,200,3);
CALL benefits(1);

--b)After reaching 40 years, increase salary by 15%. If work experience is more than 8 years, increase salary for 15% of
-- the already increased value for work experience and provide a constant 20% discount.
CREATE PROCEDURE benefits2(id INT) AS $$
    DECLARE
        cf2 INT;
        e_age INT;
        wx INT;
    BEGIN
        SELECT age,work_experience INTO e_age,wx FROM employee WHERE employee.employee_id = id;
        cf2 = wx / 2;
        IF e_age>=40 THEN UPDATE employee SET salary = salary * 1.15 WHERE employee_id = id;
        END IF;
        IF wx>=8 THEN UPDATE employee SET salary = salary * 1.15,discount = 20 WHERE employee_id = id;
        END IF;
    END;$$
LANGUAGE PLPGSQL;

--Task 5
WITH RECURSIVE recommenders(recommender, member) AS (
    SELECT recommendedby, memid
    FROM cd.members
    UNION ALL
    SELECT cd.member.recommendedby, recommenders.member
    FROM recommenders
             INNER JOIN cd.members
                        ON cd.members.memid = recommenders.recommender
)
SELECT recommenders.member member, recommenders.recommender, cd.members.firstname, cd.members.surname
FROM recommenders
         INNER JOIN cd.members
                    ON recommenders.recommender = cd.members.memid
WHERE recommenders.member = 22
   OR recommenders.member = 12
ORDER BY recommenders.member, recommenders.recommender DESC