/* Two Types of Blocks in PLSQL
1. Anonymous Block
DECLARE
BEGIN
EXCEPTION
END;
/

2. Named Block ---- Stored as an Object in DB.

PROCEDURE
FUNCTION
PACKAGE
TRIGGER
*/

SET SERVEROUTPUT ON;
DECLARE  
    variable varchar2(10):='hi';
    num1 number(20,1):=&num1;
    num2 number(20,1):=&num2;
    add number(30,1);
BEGIN
    add:=num1+num2;
    dbms_output.put_line(variable);
    dbms_output.put_line('Addition value of '||num1||' and '||num2||' is '||add);
    
end;
/
--------------------------------------------Using select statement inside PLSQL Block using Variables---------------------------------------------------
SET SERVEROUTPUT ON;
Declare
    va_dep varchar(20);
Begin
    select department into va_1 from employee where emp_id='4';             --single variable
    dbms_output.put_line('department is '|| va_dep);
end;
/

SET SERVEROUTPUT ON;
Declare
    va_fname varchar(20);
    va_sal number(10);
Begin
    select first_name,salary into va_fname,va_sal from employee where emp_id='5';             --multi variable
    dbms_output.put_line('Employees First name is '||va_fname||' and its Salary is ' ||va_sal );
end;
/

--------------------------------------------Using DML statement inside PLSQL Block---------------------------------------------------
---1. INSERT

SET SERVEROUTPUT ON;
Declare
Begin
    insert into customer1 (cust_id, first_name, last_name,email,phone,city) 
    values (1, 'Amit', 'Shah', 'amit.shah@email.com', '9876543210', 'Mumbai');
    commit;
End;
/
--Insert values from existing customer table
SET SERVEROUTPUT ON;
Declare
Begin
    insert into customer1 
    select * from customer where cust_id != 1;
    commit;
End;
/

select * from customer;
select * from customer1;

---2. UPDATE
Begin
    update customer1 set first_name='Tanish' where cust_id=1;
End;
/

---3. DELETE
Begin
    delete from customer1 where cust_id=10;
    commit;
End;
/

----------------------------------------------Using %Type and %Rowtype inside PLSQL Block DDL as well-----------------------------------------------------------
create table cust 
(
    cust_id number(10) primary key,
    cust_name varchar2(40),
    dob date,
    mobile_n number(10),
    city varchar2(20)
    );
    
insert into cust (cust_id,cust_name,dob,mobile_n,city) values (1001, 'Arun', to_date('12/09/1985', 'mm/dd/yyyy'), 9090909090, 'Chennai');
insert into cust (cust_id,cust_name,dob,mobile_n,city) values (1002, 'John', to_date('01/09/1987', 'mm/dd/yyyy'), 9090909091, 'Pune');
insert into cust (cust_id,cust_name,dob,mobile_n,city) values (1003, 'Babu', to_date('06/23/1995', 'mm/dd/yyyy'), 9090909092, 'Hyderabad');
commit;
select * from cust;
---==============================================================================
set serveroutput on;
Declare
    var_mob_no number(10);
Begin
    select mobile_n into var_mob_no from cust where cust_id=1002;
    dbms_output.put_line('The mobile number is '|| var_mob_no);
End;
/
---==============================================================================
----Now we have to change the datatype of mobile_n from number to varchar2

alter table cust modify mobile_n varchar(20);
ORA-01439: column to be modified must be empty to change datatype

---So  Step 1: Add new VARCHAR2 column
alter table cust add mobile_new varchar(20);
---Step 2: Copy data (implicit conversion by Oracle)
update cust set mobile_new=mobile_n;
---Step 3: Drop the old NUMBER column
alter table cust drop column mobile_n;
---Step 4: Add '+91-" in front of all numbers.
update cust set mobile_new = '+91-'||mobile_new;
---Step 5: Rename new column to old column
alter table cust rename column mobile_new to mobile_n;
commit;

---But Now if try to run the Our PLSQL code again it will give error because our datatype inside our code is number but new type is varchar2.
---ORA-06502: PL/SQL: numeric or value error: character to number conversion error
---So we can use the %Type and %Rowtype so no need to mention the datatype to the variable for select it will directly refer the datatype from the table itself.

