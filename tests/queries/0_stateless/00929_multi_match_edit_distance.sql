-- Tags: no-fasttest, use-vectorscan

SET send_logs_level = 'fatal';

SELECT '- const pattern';

-- run queries multiple times to test the pattern caching
select multiFuzzyMatchAny('abc', 0, ['a1c']) from system.numbers limit 3;
select multiFuzzyMatchAny('abc', 1, ['a1c']) from system.numbers limit 3;
select multiFuzzyMatchAny('abc', 2, ['a1c']) from system.numbers limit 3;
select multiFuzzyMatchAny('abc', 3, ['a1c']) from system.numbers limit 3; -- { serverError 36 }
select multiFuzzyMatchAny('abc', 4, ['a1c']) from system.numbers limit 3; -- { serverError 36 }

select multiFuzzyMatchAny('leftabcright', 1, ['a1c']) from system.numbers limit 3;

select multiFuzzyMatchAny('hello some world', 0, ['^hello.*world$']);
select multiFuzzyMatchAny('hallo some world', 1, ['^hello.*world$']);
select multiFuzzyMatchAny('halo some wrld', 2, ['^hello.*world$']);
select multiFuzzyMatchAny('halo some wrld', 2, ['^hello.*world$', '^halo.*world$']);
select multiFuzzyMatchAny('halo some wrld', 2, ['^halo.*world$', '^hello.*world$']);
select multiFuzzyMatchAny('halo some wrld', 3, ['^hello.*world$']);
select multiFuzzyMatchAny('hello some world', 10, ['^hello.*world$']); -- { serverError 36 }
select multiFuzzyMatchAny('hello some world', -1, ['^hello.*world$']); -- { serverError 43 }
select multiFuzzyMatchAny('hello some world', 10000000000, ['^hello.*world$']); -- { serverError 44 }
select multiFuzzyMatchAny('http://hyperscan_is_nice.de/st', 2, ['http://hyperscan_is_nice.de/(st\\d\\d$|st\\d\\d\\.|st1[0-4]\\d|st150|st\\d$|gl|rz|ch)']);
select multiFuzzyMatchAny('string', 0, ['zorro$', '^tring', 'in$', 'how.*', 'it{2}', 'works']);
select multiFuzzyMatchAny('string', 1, ['zorro$', '^tring', 'ip$', 'how.*', 'it{2}', 'works']);
select multiFuzzyMatchAnyIndex('string', 1, ['zorro$', '^tring', 'ip$', 'how.*', 'it{2}', 'works']);
select multiFuzzyMatchAnyIndex('halo some wrld', 2, ['^hello.*world$', '^halo.*world$']);
select multiFuzzyMatchAnyIndex('halo some wrld', 2, ['^halo.*world$', '^hello.*world$']);
--
select arraySort(multiFuzzyMatchAllIndices('halo some wrld', 2, ['some random string', '^halo.*world$', '^halo.*world$', '^halo.*world$', '^hallllo.*world$']));
select multiFuzzyMatchAllIndices('halo some wrld', 2, ['^halllllo.*world$', 'some random string']);

SELECT '- non-const pattern';

drop table if exists tab1;
create table tab1
  (id UInt32, haystack String, needles Array(String))
  engine = MergeTree()
  order by id;
insert into tab1 values (1, 'abc', ['a1c']);
insert into tab1 values (2, 'abc', ['a1c']);
insert into tab1 values (3, 'abc', ['a1c']);

select multiFuzzyMatchAny(haystack, 0, needles) from tab1 order by id;
select multiFuzzyMatchAny(haystack, 1, needles) from tab1 order by id;
select multiFuzzyMatchAny(haystack, 2, needles) from tab1 order by id;
select multiFuzzyMatchAny(haystack, 3, needles) from tab1 order by id; -- { serverError 36}
select multiFuzzyMatchAny(haystack, 4, needles) from tab1 order by id; -- { serverError 36}

drop table if exists tab2;
create table tab2
  (id UInt32, haystack String, needles Array(String))
  engine = MergeTree()
  order by id;
insert into tab2 values (1, 'leftabcright', ['a1c']);
insert into tab2 values (2, 'leftabcright', ['a1c']);
insert into tab2 values (3, 'leftabcright', ['a1c']);

