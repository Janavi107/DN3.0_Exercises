--Write a PL/SQL block using an explicit cursor ApplyAnnualFee that deducts an annual maintenance fee from the balance of all accounts.

DECLARE
  CURSOR ApplyAnnualFee IS
    SELECT AccountID, Balance
    FROM Accounts;
  
  v_AccountID Accounts.AccountID%TYPE;
  v_Balance Accounts.Balance%TYPE;
BEGIN
  OPEN ApplyAnnualFee;
  LOOP
    FETCH ApplyAnnualFee INTO v_AccountID, v_Balance;
    EXIT WHEN ApplyAnnualFee%NOTFOUND;
    
    UPDATE Accounts
    SET Balance = Balance - 50,
        LastModified = SYSDATE
    WHERE AccountID = v_AccountID;
  END LOOP;
  CLOSE ApplyAnnualFee;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    ROLLBACK;
    IF ApplyAnnualFee%ISOPEN THEN
      CLOSE ApplyAnnualFee;
    END IF;
END;
/