set serveroutput on;
Declare
var_mob_no cust.mobile_n%type;           ---For one specific coloumn use tablename.columnname%type so no matter how many times we change the datatype of column.
Begin
select mobile_n into var_mob_no from cust where cust_id=1002;
dbms_output.put_line('The mobile no is '||var_mob_no);
End;
/

set serveroutput on;
Declare
var_all_columns cust%rowtype; --One common variable to store all table data.
Begin
select * into var_all_columns from cust where cust_id=1002;     ---For more than one columns use tablename.%rowtype
dbms_output.put_line('The customer name is '||var_all_columns.cust_name);
dbms_output.put_line('The customer dob is '||var_all_columns.dob);
End;
/
-----------------------------------------------CONTROL/CONDITIONAL STATEMENTS-------------------------------------------------------------
--1. IF STATEMENTS
set serveroutput on;
declare
a boolean:=&a;
begin
    if a = true then
        dbms_output.put_line('a is true');
    elsif a is null then
        dbms_output.put_line('please give either true or false');
    else
        dbms_output.put_line('a is false');
    end if;
end;
/

--2. CASE
desc employee;
select * from employee;

set serveroutput on;
Declare
v_empid number(6):=&v_empid;
v_salary number(10);
v_fname varchar2(20);
Begin
    select salary, first_name into v_salary, v_fname from employee where emp_id=v_empid;
case
when v_salary > 70000 then
    dbms_output.put_line(v_fname||' has best salary Amount = '||v_salary); 
when v_salary >= 50000 and v_salary <= 70000 then
    dbms_output.put_line(v_fname||' has good salary Amount = '||v_salary);
when v_salary >= 40000 and v_salary < 50000 then
    dbms_output.put_line(v_fname||' has average salary Amount = '||v_salary);
else 
    dbms_output.put_line(v_fname||' has low salary Amount = '||v_salary);
end case;
End;
/
--NOTE IF WE WANT TO DISPLAY A COLUMN using SELECT GO WITH CASE STATEMENT

select * from cust;

select cust_id, cust_name, dob, city, mobile_n, 
case 
when initcap(city)= 'Chennai' then '+C-'||mobile_n
when initcap(city)= 'Pune' then '+P-'||mobile_n
when initcap(city)= 'Hyderabad' then '+H-'||mobile_n
else mobile_n
end as new_mob_no from cust;
    
-----------------------------------------------LOOPS-------------------------------------------------------------

--1. LOOP

declare 
c number(10):=0;
begin
loop
c:=c+2;
dbms_output.put_line(c);
exit when c>=10;
end loop;
end;
/

--2. WHILE LOOP

declare
c number(10):=0;
begin
while(c<5)
loop
dbms_output.put_line(c);
c:=c+1;
end loop;
end;
/

--3. FOR LOOP

declare
c number(10);
begin
for c in 1..5         --To print in reverse [for c in reverse 1..5]
loop
dbms_output.put_line(c);
end loop;
end;
/
--=========================================================== CURSOR ========================================================================
/*
✅ What is Cursor?

Cursor is defined as a private work area where the sql statement (SELECT and DML) is executed.
A cursor is a mechanism that lets you handle multiple rows returned by a query in PL/SQL.
You use a cursor when your SQL query returns multiple rows and you want to process them one by one. 
If you try to do it without cursor you may get error => ORA-01422: exact fetch returns more than requested number of rows
Without cursor you can fetch single row.

Two types:-

1. Implicit Cursor (Automatic)
  ----------------------------
Created automatically by Oracle for every session and managed by oracle whenever you run a DML and SELECT statement.
eg:-    SELECT * INTO v_name FROM employees WHERE emp_id = 10;
Oracle internally creates an implicit cursor to execute this. We donnot have control over this cursor but we can get information from its attributes.

+++Cursor Attributes (Common to Both)
Both implicit and explicit cursors have:

Attribute	Type        Meaning
%FOUND      Boolean   TRUE if last fetch/operation returned a row
%NOTFOUND	Boolean   TRUE if last operation returned no row
%ROWCOUNT	Number    Number of rows processed so far
%ISOPEN 	Boolean   TRUE if cursor is open

%ISOPEN is always FALSE
Because Oracle automatically opens and closes it in a single step
You cannot manually open or close it.
*/

