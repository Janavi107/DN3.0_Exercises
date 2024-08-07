--Write a stored procedure TransferFunds that transfers a specified amount from one account to another, 
--checking that the source account has sufficient balance before making the transfer.

CREATE OR REPLACE PROCEDURE TransferFunds (
    p_from_account_id IN Accounts.AccountID%TYPE,
    p_to_account_id IN Accounts.AccountID%TYPE,
    p_amount IN NUMBER
) IS
    v_from_balance NUMBER;
BEGIN
    -- Check balance and lock the source account row
    SELECT Balance INTO v_from_balance
    FROM Accounts
    WHERE AccountID = p_from_account_id
    FOR UPDATE;

    -- Ensure sufficient funds are available
    IF v_from_balance < p_amount THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient funds in the source account.');
    END IF;

    -- Deduct the amount from the source account
    UPDATE Accounts
    SET Balance = Balance - p_amount,
        LastModified = SYSDATE
    WHERE AccountID = p_from_account_id;

    -- Add the amount to the target account
    UPDATE Accounts
    SET Balance = Balance + p_amount,
        LastModified = SYSDATE
    WHERE AccountID = p_to_account_id;

    -- Commit the transaction
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Rollback in case of any errors
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: An unexpected error occurred while transferring funds: ' || SQLERRM);
END TransferFunds;
/

