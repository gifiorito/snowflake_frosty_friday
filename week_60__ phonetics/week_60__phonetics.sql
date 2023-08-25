-- Snowflake Frosty Friday
-- Week 60 - Intermediate - Similar sounding names (phonetic matches) - SOUNDEX()
-- https://frostyfriday.org/blog/2023/08/25/week-60-intermediate/

-- starting code
  CREATE OR REPLACE TABLE week_60 (
      name VARCHAR
  );
  
  INSERT INTO week_60 (name)
  VALUES
      ('John Smith'),
      ('Jon Smyth'),
      ('Jane Doe'),
      ('Jan Do'),
      ('Michael Johnson'),
      ('Mike Johnson'),
      ('Sarah Williams'),
      ('Sara Williams'),
      ('Robert Brown'),
      ('Roberto Brown'),
      ('Emily White'),
      ('Emilie Whyte'),
      ('David Lee'),
      ('Davey Li')
    ;

-- solution
WITH

numbered_table AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY 1) AS row_
        ,name
        ,SOUNDEX(name) AS phonetic_representation
    FROM week_60
)

SELECT
    l.row_ AS row_to_check
    ,r.row_ AS row_to_check_against
    ,l.name AS name_to_check
    ,r.name AS name_to_check_against
    ,l.phonetic_representation = r.phonetic_representation AS has_similar_sound
FROM numbered_table l
CROSS JOIN numbered_table r
WHERE l.row_ < r.row_
ORDER BY 1,2
;
  


