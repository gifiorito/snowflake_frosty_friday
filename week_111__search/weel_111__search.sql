-- Snowflake Frosty Friday
-- Week 111 - Basic - Using SEARCH()
-- https://frostyfriday.org/blog/2024/09/20/week-111-basic/


-- data provided for the challenge [
with quotes as (
    select 'Better three hours too soon than a minute too late.' as quote
    union all
    select 'My words fly up, my thoughts remain below. Words without thoughts never to heaven go.'
    union all
    select 'Brevity is the soul of wit.'
    union all
    select 'Love looks not with the eyes, but with the mind; and therefore is winged Cupid painted blind'
    union all
    select 'Suit the action to the word, the word to the action.'
    union all
    select 'No legacy is so rich as honesty.'
    union all
    select 'All that glitters is not gold.'
    union all
    select 'Love all, trust a few, do wrong to none.'
    union all
    select 'Our doubts are traitors and make us lose the good we oft might win by fearing to attempt.'
    union all
    select 'Some are born great, some achieve greatness, and some have greatness thrust upon them'
    union all
    select 'To be or not to be: that is the question'
    union all
    select 'All the world’s a stage'
    union all
    select 'What, my dear Lady Disdain! Are you yet living?'
    union all
    select 'If music be the food of love, play on'
    union all
    select 'I cannot tell what the dickens his name is'
    union all
    select 'Shall I compare thee to a summer’s day?'
    union all
    select 'What’s in a name? A rose by any name would smell as sweet'
    union all
    select 'A horse! A horse! My kingdom for a horse!'
)
-- ]

-- solution of the challenge
select
    search(quote, 'love') as contains_love
    ,quote
from quotes