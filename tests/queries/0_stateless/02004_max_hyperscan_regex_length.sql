-- Tags: no-debug, no-fasttest, use-vectorscan

set max_hyperscan_regexp_length = 1;
set max_hyperscan_regexp_total_length = 1;

SELECT '- const pattern';

select multiMatchAny('123', ['1']);
select multiMatchAny('123', ['12']); -- { serverError 36 }
select multiMatchAny('123', ['1', '2']); -- { serverError 36 }

select multiMatchAnyIndex('123', ['1']);
select multiMatchAnyIndex('123', ['12']); -- { serverError 36 }
select multiMatchAnyIndex('123', ['1', '2']); -- { serverError 36 }

select multiMatchAllIndices('123', ['1']);
select multiMatchAllIndices('123', ['12']); -- { serverError 36 }
select multiMatchAllIndices('123', ['1', '2']); -- { serverError 36 }

select multiFuzzyMatchAny('123', 0, ['1']);
select multiFuzzyMatchAny('123', 0, ['12']); -- { serverError 36 }
select multiFuzzyMatchAny('123', 0, ['1', '2']); -- { serverError 36 }

select multiFuzzyMatchAnyIndex('123', 0, ['1']);
select multiFuzzyMatchAnyIndex('123', 0, ['12']); -- { serverError 36 }
select multiFuzzyMatchAnyIndex('123', 0, ['1', '2']); -- { serverError 36 }

select multiFuzzyMatchAllIndices('123', 0, ['1']);
select multiFuzzyMatchAllIndices('123', 0, ['12']); -- { serverError 36 }
select multiFuzzyMatchAllIndices('123', 0, ['1', '2']); -- { serverError 36 }

SELECT '- non-const pattern';

drop table if exists tab_okay;
create table tab_okay
  (id UInt32, haystack String, needles Array(String))
  engine = MergeTree()
  order by id;
insert into tab_okay values (1, '123', ['1']);

drop table if exists tab_single_regex_too_long;
create table tab_single_regex_too_long
  (id UInt32, haystack String, needles Array(String))
  engine = MergeTree()
  order by id;
insert into tab_single_regex_too_long values (1, '123', ['12']);

drop table if exists tab_too_many_regexes;
create table tab_too_many_regexes
  (id UInt32, haystack String, needles Array(String))
  engine = MergeTree()
  order by id;
insert into tab_too_many_regexes values (1, '123', ['1', '2']);

select multiMatchAny(haystack, needles) from tab_okay;
select multiMatchAny(haystack, needles) from tab_single_regex_too_long; -- { serverError 36 }
select multiMatchAny(haystack, needles) from tab_too_many_regexes; -- { serverError 36 }

select multiMatchAnyIndex(haystack, needles) from tab_okay;
select multiMatchAnyIndex(haystack, needles) from tab_single_regex_too_long; -- { serverError 36 }
select multiMatchAnyIndex(haystack, needles) from tab_too_many_regexes; -- { serverError 36 }

select multiMatchAllIndices(haystack, needles) from tab_okay;
select multiMatchAllIndices(haystack, needles) from tab_single_regex_too_long; -- { serverError 36 }
select multiMatchAllIndices(haystack, needles) from tab_too_many_regexes; -- { serverError 36 }

select multiFuzzyMatchAny(haystack, 0, needles) from tab_okay;
select multiFuzzyMatchAny(haystack, 0, needles) from tab_single_regex_too_long; -- { serverError 36 }
select multiFuzzyMatchAny(haystack, 0, needles) from tab_too_many_regexes; -- { serverError 36 }

select multiFuzzyMatchAnyIndex(haystack, 0, needles) from tab_okay;
select multiFuzzyMatchAnyIndex(haystack, 0, needles) from tab_single_regex_too_long; -- { serverError 36 }
select multiFuzzyMatchAnyIndex(haystack, 0, needles) from tab_too_many_regexes; -- { serverError 36 }

select multiFuzzyMatchAllIndices(haystack, 0, needles) from tab_okay;
select multiFuzzyMatchAllIndices(haystack, 0, needles) from tab_single_regex_too_long; -- { serverError 36 }
select multiFuzzyMatchAllIndices(haystack, 0, needles) from tab_too_many_regexes; -- { serverError 36 }

drop table if exists tab_okay;
drop table if exists tab_single_regex_too_long;
drop table if exists tab_too_many_regexes;