--To see attributes of implicit cursor
desc cust;
select * from cust;
set serveroutput on;
Begin
update cust set mobile_n='+91-'||mobile_n where cust_id=&cust_id;
if sql%notfound then
    dbms_output.put_line('No data found');
else 
    dbms_output.put_line(sql%rowcount||' - rows updated');
end if;
End;
/

/*
2. Explicit Cursor (User Defined)
  --------------------------------
  An explicit cursor is a cursor that you create manually in PL/SQL to handle and process multiple rows returned by a query.
  Oracle does not automatically manage it — you control the OPEN, FETCH, and CLOSE steps.
  
*/
--NAMED EXPLICIT CURSOR
---For Bulk select
set serveroutput on;
Declare
    v_salary employee.salary%type;
    v_fname employee.first_name%type;
    cursor c1 is select salary, first_name from employee order by salary desc;
Begin
    open c1;
    loop
        fetch c1 into v_salary,v_fname;
        exit when (c1%notfound) or (c1%rowcount>5);
        dbms_output.put_line(v_fname||' - '||v_salary);
    end loop;
    dbms_output.put_line('');
    dbms_output.put_line('Total Rows :- '||c1%rowcount);
    close c1;
End;
/

--FOR EXPLICIT CURSOR
---Here we dont need to declare variable (a composite variable will handle it ) and open or close cursor, FOR will handle it.

set serveroutput on;
Declare
    cursor c2 is select last_name, salary from employee;
Begin
    for i in c2         -- i is composite variable.
    loop
    dbms_output.put_line(i.last_name||' has '||'this much '||i.salary);
    end loop;
End;
/

--PARAMETER EXPLICIT CURSOR
---A parameterized cursor is a cursor that accepts parameters when opened. To filter data dynamically to avoid hardcoded WHERE conditions and to
---reuse the same cursor for different values.
desc engineer;
select * from engineer;


set serveroutput on;
Declare
    cursor c3(e_branchid number) is select name, branch, salary from engineer where branch_id=e_branchid;
    e_name varchar2(20);
    e_branch varchar2(20);
    e_salary number(10,2);
Begin
    open c3(102);
    loop
    fetch c3 into e_name,e_branch,e_salary;
    exit when c3%notfound;
    dbms_output.put_line('The name is '||e_name||' - '||e_branch||' earns '||e_salary); 
    end loop;
    close c3;
End;
/

/*
REF CURSOR
Ref cursor is a datatype that holds a cursor value in thesame way a VARCHAR2 holds a string value. 
It is a pointer that points to the result of a query. “REF CURSOR is a pointer to a query result that allows dynamic queries and is mainly used 
to return result sets to applications.”
Two types of REF CURSOR:
    Strong REF CURSOR → return type is fixed (must match a table or rowtype).
    Weak REF CURSOR → no fixed return type (can return any query).
Most developers use weak REF CURSOR.
*/

-- i. Weak REF CURSOR → no fixed return type (can return any query).
set serveroutput on;
Declare
    type ref_cursor is REF CURSOR;
    rc_employee_data ref_cursor;
    e_name varchar2(20);
    v_lname varchar(20);
Begin
dbms_output.put_line('----- Engineer Table -----');
    open rc_employee_data for select name from engineer;
    loop
    fetch rc_employee_data into e_name;
    exit when rc_employee_data%notfound;
    dbms_output.put_line(e_name);
    end loop;
    close rc_employee_data;
dbms_output.put_line('----- Employee Table -----');
    open rc_employee_data for select last_name from employee;
    loop
    fetch rc_employee_data into v_lname;
    exit when rc_employee_data%notfound;
    dbms_output.put_line(v_lname);
    end loop;
    close rc_employee_data;
dbms_output.put_line('----- End -----');
End;
/

--- ii. Strong REF CURSOR → return type is fixed (must match a table or rowtype).

set serveroutput on;
Declare
type ref_cursor is REF CURSOR return employee%rowtype;
rc_employee_list ref_cursor;
e_allrecord employee%rowtype;

