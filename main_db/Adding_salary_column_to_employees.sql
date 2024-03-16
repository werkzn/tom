--Adding salary column to employees for future tasks
ALTER TABLE employees
    ADD COLUMN salary numeric(12, 2);

UPDATE employees
    SET salary = 28.80
    WHERE employee_id = 1;
UPDATE employees
    SET salary = 72.23
    WHERE employee_id = 2;
UPDATE employees
    SET salary = 98.51
    WHERE employee_id = 3;
UPDATE employees
    SET salary = 71.37
    WHERE employee_id = 4;
UPDATE employees
    SET salary = 12.19
    WHERE employee_id = 5;
UPDATE employees
    SET salary = 83.54
    WHERE employee_id = 6;
UPDATE employees
    SET salary = 14.80
    WHERE employee_id = 7;
UPDATE employees
    SET salary = 88.00
    WHERE employee_id = 8;
UPDATE employees
    SET salary = 0.00
    WHERE employee_id = 9;