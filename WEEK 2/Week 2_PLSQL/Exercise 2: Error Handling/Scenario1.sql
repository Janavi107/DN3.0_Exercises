--Write a stored procedure SafeTransferFunds that transfers funds between two accounts.
--Ensure that if any error occurs (e.g., insufficient funds), an appropriate error message is logged and the transaction is rolled back.

CREATE OR REPLACE PROCEDURE SafeTransferFunds(
    p_FromAccountID IN Accounts.AccountID%TYPE,
    p_ToAccountID IN Accounts.AccountID%TYPE,
    p_Amount IN Accounts.Balance%TYPE
) IS
    v_FromBalance Accounts.Balance%TYPE;
    v_ToBalance Accounts.Balance%TYPE;
    insufficient_funds EXCEPTION;
    account_not_found EXCEPTION;
BEGIN
    -- Get the balance of the from account
    SELECT Balance INTO v_FromBalance
    FROM Accounts
    WHERE AccountID = p_FromAccountID;
    
    -- Get the balance of the to account
    SELECT Balance INTO v_ToBalance
    FROM Accounts
    WHERE AccountID = p_ToAccountID;
    
    -- Check if the from account has sufficient funds
    IF v_FromBalance < p_Amount THEN
        RAISE insufficient_funds;
    END IF;
    
    -- Perform the transfer
    UPDATE Accounts
    SET Balance = Balance - p_Amount
    WHERE AccountID = p_FromAccountID;
    
    UPDATE Accounts
    SET Balance = Balance + p_Amount
    WHERE AccountID = p_ToAccountID;
    
    COMMIT;
EXCEPTION
    WHEN insufficient_funds THEN
        DBMS_OUTPUT.PUT_LINE('Error: Insufficient funds in the from account.');
        ROLLBACK;
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: One or both account IDs do not exist.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END SafeTransferFunds;
/