Begin
    open rc_employee_list for select * from employee;
    loop
    fetch rc_employee_list into e_allrecord;
    exit when rc_employee_list%notfound;
    dbms_output.put_line('The First name is - '||e_allrecord.first_name);
    dbms_output.put_line(e_allrecord.first_name||' s hire date is - '||e_allrecord.hire_date);
    end loop;
    close rc_employee_list;
End;
/


/*
✅ What is a Stored Procedure?

A Stored Procedure is a pre-compiled PL/SQL program stored in the database.
It performs a specific task (like inserting data, updating records, calculations, etc.)

Think of it like a function in programming, but stored inside the database.
*/
-- 1. Non parameterized
set serveroutput on;
Create or replace procedure proc_1
as
Begin
    dbms_output.put_line('Welcome to PLSQL Session');
End;

exec proc_1;

--To drop
drop procedure proc_1;


-- 2. Parameterized
/*
Types of Parameterized Procedures in PL/SQL
PL/SQL procedures support three parameter modes:
*/
--- A.️ IN parameter
--- Passes value into the procedure, Procedure cannot modify the value (read-only), Most commonly used.
set serveroutput on;
Create or replace procedure proc_2 (p_vid in number) 
as
Begin
    dbms_output.put_line('ID = '||p_vid);
End;

exec proc_2(10);
-- or use a PLSQL Block to execute.
Begin
    proc_2(10);
End;
/

--- B. OUT parameter
--- Procedure returns a value back to the caller, Works like a "return variable", Must be assigned inside the procedure.

set serveroutput on;
Create or replace procedure proc_3 (p_name out varchar2)
as
Begin
    p_name:= 'GAWKAR';
End;

--To execute this we need a PLSQL anonymous Block and declare a new string variable.
Declare
    v_name varchar(20);
Begin
    proc_3(v_name);
    dbms_output.put_line('The name is '||v_name||', SUYOG '||v_name);
End;
/

--- C. IN OUT parameter
--- Sends a value inside the procedure, Returns a (possibly modified) value back Useful when you want read+write access.

Create or replace procedure proc_4 (x in out number)
as
Begin
    x:=x*5;
End;

Declare 
    x number(10);
Begin
    x:=4;
    proc_4(x);
    dbms_output.put_line('Value of x is '||x);
End;
/

--- Parameterized Procedure with Cursor.
select * from engineer;
set serveroutput on;
Create or replace procedure get_engineers(in_branch_id IN engineer.branch_id%type)
as
v_name varchar(20);
v_salary number(10);
v_branch varchar(20); 
cursor c1 is select name, salary, branch into v_name, v_salary, v_branch from engineer where branch_id=in_branch_id order by salary desc;
Begin
    Open c1;
    loop
    fetch c1 into v_name,v_salary,v_branch;
    exit when c1%notfound;
    dbms_output.put_line('Name is '||v_name||' Branch is '||v_branch||' and Salary is '||v_salary);
    end loop;
    close c1;
End;


exec get_engineers(105);


/*
✅ What is a Function?
A function is a named PLSQL block which is similar to a procedure. Main difference between both of them is that a function always retuens a value whereas
a procedure may or may not return a value.
A function is a sub program that returns a value when called.
Functions can return more than one value  via OUT parameter. Functions can accept default values.
*/
--- 1. FUNCTION Ex 1
select * from engineer;
select branch, count(*) from engineer group by branch;
set serveroutput on;
Create or replace function salary_hike(p_eng_id IN number)
return number
as
v_dept engineer.branch%type;
v_salary engineer.salary%type;
v_raise number(10,2);
v_newsal number(10,2);
Begin
    select Branch, Salary into v_dept, v_salary from engineer where eng_id=p_eng_id;
    case
    when v_dept='Automobile' then 
    if (v_salary<55000) then v_raise:=0.50;
    elsif (v_salary>55000) then v_raise:=1.00;
    else v_raise:=0; end if;
    when v_dept='Mechanical' then
    if (v_salary<46000) then v_raise:=0.30;
    else v_raise:=0; end if;
    when v_dept='Computer' then
    if (v_salary<60000) then v_raise:=0.05;
    else v_raise:=0; end if;
    else v_raise:=0.10;
    end case;
    if v_raise>0
    then 
    v_newsal:= v_salary + (v_salary*v_raise);
    else
    v_newsal:= v_salary;
    end if;
    return v_newsal;
