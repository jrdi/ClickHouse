-- Tags: no-debug

drop table if exists tab;

create table tab
  (id UInt32, haystack String, needles Array(String))
  engine = MergeTree()
  order by id;

insert into tab values (1, 'hello', ['hel+o', 'w(or)*ld']);
insert into tab values (2, 'world', ['hel+o', 'w(or)*ld']);
insert into tab values (3, 'hellllllllo', ['hel+o', 'w(or)*ld']);
insert into tab values (4, 'wororld', ['hel+o', 'w(or)*ld']);
insert into tab values (5, 'abc', ['hel+o', 'w(or)*ld']);

SELECT '* Vectorscan enabled';

SET allow_hyperscan = 1;

SELECT '- const pattern';
SELECT multiMatchAny(haystack, ['hel+o', 'w(or)*ld']) from tab order by id;
SELECT multiMatchAnyIndex(haystack, ['hel+o', 'w(or)*ld']) from tab order by id;
SELECT multiMatchAllIndices(haystack, ['hel+o', 'w(or)*ld']) from tab order by id;
SELECT multiFuzzyMatchAny(haystack, 0, ['hel+o', 'w(or)*ld']) from tab order by id;
SELECT multiFuzzyMatchAnyIndex(haystack, 0, ['hel+o', 'w(or)*ld']) from tab order by id;
SELECT multiFuzzyMatchAllIndices(haystack, 0, ['hel+o', 'w(or)*ld']) from tab order by id;

SELECT '- non-const pattern';
SELECT multiMatchAny(haystack, needles) from tab order by id;
SELECT multiMatchAnyIndex(haystack, needles) from tab order by id;
SELECT multiMatchAllIndices(haystack, needles) from tab order by id;
SELECT multiFuzzyMatchAny(haystack, 0, needles) from tab order by id;
SELECT multiFuzzyMatchAnyIndex(haystack, 0, needles) from tab order by id;
SELECT multiFuzzyMatchAllIndices(haystack, 0, needles) from tab order by id;

SELECT '* Vectorscan disabled';

SET allow_hyperscan = 0;

SELECT '- const pattern';
SELECT multiMatchAny(haystack, ['hel+o', 'w(or)*ld']) from tab order by id; -- { serverError 446 }
SELECT multiMatchAnyIndex(haystack, ['hel+o', 'w(or)*ld']) from tab order by id; -- { serverError 446 }
SELECT multiMatchAllIndices(haystack, ['hel+o', 'w(or)*ld']) from tab order by id; -- { serverError 446 }
SELECT multiFuzzyMatchAny(haystack, 0, ['hel+o', 'w(or)*ld']) from tab order by id; -- { serverError 446 }
SELECT multiFuzzyMatchAnyIndex(haystack, 0, ['hel+o', 'w(or)*ld']) from tab order by id; -- { serverError 446 }
SELECT multiFuzzyMatchAllIndices(haystack, 0, ['hel+o', 'w(or)*ld']) from tab order by id; -- { serverError 446 }

SELECT '- non-const pattern';
SELECT multiMatchAny(haystack, needles) from tab order by id; -- { serverError 446 }
SELECT multiMatchAnyIndex(haystack, needles) from tab order by id; -- { serverError 446 }
SELECT multiMatchAllIndices(haystack, needles) from tab order by id; -- { serverError 446 }
SELECT multiFuzzyMatchAny(haystack, 0, needles) from tab order by id; -- { serverError 446 }
SELECT multiFuzzyMatchAnyIndex(haystack, 0, needles) from tab order by id; -- { serverError 446 }
SELECT multiFuzzyMatchAllIndices(haystack, 0, needles) from tab order by id; -- { serverError 446 }

drop table if exists tab;
