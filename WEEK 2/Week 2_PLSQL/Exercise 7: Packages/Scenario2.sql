--Write a package EmployeeManagement with procedures to hire new employees, update employee details, and a function to calculate annual salary.


-- Package Specification for EmployeeManagement
CREATE OR REPLACE PACKAGE EmployeeManagement AS
    PROCEDURE HireNewEmployee(p_EmployeeID IN NUMBER, p_Name IN VARCHAR2, p_Position IN VARCHAR2, p_Salary IN NUMBER, p_Department IN VARCHAR2);
    PROCEDURE UpdateEmployeeDetails(p_EmployeeID IN NUMBER, p_Name IN VARCHAR2, p_Salary IN NUMBER, p_Position IN VARCHAR2);
    FUNCTION CalculateAnnualSalary(p_EmployeeID IN NUMBER) RETURN NUMBER;
END EmployeeManagement;
/

-- Package Body for EmployeeManagement
CREATE OR REPLACE PACKAGE BODY EmployeeManagement AS

    PROCEDURE HireNewEmployee(p_EmployeeID IN NUMBER, p_Name IN VARCHAR2, p_Position IN VARCHAR2, p_Salary IN NUMBER, p_Department IN VARCHAR2) IS
    BEGIN
        BEGIN
            INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
            VALUES (p_EmployeeID, p_Name, p_Position, p_Salary, p_Department, SYSDATE);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('Error: Employee with ID ' || p_EmployeeID || ' already exists.');
        END;
    END HireNewEmployee;

    PROCEDURE UpdateEmployeeDetails(p_EmployeeID IN NUMBER, p_Name IN VARCHAR2, p_Salary IN NUMBER, p_Position IN VARCHAR2) IS
    BEGIN
        UPDATE Employees
        SET Name = p_Name, Salary = p_Salary, Position = p_Position
        WHERE EmployeeID = p_EmployeeID;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: Employee with ID ' || p_EmployeeID || ' does not exist.');
        END IF;
    END UpdateEmployeeDetails;

    FUNCTION CalculateAnnualSalary(p_EmployeeID IN NUMBER) RETURN NUMBER IS
        v_Salary NUMBER;
    BEGIN
        SELECT Salary INTO v_Salary
        FROM Employees
        WHERE EmployeeID = p_EmployeeID;

        RETURN v_Salary * 12; -- Assuming salary is monthly
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Employee with ID ' || p_EmployeeID || ' does not exist.');
            RETURN NULL;
    END CalculateAnnualSalary;

END EmployeeManagement;
/
