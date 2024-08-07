--Write a PL/SQL block using an explicit cursor GenerateMonthlyStatements that retrieves all transactions for the current month and
--prints a statement for each customer.

DECLARE
  CURSOR GenerateMonthlyStatements IS
    SELECT CustomerID, AccountID, Amount, TransactionType, TransactionDate
    FROM Transactions
    WHERE TransactionDate BETWEEN TRUNC(SYSDATE, 'MM') AND LAST_DAY(SYSDATE)
    ORDER BY CustomerID;
  
  v_CustomerID Transactions.CustomerID%TYPE;
  v_AccountID Transactions.AccountID%TYPE;
  v_Amount Transactions.Amount%TYPE;
  v_TransactionType Transactions.TransactionType%TYPE;
  v_TransactionDate Transactions.TransactionDate%TYPE;
  v_LastCustomerID Transactions.CustomerID%TYPE := NULL;
BEGIN
  DBMS_OUTPUT.ENABLE(1000000);
  OPEN GenerateMonthlyStatements;
  LOOP
    FETCH GenerateMonthlyStatements INTO v_CustomerID, v_AccountID, v_Amount, v_TransactionType, v_TransactionDate;
    EXIT WHEN GenerateMonthlyStatements%NOTFOUND;
    
    IF v_LastCustomerID IS NULL OR v_LastCustomerID != v_CustomerID THEN
      IF v_LastCustomerID IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
      END IF;
      DBMS_OUTPUT.PUT_LINE('Monthly Statement for Customer ID: ' || v_CustomerID);
      v_LastCustomerID := v_CustomerID;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('  Account: ' || v_AccountID ||
                         ' | Date: ' || TO_CHAR(v_TransactionDate, 'YYYY-MM-DD') ||
                         ' | Amount: ' || TO_CHAR(v_Amount, '999,990.00') ||
                         ' | Type: ' || v_TransactionType);
  END LOOP;
  CLOSE GenerateMonthlyStatements;
  IF v_LastCustomerID IS NOT NULL THEN
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