End;

select eng_id, name, branch,salary, salary_hike(eng_id) New_salary from engineer order by New_salary desc;
select eng_id, name, branch,salary, salary_hike(eng_id) New_salary from engineer where name='Suyog';

--- 2. FUNCTION Ex 2

create table employee_info
( EMP_ID number(5) primary key, FIRST_NAME varchar2(20), LAST_NAME varchar2(20));
desc employee_info;
insert into employee_info values (10, 'RAKESH', 'SHARMA');
insert into employee_info values (20, 'JOHN', 'PAUL');

create table emp_address_details
(EMP_ADDRESS_ID number(5) primary key, EMP_ID number(5) references employee_info(EMP_ID), CITY varchar2(15), STATE varchar2(15), COUNTRY varchar2(15), ZIP_CODE varchar2(15));
desc emp_address_details;
insert into emp_address_details values (101, 10, 'Vegas', 'LONDON', 'UK', '88901');
insert into emp_address_details values (102, 20, 'Carson', 'NEVADA', 'US', '90220');
commit;

select * from employee_info;
select * from emp_address_details;

set serveroutput on;
Create or replace function Get_Employee_Address(v_emp_id IN number)
return varchar2
as
v_address varchar2(1000);
Begin
    select 'Name is '||e.FIRST_NAME||' '||e.LAST_NAME||' '||'And Address is '||a.EMP_ADDRESS_ID||' '|| a.CITY||' '||a.STATE||' '||a.COUNTRY||' '||a.ZIP_CODE 
    into v_address
    from employee_info e, emp_address_details a where e.EMP_ID=v_emp_id and a.EMP_ID=e.EMP_ID;
    return v_address;
End;

select EMP_ID, FIRST_NAME, Get_Employee_Address(EMP_ID) ADDRESS from employee_info;


/*
✅ What is a Package?
A package is a container (like a folder) that groups related procedures, functions, variables, cursors, and exceptions into one unit.
Think of it like:

📁 Package: EMPLOYEE_MGMT
→ contains multiple related procedures & functions
• add_employee
• update_salary
• get_employee_details
• calculate_bonus
• variables, constants, cursors…

It helps keep your code organized, reusable, secure, and easier to maintain.
*/
select * from engineer;
set serveroutput on;

Create or replace Package ENG_MODIFY 
as
procedure add_engineer(e_eng_id number, e_name varchar2, e_branch varchar2,e_branch_id number, e_salary number, e_year number);
procedure delete_engineer(e_eng_id number);
function get_salary(e_eng_id number) return number;
end ENG_MODIFY;

Create or replace package body ENG_MODIFY
as
procedure add_engineer(e_eng_id number, e_name varchar2, e_branch varchar2,e_branch_id number, e_salary number, e_year number)
as
Begin
    insert into engineer values(e_eng_id, e_name, e_branch,e_branch_id, e_salary, e_year);
End;

procedure delete_engineer(e_eng_id number)
as
Begin
    delete from engineer where eng_id=e_eng_id;
End;

function get_salary(e_eng_id number) return number
as
    e_sal number(10);
Begin
    select salary into e_sal from engineer where eng_id=e_eng_id;
    return e_sal;
End;
End ENG_MODIFY;

exec ENG_MODIFY.add_engineer(21,'sanil','extc',108,25000,2030);
select ENG_MODIFY.get_salary(20) from dual;
exec ENG_MODIFY.delete_engineer(21);


/*
Pragma Autonomous Transaction
------------------------------
An autonomous transaction is a separate, independent transaction inside a PL/SQL block that allows
you to commit or rollback without affecting the main transaction.
*/
set serveroutput on;
CREATE TABLE one_tab (
    val NUMBER
);

CREATE OR REPLACE PROCEDURE child_insert(p_value NUMBER)
IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO one_tab VALUES (p_value);
    COMMIT;   -- autonomous transaction MUST commit
END;
/

Begin
    INSERT INTO one_tab VALUES (10);    -- Parent insert (normal transaction)
    child_insert(20);   -- Child insert (autonomous → commits immediately)