select multiFuzzyMatchAny(haystack, 1, needles) from tab2 order by id;

drop table if exists tab3;
create table tab3
  (id UInt32, haystack String, needles Array(String))
  engine = MergeTree()
  order by id;
insert into tab3 values (1, 'hello some world', ['^hello.*world$']);
insert into tab3 values (2, 'hallo some world', ['^hello.*world$']);
insert into tab3 values (3, 'halo some wrld', ['^hello.*world$']);
insert into tab3 values (4, 'halo some wrld', ['^hello.*world$', '^halo.*world$']);
insert into tab3 values (5, 'halo some wrld', ['^halo.*world$', '^hello.*world$']);
insert into tab3 values (6, 'halo some wrld', ['^hello.*world$']);
insert into tab3 values (7, 'hello some world', ['^hello.*world$']);
insert into tab3 values (8, 'hello some world', ['^hello.*world$']);
insert into tab3 values (9, 'hello some world', ['^hello.*world$']);
insert into tab3 values (10, 'http://hyperscan_is_nice.de/st', ['http://hyperscan_is_nice.de/(st\\d\\d$|st\\d\\d\\.|st1[0-4]\\d|st150|st\\d$|gl|rz|ch)']);
insert into tab3 values (11, 'string', ['zorro$', '^tring', 'in$', 'how.*', 'it{2}', 'works']);
insert into tab3 values (12, 'string', ['zorro$', '^tring', 'ip$', 'how.*', 'it{2}', 'works']);
insert into tab3 values (13, 'string', ['zorro$', '^tring', 'ip$', 'how.*', 'it{2}', 'works']);
insert into tab3 values (14, 'halo some wrld', ['^hello.*world$', '^halo.*world$']);
insert into tab3 values (15, 'halo some wrld', ['^halo.*world$', '^hello.*world$']);
insert into tab3 values (16, 'halo some wrld', ['some random string', '^halo.*world$', '^halo.*world$', '^halo.*world$', '^hallllo.*world$']);
insert into tab3 values (17, 'halo some wrld', ['^halllllo.*world$', 'some random string']);

select multiFuzzyMatchAny(haystack, 0, needles) from tab3 where id = 1 order by id;
select multiFuzzyMatchAny(haystack, 1, needles) from tab3 where id = 2 order by id;
select multiFuzzyMatchAny(haystack, 2, needles) from tab3 where id = 3 order by id;
select multiFuzzyMatchAny(haystack, 2, needles) from tab3 where id = 4 order by id;
select multiFuzzyMatchAny(haystack, 2, needles) from tab3 where id = 5 order by id;
select multiFuzzyMatchAny(haystack, 3, needles) from tab3 where id = 6 order by id;
select multiFuzzyMatchAny(haystack, 10, needles) from tab3 where id = 7 order by id; -- { serverError 36 }
select multiFuzzyMatchAny(haystack, -1, needles) from tab3 where id = 9 order by id; -- { serverError 43 }
select multiFuzzyMatchAny(haystack, 10000000000, needles) from tab3 where id = 9 order by id; -- { serverError 44 }
select multiFuzzyMatchAny(haystack, 2, needles) from tab3 where id = 10 order by id; -- { serverError 44 }
select multiFuzzyMatchAny(haystack, 0, needles) from tab3 where id = 11 order by id; -- { serverError 44 }
select multiFuzzyMatchAny(haystack, 1, needles) from tab3 where id = 12 order by id;
select multiFuzzyMatchAnyIndex(haystack, 1, needles) from tab3 where id = 13 order by id;
select multiFuzzyMatchAnyIndex(haystack, 2, needles) from tab3 where id = 14 order by id;
select multiFuzzyMatchAnyIndex(haystack, 2, needles) from tab3 where id = 15 order by id;
select arraySort(multiFuzzyMatchAllIndices(haystack, 2, needles)) from tab3 where id = 16 order by id;
select multiFuzzyMatchAllIndices(haystack, 2, needles) from tab3 where id = 17 order by id;

drop table if exists tab1;
drop table if exists tab2;
drop table if exists tab3;
