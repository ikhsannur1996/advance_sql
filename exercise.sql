CREATE OR REPLACE FUNCTION HashNumbers(input_string TEXT)
RETURNS TEXT
AS $$
DECLARE
    numbers_only TEXT;
    hash_value TEXT;
BEGIN
    -- Use regexp_replace to extract numbers from the input string
    numbers_only := regexp_replace(input_string, '[^0-9]', '', 'g');

    -- Calculate hash value for the extracted numbers
    hash_value := ENCODE(DIGEST(numbers_only, 'sha256'), 'hex');

    RETURN hash_value;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT HashNumbers('abc123def456xyz');

CREATE OR REPLACE FUNCTION ExtractAndHashNumbers(input_string TEXT)
RETURNS TEXT

AS $$
DECLARE
    numbers_only TEXT;
    hash_value TEXT;
BEGIN
    -- Use regexp_replace to extract numbers from the input string
    numbers_only := regexp_replace(input_string, '[^0-9]', '', 'g');

    -- Calculate hash value for the extracted numbers
    hash_value := ENCODE(DIGEST(numbers_only, 'sha256'), 'hex');

    RETURN hash_value;
END;
$$ LANGUAGE plpgsql;


-- Test the function
SELECT ExtractAndHashNumbers('abc123def456xyz');


CREATE OR REPLACE FUNCTION ExtractNumbersFromString(input_string TEXT)
RETURNS TEXT
AS $$
DECLARE
    output_string TEXT;
BEGIN
    -- Use regexp_replace to remove all non-numeric characters
    output_string := regexp_replace(input_string, '[^0-9]', '', 'g');
    
    RETURN output_string;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT ExtractNumbersFromString('abc123def456xyz');

CREATE OR REPLACE FUNCTION ExtractStringFromNumber(input_number INTEGER)
RETURNS TEXT
AS $$
DECLARE
    output_string TEXT;
BEGIN
    -- Convert the number to a string
    output_string := input_number::TEXT;

    -- Use regexp_replace to remove all numeric characters
    output_string := regexp_replace(output_string, '[0-9]', '', 'g');

    RETURN output_string;
END;
$$ LANGUAGE plpgsql;


-- Test the function
SELECT ExtractStringFromNumber(12345);

