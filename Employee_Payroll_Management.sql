---=========================================================== Employee Payroll Management System ==============================================
/*
🔹 1. Project Overview

This project manages employee payroll using core PL/SQL concepts:
Employee onboarding
Salary & tax calculation
Payroll generation
Automatic audit using trigger
*/

set serveroutput on;
--🔹 2. Database Objects
create table employee_master 
(
    emp_id number primary key,
    emp_name varchar2(50),
    dept varchar2(30),
    basic_sal number,
    join_date date,
    status varchar2(10)
);

CREATE TABLE payroll (
  payroll_id NUMBER PRIMARY KEY,
  emp_id     NUMBER,
  month_year VARCHAR2(10),
  gross_sal  NUMBER,
  tax        NUMBER,
  net_sal    NUMBER
);

CREATE TABLE audit_log (
  action      VARCHAR2(30),
  emp_id      NUMBER,
  action_date DATE
);

-- Create sequence to create unique payroll id in payroll table

Create sequence payroll_seq start with 1;

--🔹 3. FUNCTION – Tax Calculation

Create or replace function fn_calc_tax(p_sal number)
return number as
Begin
    if p_sal < 30000 then
    return 0;
    elsif p_sal<50000 then
    return p_sal*0.10;
    else
        return p_sal*0.20;
    end if;
End;
/

--🔹 4. PROCEDURE – Add Employee

Create or replace procedure pro_add_employee (p_id number, p_name varchar2, p_dept varchar2, p_sal number)
as
Begin
    insert into employee_master values(p_id, p_name, p_dept, p_sal, sysdate, 'ACTIVE');
End;
/

--🔹 5. TRIGGER – Employee Audit
drop trigger trg_emp_audit;
Create or replace trigger trg_emp_audit_ins
after insert on employee_master
for each row 
Begin
    if inserting then
    insert into audit_log values ('EMPLOYEE INSERTED', :new.emp_id, sysdate);
    end if;
End;
/

Create or replace trigger trg_emp_audit_upd
after update on employee_master
for each row 
Begin
    if updating then
    insert into audit_log values ('EMPLOYEE UPDATED', :new.emp_id, sysdate);
    end if;
End;
/
--🔹 6. PACKAGE – Payroll Processing (Using Nested Table Collection)

Create or replace package pkg_payroll 
as
procedure generate_payroll (p_month varchar2);
End;
/

Create or replace package body pkg_payroll 
as
--Create nested collection to collect all required data
type emp_tab is table of employee_master%rowtype;
v_emp emp_tab := emp_tab();
--Implimenting cursor to store the required data from employee_master table to emp_tab collection to reduce context switching. 
Procedure generate_payroll (p_month varchar2) as
Cursor cur_emp is select * from employee_master where status='ACTIVE';
v_idx number := 0;
v_tax number := 0;
Begin
    for rec in cur_emp loop
    v_idx:= v_idx+1;
    v_emp.extend;
    v_emp(v_idx):=rec;
    end loop;
-- Process payroll from nested table collection to payroll table
    for i in 1..v_emp.count loop
    v_tax := fn_calc_tax(v_emp(i).basic_sal);
    insert into payroll values (payroll_seq.nextval, v_emp(i).emp_id, p_month, v_emp(i).basic_sal, v_tax, v_emp(i).basic_sal - v_tax);
    End Loop;
--Clear Collection
v_emp.delete;
End;
End pkg_payroll;
/

--🔹 7. TEST CASES
--✅ Test Case 1: Add Employees
EXEC pro_add_employee(1,'RAMESH','IT',28000);
EXEC pro_add_employee(2,'SURESH','HR',45000);
EXEC pro_add_employee(3,'MAHESH','FIN',65000);
commit;
select * from employee_master;

--✅ Test Case 2: Trigger Validation
SELECT * FROM audit_log;

--✅ Test Case 3: Generate Payroll
exec pkg_payroll.generate_payroll('JAN-25');
SELECT * FROM payroll;

--✅ Test Case 4: Inactive Employee
UPDATE employee_master SET status='INACTIVE' WHERE emp_id=2;
EXEC pkg_payroll.generate_payroll('FEB-25');
commit;
