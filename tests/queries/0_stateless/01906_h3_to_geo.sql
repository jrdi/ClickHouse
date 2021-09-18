-- Tags: no-unbundled, no-fasttest

DROP TABLE IF EXISTS h3_indexes;

CREATE TABLE h3_indexes (h3_index UInt64) ENGINE = Memory;

-- Random geo coordinates were generated using the H3 tool: https://github.com/ClickHouse-Extras/h3/blob/master/src/apps/testapps/mkRandGeo.c at various resolutions from 0 to 15.
-- Corresponding H3 index values were in turn generated with those geo coordinates using `geoToH3(lon, lat, res)` ClickHouse function for the following test.

INSERT INTO h3_indexes VALUES (579205133326352383);
INSERT INTO h3_indexes VALUES (581263419093549055);
INSERT INTO h3_indexes VALUES (589753847883235327);
INSERT INTO h3_indexes VALUES (594082350283882495);
INSERT INTO h3_indexes VALUES (598372386957426687);
INSERT INTO h3_indexes VALUES (599542359671177215);
INSERT INTO h3_indexes VALUES (604296355086598143);
INSERT INTO h3_indexes VALUES (608785214872748031);
INSERT INTO h3_indexes VALUES (615732192485572607);
INSERT INTO h3_indexes VALUES (617056794467368959);
INSERT INTO h3_indexes VALUES (624586477873168383);
INSERT INTO h3_indexes VALUES (627882919484481535);
INSERT INTO h3_indexes VALUES (634600058503392255);
INSERT INTO h3_indexes VALUES (635544851677385791);
INSERT INTO h3_indexes VALUES (639763125756281263);
INSERT INTO h3_indexes VALUES (644178757620501158);


SELECT h3ToGeo(h3_index) FROM h3_indexes ORDER BY h3_index;

DROP TABLE h3_indexes;

DROP TABLE IF EXISTS h3_geo;

-- compare if the results of h3ToGeo and geoToH3 are the same

CREATE TABLE h3_geo(lat Float64, lon Float64, res UInt8) ENGINE = Memory;

INSERT INTO h3_geo VALUES (-173.6412167681162, -14.130272474941535, 0);
INSERT INTO h3_geo VALUES (59.48137613600854, 58.020407687755686, 1);
INSERT INTO h3_geo VALUES (172.68095885060296, -83.6576608516349, 2);
INSERT INTO h3_geo VALUES (-94.46556851304558, -69.1999982492279, 3);
INSERT INTO h3_geo VALUES (-8.188263637093279, -55.856179102736284, 4);
INSERT INTO h3_geo VALUES (77.25594891852249, 47.39278564360122, 5);
INSERT INTO h3_geo VALUES (135.11348004704536, 36.60778126579667, 6);
INSERT INTO h3_geo VALUES (39.28534828967223, 49.07710003066973, 7);
INSERT INTO h3_geo VALUES (124.71163478198051, -27.481172161567258, 8);
INSERT INTO h3_geo VALUES (-147.4887686066785, 76.73237945824442, 9);
INSERT INTO h3_geo VALUES (86.63291906118863, -25.52526285188784, 10);
INSERT INTO h3_geo VALUES (23.27751790712118, 13.126101362212724, 11);
INSERT INTO h3_geo VALUES (-70.40163237204142, -63.12562536833242, 12);
INSERT INTO h3_geo VALUES (15.642428355535966, 40.285813505163574, 13);
INSERT INTO h3_geo VALUES (-76.53411447979884, 54.5560449693637, 14);
INSERT INTO h3_geo VALUES (8.19906334981474, 67.69370966550179, 15);

SELECT result FROM (
    SELECT
        (lat, lon) AS input_geo,
        h3ToGeo(geoToH3(lat, lon, res)) AS output_geo,
        if(input_geo = output_geo, 'ok', 'fail') AS result
    FROM h3_geo
);

DROP TABLE h3_geo;