END;
/
select * from one_tab;
truncate table one_tab;
rollback;


/*
✅ What is a Trigger?
Triggers in PL/SQL are special stored programs that automatically execute (fire) when a specific event happens in the database.
They are not called manually—Oracle calls them automatically.
* uses
To audit changes
To enforce business rules
To maintain data consistency
To generate automatic values
For security controls

⭐ Types of Triggers
1. DML Triggers (Most Common)
Fire when a table is modified. Example uses: Validate data, Automatically insert into audit table.

A. Statement-Level Trigger  
🔹 Fires once per SQL statement, NOT per row.
Even if the SQL modifies 1000 rows, the trigger fires only once.
*/
CREATE OR REPLACE TRIGGER trg_statement
BEFORE INSERT ON employees
BEGIN
    DBMS_OUTPUT.PUT_LINE('Statement-level trigger fired');
END;
/
/*
B. Row-Level Trigger
🔹 Fires once for every row affected by the statement.
If 100 rows are inserted → trigger fires 100 times.

Types:-
🔹BEFORE INSERT
🔹BEFORE UPDATE
🔹BEFORE DELETE
🔹AFTER INSERT
🔹AFTER UPDATE
🔹AFTER DELETE
*/
set serveroutput on;
--✅ Step 1 — Create Sample Table
CREATE TABLE emp1 (
    emp_id   NUMBER,
    name     VARCHAR2(50),
    salary   NUMBER
);
--✅ Step 2 — Create Audit Table (to record actions)
CREATE TABLE emp_audit (
    action_type  VARCHAR2(20),
    emp_id       NUMBER,
    old_salary   NUMBER,
    new_salary   NUMBER,
    action_time  DATE
);
--1.  BEFORE INSERT 
Create or replace trigger bi_emp
before insert on emp1
for each row
Begin
    if :NEW.salary is NULL
    then
        :new.salary := 20000;
    end if;
End;
/

--2. After INSERT
Create or replace trigger ai_emp
after insert on emp1
for each row
Begin
     INSERT INTO emp_audit(action_type, emp_id, new_salary, action_time)
    VALUES ('INSERT', :NEW.emp_id, :NEW.salary, SYSDATE);
End;
/

--3. Before UPDATE
CREATE OR REPLACE TRIGGER bu_emp
BEFORE UPDATE ON emp1
FOR EACH ROW
BEGIN
    IF :NEW.salary < :OLD.salary THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salary cannot be decreased!');
    END IF;
END;
/

--4. After UPDATE
CREATE OR REPLACE TRIGGER au_emp
AFTER UPDATE ON emp1
FOR EACH ROW
BEGIN
    INSERT INTO emp_audit VALUES ('UPDATE', :OLD.emp_id, :OLD.salary, :NEW.salary, SYSDATE);
END;
/

--5. Before DELETE
CREATE OR REPLACE TRIGGER bd_emp
BEFORE DELETE ON emp1
FOR EACH ROW
BEGIN
    IF :OLD.salary > 50000 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Cannot delete high-salary employees!');
    END IF;
END;
/

--6. After DELETE
CREATE OR REPLACE TRIGGER ad_emp
AFTER DELETE ON emp1
FOR EACH ROW
BEGIN
    INSERT INTO emp_audit VALUES ('DELETE', :OLD.emp_id, :OLD.salary,:NEW.salary, SYSDATE);
END;
/

-- TESTING
INSERT INTO emp1 (emp_id, name, salary) VALUES (3, 'dummy1', 30000);
INSERT INTO emp1 (emp_id, name, salary) VALUES (4, 'dummy2', 30000);
select * from emp1;
select * from emp_audit;
Update emp1 set salary=60000 where emp_id=2;
Update emp1 set salary=10000 where emp_id=1;
Update emp1 set salary=40000 where emp_id=3;
delete from emp1 where emp_id=2;
delete from emp1 where emp_id=4;
commit;

/*
2. DDL Triggers
DDL triggers are used for control, security, and auditing.
*/

--A. BEFORE DDL
CREATE OR REPLACE TRIGGER trg_before_ddl
BEFORE DDL ON SCHEMA
BEGIN
    IF ORA_SYSEVENT = 'DROP' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Dropping objects is not allowed in this schema!');
    END IF;
