# 1. Creating a Strored Function #
USE album;
DROP FUNCTION IF EXISTS track_len;

DELIMITER //
CREATE FUNCTION track_len(seconds INT)
RETURNS VARCHAR(16)
DETERMINISTIC
BEGIN
	RETURN CONCAT_WS(':', seconds DIV 60, LPAD(seconds MOD 60, 2, '0'));
END //
DELIMITER ;

SELECT 
    Title, duration AS Secs, TRACK_LEN(duration) AS Len
FROM
    track
ORDER BY duration DESC;
-- #--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--# --

SELECT 
    a.artist AS Artist,
    a.title AS Album,
    t.title AS Track,
    t.track_number AS TrackNo,
    TRACK_LEN(t.duration) AS Length
FROM
    track AS t
        JOIN
    album AS a ON a.id = t.album_id
ORDER BY 1 , 2 , 4;
-- #--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--# --

SELECT 
    a.artist AS Artist,
    a.title AS Album,
    TRACK_LEN(SUM(duration)) AS Length
FROM
    track AS t
        JOIN
    album AS a ON a.id = t.album_id
GROUP BY a.id
ORDER BY 1 , 2;
-- #--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--# --

SHOW FUNCTION STATUS WHERE DEFINER LIKE 'admin%';
# DROP FUNCTION IF EXISTS track_len; #

# 2. Creating a Strored Procedure #
USE album;
DROP PROCEDURE IF EXISTS list_albums;

DELIMITER //
CREATE PROCEDURE list_albums()
BEGIN
SELECT * FROM album;
SELECT * FROM track;
END //
DELIMITER ;

CALL list_albums;


DROP procedure IF EXISTS list_albums;
DELIMITER //
CREATE PROCEDURE list_albums (Param VARCHAR(255))
BEGIN
SELECT a.artist AS Artist,
a.title AS Album,
t.title AS Track,
t.track_number AS TrackNo,
track_len(t.duration) AS Length
FROM track As t
JOIN album As a
ON a.id = t.album_id
WHERE a.artist LIKE Param
ORDER BY 1, 2, 4;
END //
DELIMITER ;

CALL list_albums('%hendrix%');

-- With Output Parameter --
DROP PROCEDURE IF EXISTS total_duration;
DELIMITER //
CREATE PROCEDURE total_duration (param VARCHAR(255), OUT outp VARCHAR(255))	
BEGIN
SELECT track_len(SUM(duration)) INTO outp
FROM track
WHERE album_id IN (SELECT id FROM album WHERE artist LIKE param);
END //
DELIMITER ;

CALL total_duration ('%hendrix%', @dur);
SELECT @dur;

SHOW FUNCTION STATUS WHERE DEFINER LIKE 'admin%';
SHOW PROCEDURE STATUS WHERE DEFINER LIKE 'admin%';

DROP FUNCTION IF EXISTS track_len;
DROP PROCEDURE IF EXISTS total_duration;
-- #--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--# --

# 3. Language Extensions #
USE scratch;
DROP PROCEDURE IF EXISTS str_count;
-- STR_COUNT()/ count 1 to 5/ concatenate in string --

DELIMITER //
CREATE PROCEDURE str_count ()
BEGIN
DECLARE max_value INT UNSIGNED DEFAULT 5;
DECLARE int_value INT UNSIGNED DEFAULT 0;
DECLARE str_value VARCHAR(255) DEFAULT '';

WHILE int_value < max_value DO
SET int_value = int_value + 1;
SET str_value = CONCAT(str_value, int_value, ' ');
END WHILE;
SELECT str_value;
END //
DELIMITER ;

CALL str_count ();

DROP PROCEDURE IF EXISTS str_count;
-- #--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--# --