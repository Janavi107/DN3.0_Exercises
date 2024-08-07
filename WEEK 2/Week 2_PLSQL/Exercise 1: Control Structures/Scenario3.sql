--Write a PL/SQL block that fetches all loans due in the next 30 days and prints a reminder message for each customer.
BEGIN
  FOR loan IN (SELECT LoanID, CustomerID FROM Loans WHERE EndDate <= SYSDATE + 30) LOOP
    DBMS_OUTPUT.PUT_LINE('Reminder: Loan ID ' || loan.LoanID || ' is due within 30 days for customer ' || loan.CustomerID);
  END LOOP;
END;
/

