-- Testing behavior of date/time functions under setting 'first_day_of_week'.

SELECT '-- toStartOfInterval';

-- default behavior
SELECT
    toDateTime('2024-01-02 00:00:00', 'UTC') dt,
    toStartOfInterval(dt, INTERVAL 1 WEEK), -- Monday, Jan 01
    toStartOfInterval(dt, INTERVAL 2 WEEK); -- Monday, Dec 25

SELECT
    toDateTime('2024-01-02 00:00:00', 'UTC') dt,
    toStartOfInterval(dt, INTERVAL 1 WEEK), -- Monday, Jan 01
    toStartOfInterval(dt, INTERVAL 2 WEEK) -- Monday, Dec 25
SETTINGS first_day_of_week = 'Monday';

SELECT
    toDateTime('2024-01-02 00:00:00', 'UTC') dt,
    toStartOfInterval(dt, INTERVAL 1 WEEK), -- Sunday, Dec 31
    toStartOfInterval(dt, INTERVAL 2 WEEK) -- Sunday, Dec 24
SETTINGS first_day_of_week = 'Sunday';

SELECT '-- date_diff';

-- default behavior
SELECT
    toDateTime('2023-01-22 00:00:00', 'UTC') sunday,
    toDateTime('2023-01-23 00:00:00', 'UTC') monday,
    toDateTime('2023-01-24 00:00:00', 'UTC') tuesday,
    dateDiff('week', monday, tuesday),
    dateDiff('week', sunday, monday),
    age('week', monday, tuesday),
    age('week', sunday, monday),
    age('week', sunday, monday + toIntervalDay(10));

SELECT
    toDateTime('2023-01-22 00:00:00', 'UTC') sunday,
    toDateTime('2023-01-23 00:00:00', 'UTC') monday,
    toDateTime('2023-01-24 00:00:00', 'UTC') tuesday,
    dateDiff('week', monday, tuesday),
    dateDiff('week', sunday, monday),
    age('week', monday, tuesday),
    age('week', sunday, monday),
    age('week', sunday, monday + toIntervalDay(10))
SETTINGS first_day_of_week = 'Monday';

SELECT
    toDateTime('2023-01-22 00:00:00', 'UTC') sunday,
    toDateTime('2023-01-23 00:00:00', 'UTC') monday,
    toDateTime('2023-01-24 00:00:00', 'UTC') tuesday,
    dateDiff('week', monday, tuesday),
    dateDiff('week', sunday, monday),
    age('week', monday, tuesday),
    age('week', sunday, monday),
    age('week', sunday, monday + toIntervalDay(10))
SETTINGS first_day_of_week = 'Sunday';
