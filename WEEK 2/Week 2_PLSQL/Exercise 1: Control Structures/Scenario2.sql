--Write a PL/SQL block that iterates through all customers and sets a flag IsVIP to TRUE for those with a balance over $10,000.
BEGIN
  FOR customer IN (SELECT CustomerID FROM Customers WHERE Balance > 10000) LOOP
    UPDATE Customers
    SET IsVIP = TRUE
    WHERE CustomerID = customer.CustomerID;
  END LOOP;
END;
/

