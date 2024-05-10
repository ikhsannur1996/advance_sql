# Advanced SQL for Data Warehousing

In data warehousing, advanced SQL techniques play a crucial role in optimizing performance, managing data integrity, and facilitating complex analytics. This document explores several advanced SQL concepts tailored for data warehouse environments.

## 1. Indexing

Indexing is essential for improving query performance, especially in large data warehouses. By creating indexes on columns frequently used in join conditions, WHERE clauses, or ORDER BY clauses, database engines can quickly locate and retrieve the relevant data.

Types of Indexes:
- **B-tree Index:** Suitable for range queries and equality searches.
- **Bitmap Index:** Efficient for columns with low cardinality and frequently used in data warehousing for analytical queries.
- **Hash Index:** Ideal for equality searches but not suitable for range queries.

```sql
-- Create an index on the DepartmentID column of the Employees table
CREATE INDEX idx_DepartmentID ON Employees (DepartmentID);

-- Query using the indexed column
SELECT * 
FROM Employees 
WHERE DepartmentID = 100;
```

Regularly analyze query execution plans and consider creating or adjusting indexes to optimize performance without over-indexing, which can impact write performance.

## 2. Implementing Functions

In data warehousing, implementing custom functions in SQL can streamline complex operations, enhance data processing capabilities, and improve code organization. Functions encapsulate reusable logic within the database, promoting code reusability, readability, and maintainability.

### Types of Functions:

- **Scalar Functions:** Return a single value based on input parameters. Useful for performing calculations or data transformations on individual rows.

- **Table-Valued Functions:** Return a set of rows as a result set. These functions can be used in the FROM clause of a SQL query, enabling complex data manipulations and transformations.

- **Aggregate Functions:** Operate on a set of values and return a single aggregated value. Common aggregate functions include SUM, AVG, COUNT, MAX, and MIN.

### Function to Extract Numbers from a String:

```sql
CREATE OR REPLACE FUNCTION ExtractNumbersFromString(input_string VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    result_string VARCHAR := '';
    i INT := 1;
BEGIN
    WHILE i <= LENGTH(input_string) LOOP
        -- Check if the character at position i is a digit
        IF SUBSTRING(input_string FROM i FOR 1) ~ '[0-9]' THEN
            -- Append the digit to the result string
            result_string := result_string || SUBSTRING(input_string FROM i FOR 1);
        END IF;
        i := i + 1;
    END LOOP;

    RETURN result_string;
END;
$$ LANGUAGE plpgsql;
```

### Function to Extract Strings from a Number:

```sql
CREATE OR REPLACE FUNCTION ExtractStringFromNumber(input_number INT)
RETURNS VARCHAR AS $$
DECLARE
    input_str VARCHAR := input_number::TEXT;
    extracted_str VARCHAR := '';
BEGIN
    -- Check if the number matches the expected pattern
    IF LENGTH(input_str) >= 3 THEN
        -- Extract the first three digits as the string
        extracted_str := SUBSTRING(input_str FROM 1 FOR 3);
    ELSE
        RAISE EXCEPTION 'Number does not contain enough digits to extract a string.';
    END IF;

    RETURN extracted_str;
END;
$$ LANGUAGE plpgsql;
```

Now, you can use these functions as needed:

```sql
-- Call the function to extract numbers from a string
SELECT ExtractNumbersFromString('abc123xyz456') AS ExtractedNumbers;

-- Call the function to extract a string from a number
SELECT ExtractStringFromNumber(123456) AS ExtractedString;
```

## 3. Stored Procedures

Stored procedures are precompiled SQL statements stored in the database for reuse. They enhance productivity, maintainability, and security by encapsulating complex logic within the database.

Benefits of Stored Procedures:
- **Improved Performance:** Stored procedures reduce network traffic by executing multiple SQL statements in a single call.
- **Security:** Access to data can be controlled through stored procedures, limiting direct table access.
- **Encapsulation:** Business logic resides in the database, promoting consistency and reducing code duplication.
- **Ease of Maintenance:** Changes to logic can be made centrally in the stored procedure, without requiring updates to application code.
```sql
-- Create a function to retrieve employee information for a given department
CREATE OR REPLACE FUNCTION GetEmployeesByDepartment(
    dept_id INT
)
RETURNS TABLE(
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT
)
AS $$
BEGIN
    RETURN QUERY 
    SELECT * 
    FROM Employees 
    WHERE DepartmentID = dept_id;
END;
$$ LANGUAGE plpgsql;

-- Call the function
SELECT * FROM GetEmployeesByDepartment(100);
```


When designing stored procedures, prioritize parameterization, error handling, and transaction management to ensure robustness and reliability.

## 4. Regular Expressions (Regex)

Regular expressions provide powerful pattern matching capabilities, allowing flexible and precise data extraction and manipulation within SQL queries.

https://www.postgresql.org/docs/current/functions-matching.html

Common Use Cases for Regex in Data Warehousing:
- **Data Cleansing:** Identify and standardize variations in data formats (e.g., dates, phone numbers, emails).
- **Pattern Matching:** Extract relevant information from unstructured or semi-structured data.
- **Data Validation:** Validate input data against predefined patterns or constraints.
  
```sql
-- Sample data
CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    OrderDate VARCHAR(20)
);

-- Insert sample data
INSERT INTO Orders (OrderDate)
VALUES ('2024-05-06'), ('05/06/2024'), ('06-May-24');

-- Query using regex to extract dates in 'YYYY-MM-DD' format
SELECT OrderID, OrderDate
FROM Orders
WHERE OrderDate ~ '^\d{4}-\d{2}-\d{2}$';
```

While regex can be a valuable tool, use it judiciously due to potential performance implications, especially when processing large datasets.

## 5. Hashing

Hashing functions in SQL are used to convert data of arbitrary size into a fixed-size value, typically for data encryption, data integrity checks, or indexing purposes.

Common Use Cases for Hashing in Data Warehousing:
- **Data Encryption:** Secure sensitive data by hashing passwords or other confidential information before storage.
- **Data Integrity:** Calculate hash values to detect changes or corruption in large datasets during storage or transmission.
- **Indexing:** Create hash indexes to accelerate lookup operations for large datasets, especially in distributed or parallel processing environments.

```sql
-- Ensure pgcrypto extension is available
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Calculate hash value for a given string
SELECT ENCODE(DIGEST('OpenAI', 'sha256'), 'hex') AS HashValue;
```


## 6. Encryption

Encryption is the process of converting data into a ciphertext that cannot be easily understood by unauthorized users. In SQL, encryption functions are commonly used to secure sensitive information stored in databases.

### Use Cases for Encryption

1. **Data Protection**: Secure sensitive data such as passwords or personally identifiable information (PII) before storing it in the database.
2. **Compliance**: Ensure compliance with data protection regulations by encrypting sensitive data at rest.
3. **Confidentiality**: Safeguard confidential information from unauthorized access, both in storage and during transmission.

### Example: Encrypting Data in PostgreSQL

```
-- Create table
CREATE TABLE encrypted_data (
    id SERIAL PRIMARY KEY,
    encrypted_column BYTEA
);

-- Insert encrypted data
INSERT INTO encrypted_data (encrypted_column) 
VALUES (pgp_sym_encrypt('Mohamad Ikhsan Nurulloh', '123'));

-- Select encrypted data
SELECT id, encode(encrypted_column, 'hex') AS encrypted_data_hex FROM encrypted_data;

-- Decrypt data while selecting
SELECT id, convert_from(pgp_sym_decrypt_bytea(encrypted_column, '123'), 'UTF-8') AS decrypted_data FROM encrypted_data;

```

