---=========================================================== EMPLOYEE LEAVE MANAGEMENT PROJECT ==============================================
set serveroutput on;
---Step 1: Create Required Tables
/*
1. EMPLOYEE Table
Stores basic employee information.
*/
Create table employees(
emp_id number(10) primary key,
emp_name varchar2(20),
emp_department varchar2(20),
emp_salary number(20));
/*
2. LEAVE_REQUEST Table
Stores leave applications made by employees.
*/
Create table leave_request (
leave_id NUMBER(10) PRIMARY KEY,
emp_id NUMBER(10),
leave_date DATE,
leave_reason VARCHAR2(100),
FOREIGN KEY (emp_id) references employees(emp_id));

---Step 2: Insert Sample Data

insert into employees VALUES (101, 'Suyog', 'IT', 50000);
INSERT INTO employees VALUES (102, 'Ravi', 'HR', 40000);
INSERT INTO employees VALUES (103, 'Anita', 'Finance', 60000);
COMMIT;

---Step 3: Create Procedures

/*
3.1 Procedure: Add New Employee
Purpose: Add an employee into the system.
*/
Create or replace procedure ADD_EMPLOYEE (a_emp_id IN number, a_emp_name varchar2, a_emp_department varchar2, a_emp_salary number)
as
Begin
    insert into employees VALUES (a_emp_id, a_emp_name, a_emp_department, a_emp_salary);
    commit;
End;
/*
3.2 Procedure: Apply Leave
Purpose: Employee applies for leave.
*/
Create or replace procedure apply_leave (l_leave_id NUMBER, l_emp_id NUMBER, l_leave_date DATE, l_leave_reason VARCHAR2)
AS
Begin
    insert into leave_request Values 
    (l_leave_id , l_emp_id, l_leave_date, l_leave_reason);
    commit;
End;

---Step 4: Create Functions

/*
4.1 Function: get_total_leaves
Purpose: Count how many leaves an employee has taken.
*/
Create or replace function get_total_leaves_taken(tl_emp_id number)
return number
as
v_leave number(10);
Begin
    select count(*) into v_leave from leave_request where emp_id=tl_emp_id;
return v_leave;
End;

/*
4.2 Function: get_leave_balance
Purpose: Calculate remaining leaves.
Assuming total allowed leaves = 12 per year.
*/

Create or replace function get_leave_balance(gl_emp_id number)
return number
as
total_leaves number(10):=12;
leave_balance number(10);
leave_taken number(10);
Begin
    select count(*) into leave_taken from leave_request where emp_id=gl_emp_id;
    leave_balance:=total_leaves-leave_taken;
    return leave_balance;
End;

---Step 5: Cursor Program to Display All Leave Requests

Declare
    Cursor C_leave is select e.emp_id, l.leave_id, e.emp_name, l.leave_date, l.leave_reason from employees e JOIN leave_request l on e.emp_id=l.emp_id;
    e_emp_id number(10);
    l_leave_id number(10);
    e_emp_name varchar(20);
    l_leave_date date;
    l_leave_reason varchar(20);
Begin
    Open C_leave;
    Loop
    Fetch C_leave into e_emp_id, l_leave_id, e_emp_name, l_leave_date, l_leave_reason;
    exit when C_leave%notfound;
    dbms_output.put_line('Employee id : '||e_emp_id||'| Leave id : '||l_leave_id||'| Employee name : '||e_emp_name||'| Leave date : '||l_leave_date
    ||'| Leave reason : '||l_leave_reason);
    End loop;
    Close C_leave;
End;
/
---Step 6: Anonymous Blocks to TEST Everything

-- Test add_employee
Begin
    ADD_EMPLOYEE(104, 'Rohit', 'IT', 65000);
End;
select * from employees;

-- Test apply_leave
BEGIN
    apply_leave(3, 104,to_date('10-12-2025','DD-MM-YYYY'), 'Earned Leave');
END;
select * from leave_request;

-- Test get_total_leaves & get_leave_balance
Declare 
    v_total_leaves number(10);
    v_leave_balance number(10);
Begin
    v_total_leaves:= get_total_leaves_taken(104);
    v_leave_balance:=get_leave_balance(104);
    dbms_output.put_line('Leaves applied till date : '||v_total_leaves);
    dbms_output.put_line('Leaves remaining : '||v_leave_balance);
End;
/
