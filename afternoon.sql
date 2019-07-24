-- PRACTICE JOINS 
SELECT i
FROM invoice i JOIN invoice_line il ON il.invoice_id = i.invoice_id
WHERE il.unit_price > 0.99;

SELECT i.invoice_date, c.first_name, c.last_name, i.total
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id;

SELECT c.first_name, c.last_name, e.first_name, e.last_name
FROM customer c
JOIN employee e ON e.employee_id = c.support_rep_id;

SELECT al.title, art.name
FROM album al
JOIN artist art ON art.artist_id = al.artist_id;

SELECT pt.track_id
FROM playlist_track pt
JOIN playlist pl ON pl.playlist_id = pt.playlist_id
WHERE pl.name = 'Music';

SELECT t.name
FROM track t
JOIN playlist_track pl ON pl.track_id = t.track_id
WHERE pl.playlist_id = 5;

SELECT t.name, pl.name
FROM track t
JOIN playlist_track pt ON pt.track_id = t.track_id
JOIN playlist pl ON pt.playlist_id = pl.playlist_id;

SELECT t.name, a.title
FROM track t
JOIN album a ON a.album_id = t.album_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Alternative & Punk';

SELECT t.name, g.name, al.title, art.name
FROM track t
JOIN playlist_track pt ON pt.track_id = t.track_id
JOIN playlist pl ON pt.playlist_id = pl.playlist_id
JOIN genre g ON t.genre_id = g.genre_id
JOIN album al ON t.album_id = al.album_id
JOIN artist art ON al.artist_id = art.artist_id
WHERE pl.name = 'Music';

-- NESTED QUERIES
SELECT *
FROM invoice
WHERE invoice_id IN ( 
  SELECT invoice_id FROM invoice_line WHERE unit_price > 0.99
);

SELECT *
FROM playlist_track
WHERE playlist_id IN (
	SELECT playlist_id FROM playlist WHERE name = 'Music'
);

SELECT name
FROM track
WHERE track_id IN (
	SELECT track_id FROM playlist_track WHERE playlist_id = 5
);

SELECT *
FROM track
WHERE genre_id IN (
	SELECT genre_id FROM genre WHERE name = 'Comedy'
);

SELECT *
FROM track
WHERE album_id IN (
	SELECT album_id FROM album WHERE title = 'Fireball'
);

SELECT *
FROM track
WHERE album_id IN (
	SELECT album_id FROM album WHERE artist_id IN (
  	SELECT artist_id FROM artist WHERE name = 'Queen'
  )
);

-- UPDATING ROWS
UPDATE customer
SET fax = null
WHERE fax IS NOT NULL;

UPDATE customer
SET company = 'Self'
WHERE company IS NULL;

UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett';

UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';

UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id IN (
	SELECT genre_id FROM genre WHERE name = 'Metal'
) AND composer IS NULL;

-- GROUP BY
SELECT g.name, COUNT(*)
FROM genre g
JOIN track t ON g.genre_id = t.genre_id
GROUP BY g.name;

SELECT g.name, count(*)
FROM genre g
JOIN track t ON t.genre_id = g.genre_id
WHERE g.name IN ('Pop', 'Rock')
GROUP BY g.name;

SELECT art.name, COUNT(*)
FROM artist art
JOIN album al ON al.artist_id = art.artist_id
GROUP BY art.name;

-- DISTINCT
SELECT DISTINCT composer
FROM track;

SELECT DISTINCT billing_postal_code
FROM invoice;

SELECT DISTINCT company
FROM customer;
