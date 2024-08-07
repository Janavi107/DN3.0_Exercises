--Write a PL/SQL block that loops through all customers, checks their age, and if they are above 60, apply a 1% discount to their current loan interest rates.
DECLARE
  CURSOR customer_cursor IS
    SELECT CustomerID
    FROM Customers
    WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM DOB) > 60;
BEGIN
  FOR customer IN customer_cursor LOOP
    UPDATE Loans
    SET InterestRate = InterestRate * 0.99
    WHERE CustomerID = customer.CustomerID;
  END LOOP;
END;
/

