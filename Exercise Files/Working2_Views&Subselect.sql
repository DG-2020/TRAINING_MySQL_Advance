-- 1. Creating a Sub Select --
USE world;
DROP TABLE IF EXISTS t;
CREATE TABLE t(a TEXT, b TEXT); -- 'a' column state codes & 'b' column country codes --
INSERT INTO t VALUES ('NY0123', 'US4567');
INSERT INTO t VALUES ('AZ9437', 'GB1234');
INSERT INTO t VALUES ('CA1279', 'FR5678');
SELECT * FROM t;

SELECT SUBSTR(a, 1, 2) AS State, SUBSTR(a, 3) AS SCode,
SUBSTR(b, 1, 2) AS Country, SUBSTR(b, 3) AS CCode FROM t;

## ss = Sub Select ##
SELECT ss.Country, ss.CCode FROM (
SELECT SUBSTR(a, 1, 2) AS State, SUBSTR(a, 3) AS SCode,
SUBSTR(b, 1, 2) AS Country, SUBSTR(b, 3) AS CCode FROM t
) AS ss; 

## Using JOIN ##
SELECT co.Name, ss.Country, ss.CCode FROM (
SELECT SUBSTR(a, 1, 2) AS State, SUBSTR(a, 3) AS SCode,
SUBSTR(b, 1, 2) AS Country, SUBSTR(b, 3) AS CCode FROM t
) AS ss
JOIN Country AS co ON co.Code2 = ss.Country;

DROP TABLE t;


-- 2. Searching within a result set -- 
USE album;
SELECT DISTINCT album_id FROM track WHERE duration <= 90;

SELECT * FROM album
WHERE id IN(SELECT DISTINCT album_id FROM track WHERE duration <= 90);

SELECT a.title AS Album, a.artist AS Artist, t.track_number AS Seq, t.title AS Title, t.duration AS Secs
FROM album AS a
JOIN track AS t
ON t.album_id = a.id
WHERE a.id IN(SELECT DISTINCT album_id FROM track WHERE duration <= 90)
ORDER BY 1, 3;  

## Using Sub-Select instead of Track Table ##
SELECT a.title AS Album, a.artist AS Artist, t.track_number AS Seq, t.title AS Title, t.duration AS Secs
FROM album AS a
JOIN (SELECT DISTINCT album_id, track_number, duration, title FROM track WHERE duration <= 90) AS t
ON t.album_id = a.id
ORDER BY 1, 3;


-- 3. Creating a View -- 
USE album;
SELECT ID, Album_ID, Title, Track_Number, Duration DIV 60 AS Min, Duration MOD 60 AS Sec FROM track;

## Save the query as View ##
CREATE VIEW TrackView AS
SELECT ID, Album_ID, Title, Track_Number, Duration DIV 60 AS Min, Duration MOD 60 AS Sec FROM track;

SELECT * FROM TrackView;

SELECT a.title AS Album, a.artist AS Artist, t.track_number AS Seq, t.title AS Title, t.Min, t.Sec
FROM album AS a
JOIN TrackView AS t
ON t.album_id = a.id
ORDER BY 1, 3;

## Concatenate Mins & Secs ##
SELECT a.title AS Album, a.artist AS Artist, t.track_number AS Seq, t.title AS Title,
CONCAT(t.Min, ':', SUBSTR(CONCAT('00', t.Sec), -2, 2)) AS Duration
FROM album AS a
JOIN TrackView AS t
ON t.album_id = a.id
ORDER BY 1, 3;


-- 4. Creating a Joined View --
USE album;

SELECT a.artist AS Artist, a.title AS Album, t.title AS Track, t.track_number AS TrackNo, 
t.duration DIV 60 AS Min, t.duration MOD 60 AS Sec
FROM track AS t 
JOIN album AS a
on a.id = t.album_id
ORDER BY 1, 4; 

## Save a query as VIEW ##
CREATE VIEW JoinedAlbum AS
SELECT a.artist AS Artist, a.title AS Album, t.title AS Track, t.track_number AS TrackNo, 
t.duration DIV 60 AS Min, t.duration MOD 60 AS Sec
FROM track AS t 
JOIN album AS a
on a.id = t.album_id
ORDER BY 1, 4;

SELECT * FROM JoinedAlbum WHERE artist = 'Jimi Hendrix';

SELECT Artist, Album, Track, TrackNo,
CONCAT(Min, ':', SUBSTR(CONCAT('00', Sec), -2, 2)) AS Duration
FROM JoinedAlbum;

DROP VIEW IF EXISTS JoinedAlbum;
 