END;
/
--TESTING
DROP TABLE emp;
ORA-20001: Dropping objects is not allowed in this schema!

--B. AFTER DDL
CREATE TABLE ddl_log (
    username    VARCHAR2(30),
    event_type  VARCHAR2(30),
    object_name VARCHAR2(30),
    event_time  DATE
);
drop trigger trg_after_ddl;
CREATE OR REPLACE TRIGGER trg_after_ddl
AFTER DDL ON SCHEMA
BEGIN
    INSERT INTO ddl_log
    VALUES (
        ORA_LOGIN_USER, ORA_SYSEVENT, ORA_DICT_OBJ_NAME, SYSDATE);
END;

--TESTING
CREATE TABLE test_table (id NUMBER);
SELECT * FROM ddl_log;

/*
3. INSTEAD OF TRIGGER
An INSTEAD OF trigger is a special trigger in Oracle that is used only on views, not on tables. 
Mostly used in case of complex views where we can edit both the base tables, Because not all views are directly updatable.
*/

CREATE TABLE dept3 (
    dept_id NUMBER PRIMARY KEY,
    dept_name VARCHAR2(20)
);

CREATE TABLE emp3 (
    emp_id NUMBER PRIMARY KEY,
    emp_name VARCHAR2(20),
    dept_id NUMBER REFERENCES dept3(dept_id)
);

--⭐ Create Complex View (JOIN VIEW)
create or replace view v$emp_dep_3 
as
select e.emp_id, e.emp_name, d.dept_id, d.dept_name from emp3 e join dept3 d on e.dept_id = d.dept_id;

--Try inserting
insert into v$emp_dep_3 values (1, 'Suyog', 'Automobile');
--SQL Error: ORA-01776: cannot modify more than one base table through a join view
-- So we will use Instead of trigger

Create or replace trigger tr_emp_dep_instead
instead of insert on v$emp_dep_3
Declare
check_exist number :=0;

Begin
select count(*) into check_exist from dept3 where dept_id=:new.dept_id;
if check_exist=0 then 
insert into dept3 (dept_id, dept_name) values (:new.dept_id, :new.dept_name);
end if;

select count(*) into check_exist from emp3 where emp_id=:new.emp_id;
if check_exist=0 then 
INSERT INTO emp3 (emp_id, emp_name, dept_id) VALUES (:new.emp_id, :new.emp_name, :new.dept_id);
end if;
end;
/

--TESTING
insert into v$emp_dep_3 values(1,'Suyog', 001, 'Automobile'); 
commit;
select * from v$emp_dep_3;
select * from emp3;
select * from dept3;

/*
🚫 What is a Mutating Trigger Error?
A mutating trigger error (ORA-04091) happens when:
👉 A row-level trigger
👉 Tries to read or modify the same table
👉 On which it is currently firing.

Oracle says:

“Table is mutating — cannot read it!”

Because the table is changing row-by-row, Oracle doesn’t allow reading it at the same moment.
*/



/*
⭐⭐ ORACLE DATA TYPES ⭐⭐
--------------------------
    [SCALAR DATA TYPES]                                [COMPOSITE DATA TYPES]
-- Number, int, float                            1. Record
-- char, varchar, varchar2, nvarchar             -- %Type
-- date, timestamp                               -- %Rowtype
-- boolean                                       
                                                 2. Collection
                                                 -- Varray
                                                 -- Nested Table
                                                 -- Associative Array
                                                 
                                                 
✅ What is a RECORD in PL/SQL?

A RECORD in PL/SQL is a composite data type that can store multiple related values with different datatypes 
together under one variable name — just like one row of a table.
👉 Each value inside a record is called a field.
Record = Group of variables of different data types stored together
*/
select * from emp3;
set serveroutput on;
Declare
    Type emp_rec is RECORD (
        emp_id number,
        emp_name varchar2(50)
        );
    rec_var emp_rec;
Begin 
    select emp_id, emp_name into rec_var from emp3 where emp_id=1;
    dbms_output.put_line('The ID of employee is : '||rec_var.emp_id);
    dbms_output.put_line('The NAME of employee is : '||rec_var.emp_name);
