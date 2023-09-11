-- Snowflake Frosty Friday
-- Week 61 - Intermediate - Data cleanup and JSON object creation
-- https://frostyfriday.org/blog/2023/09/01/week-61-intermediate/

-- csv file: s3://frostyfridaychallenges/challenge_61/Telecom Products – Sheet1.csv

-- bring csv from s3 to Snowflake

-- data cleanup:
    -- – Fill the null values in the “Brand” column with the value from the first non-empty row from
    -- above (forward fill)
    -- – Fill null values in the “Friendly URL” column with the corresponding URL from the second
    -- column
    -- – Remove rows with null values in the Category column.

-- create json object with this format:
    -- {
    -- "Category": {
    --     "Brand": [
    --     {"Product Name": "Friendly URL"}
    --     ],
    -- "Brand": [
    --     {"Product Name": "Friendly URL"},
    --     {"Product Name": "Friendly URL"}
    -- ]
    -- },
    -- "Category": {
    -- "Brand": [
    --     {"Product Name": "Friendly URL"}
    -- ]
    -- },
    -- ...
    -- }
