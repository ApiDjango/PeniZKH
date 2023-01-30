CREATE PROCEDURE calculate_late_fees(
    IN invoice_due_date DATE,
    IN debt_amount DECIMAL(10,2),
    IN service_reference VARCHAR(50),
    IN payment_date DATE,
    OUT fee DECIMAL(10,2)
)
BEGIN
    DECLARE interest_rate DECIMAL(5,2);
    SELECT interest_rate INTO interest_rate FROM services_reference WHERE service_reference = :service_reference;

    DECLARE days_of_delay INTEGER;
    SET days_of_delay = CAST((payment_date - invoice_due_date) AS INTEGER);

    IF (days_of_delay >= 91) THEN
        SET fee = (debt_amount * (interest_rate / 100) * (1 / 130)) * days_of_delay;
    ELSEIF (days_of_delay >= 31) THEN
        SET fee = (debt_amount * (interest_rate / 100) * (1 / 300)) * days_of_delay;
    ELSE
        SET fee = 0;
    END IF;
END