End;
/


/*
✅ What are Collections in PL/SQL?

Collections in PL/SQL are data structures that allow you to store multiple values of the same datatype under 
a single variable name — similar to arrays or lists in other languages.
Record = one row (different datatypes)
Collection = many rows (same datatype)
Handle multiple rows in memory
Improve performance (less context switching)
*/

--1. VARRAY
--A VARRAY is a collection type in PL/SQL that stores a fixed maximum number of elements and maintains element order.
--Maximum size is fixed at declaration.
--Values are shifted after DELETE
--🔸 Use Case
--✔ Small, fixed lists (phone numbers, days)

set serveroutput on;
Declare
Type phone_arr is varray(3) of number;
vphone phone_arr := phone_arr(111,222,333);
Begin
    dbms_output.put_line(vphone(1));
    --Methods
    dbms_output.put_line('Displaying Count of total elements in array : '||vphone.count);
    dbms_output.put_line('Displaying Array Max limit : '||vphone.limit);
    dbms_output.put_line('Displaying First index : '||vphone.first);
    dbms_output.put_line('Displaying Last index : '||vphone.last);
    vphone.trim;
    dbms_output.put_line('After trim count : '||vphone.count);
    vphone.extend;
    vphone(3):=444;
    dbms_output.put_line('New element value :'||vphone(3));
    dbms_output.put_line('After Extend count : '||vphone.count);
    if vphone.exists(4) then
    vphone(4):=555;
    else
    dbms_output.put_line('No extra space in array');
    end if;
    vphone.delete();
    dbms_output.put_line('After Delete count : '||vphone.count);
End;
/

--2. Nested Table
-- A Nested Table is a collection type in PL/SQL that can store multiple values of the same datatype, and does not have a fixed size.
-- Basically its an array that can grow dynamically and can have gaps in index values.

DECLARE
  TYPE t_nums IS TABLE OF NUMBER;
  v_nums t_nums := t_nums(10, 20, 30);
BEGIN
  v_nums.EXTEND;
  v_nums(4) := 40;

  v_nums.DELETE(2); -- deletes value 20

  FOR i IN v_nums.FIRST .. v_nums.LAST LOOP
    IF v_nums.EXISTS(i) THEN
      DBMS_OUTPUT.PUT_LINE(v_nums(i));
    END IF;
  END LOOP;
END;
/

--3. Associative Array
--An Associative Array is a PL/SQL-only collection that stores key–value pairs, similar to a hash map.

DECLARE
  TYPE t_salary IS TABLE OF NUMBER INDEX BY Varchar2(20);
  v_salary t_salary;
BEGIN
  v_salary('name1')  := 50000;
  v_salary('name2') := 60000;

  DBMS_OUTPUT.PUT_LINE(v_salary('name1'));
END;
/


---- ✅ BULK COLLECT
/*
🔹 What is BULK COLLECT in PL/SQL?
BULK COLLECT is a PL/SQL feature used to fetch multiple rows from SQL into collections in one operation instead of fetching row by row.
👉 Purpose: Improve performance by reducing context switching between SQL and PL/SQL.
*/
desc employees;
set serveroutput on;
Declare
    type nt_salary_type is table of employees.emp_salary%type;
    nt_salary nt_salary_type := nt_salary_type();
Begin
    select emp_salary bulk collect into nt_salary from employees;
    for i in nt_salary.first..nt_salary.last
    loop
        dbms_output.put_line(nt_salary(i));
    end loop;
End;
/

-- 1. Bulk Collect with Limit
Declare

CURSOR c_emp is select * from employees;
type emp_tab_type is table of employees%ROWTYPE;
emp_tab emp_tab_type := emp_tab_type();

Begin
    Open c_emp;
    LOOP
    fetch c_emp BULK COLLECT into emp_tab limit 5;
    exit when emp_tab.count = 0;
    
    For i in 1..emp_tab.count
    loop
    dbms_output.put_line('Name is : '||emp_tab(i).emp_name||' and Salary is : '||emp_tab(i).emp_salary);
    end loop;
    emp_tab.delete;
    end LOOP;
    close c_emp;
End;
/





