--Create a package AccountOperations with procedures for opening a new account, closing an account, 
--and a function to get the total balance of a customer across all accounts.

-- Package Specification for AccountOperations
CREATE OR REPLACE PACKAGE AccountOperations AS
    PROCEDURE OpenNewAccount(p_AccountID IN NUMBER, p_CustomerID IN NUMBER, p_AccountType IN VARCHAR2, p_Balance IN NUMBER);
    PROCEDURE CloseAccount(p_AccountID IN NUMBER);
    FUNCTION GetTotalBalance(p_CustomerID IN NUMBER) RETURN NUMBER;
END AccountOperations;
/

-- Package Body for AccountOperations
CREATE OR REPLACE PACKAGE BODY AccountOperations AS

    PROCEDURE OpenNewAccount(p_AccountID IN NUMBER, p_CustomerID IN NUMBER, p_AccountType IN VARCHAR2, p_Balance IN NUMBER) IS
    BEGIN
        BEGIN
            INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
            VALUES (p_AccountID, p_CustomerID, p_AccountType, p_Balance, SYSDATE);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('Error: Account with ID ' || p_AccountID || ' already exists.');
        END;
    END OpenNewAccount;

    PROCEDURE CloseAccount(p_AccountID IN NUMBER) IS
    BEGIN
        DELETE FROM Accounts
        WHERE AccountID = p_AccountID;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: Account with ID ' || p_AccountID || ' does not exist.');
        END IF;
    END CloseAccount;

    FUNCTION GetTotalBalance(p_CustomerID IN NUMBER) RETURN NUMBER IS
        v_TotalBalance NUMBER := 0;
    BEGIN
        FOR rec IN (SELECT Balance FROM Accounts WHERE CustomerID = p_CustomerID) LOOP
            v_TotalBalance := v_TotalBalance + rec.Balance;
        END LOOP;

        RETURN v_TotalBalance;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: No accounts found for Customer ID ' || p_CustomerID);
            RETURN NULL;
    END GetTotalBalance;

END AccountOperations;
/
