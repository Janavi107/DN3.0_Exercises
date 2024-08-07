--Write a PL/SQL block using an explicit cursor UpdateLoanInterestRates that fetches all loans and updates their interest rates based on the new policy.

DECLARE
  CURSOR UpdateLoanInterestRates IS
    SELECT LoanID, InterestRate
    FROM Loans;
  
  v_LoanID Loans.LoanID%TYPE;
  v_InterestRate Loans.InterestRate%TYPE;
BEGIN
  OPEN UpdateLoanInterestRates;
  LOOP
    FETCH UpdateLoanInterestRates INTO v_LoanID, v_InterestRate;
    EXIT WHEN UpdateLoanInterestRates%NOTFOUND;
    
    UPDATE Loans
    SET InterestRate = v_InterestRate * 1.05
    WHERE LoanID = v_LoanID;
  END LOOP;
  CLOSE UpdateLoanInterestRates;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    ROLLBACK;
    IF UpdateLoanInterestRates%ISOPEN THEN
      CLOSE UpdateLoanInterestRates;
    END IF;
END;
/

