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

SELECT g.name, COUNT(*)
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

-- DELETE ROWS
DELETE FROM practice_delete
WHERE type = 'bronze';

DELETE FROM practice_delete
WHERE type = 'silver';

DELETE FROM practice_delete
WHERE value = 150;

-- eCommerce Simulation
CREATE TABLE orders(
	order_id SERIAL,
  user_id SERIAL,
  product_id SERIAL
);

CREATE TABLE product(
	product_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  price FLOAT NOT NULL
);

CREATE TABLE users(
	user_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email TEXT NOT NULL
);

INSERT INTO users (name, email)
VALUES ('Bob', 'bob@gmail.com'),
       ('Bill', 'bill@gmail.com'),
       ('Joe', 'joe@gmail.com');


INSERT INTO product (name, price)
VALUES  ('Pizza', 4.20),
        ('Fries', 1.69),
        ('Drink', 1.25);

INSERT INTO orders (order_id, user_id, product_id)
VALUES (1, 1, 1),
			 (1, 1, 3),
       (2, 2, 2),
       (3, 3, 3),
       (3, 3, 2),
       (4, 1, 1)
       ;

ALTER TABLE orders
ADD FOREIGN KEY (product_id) REFERENCES product (product_id);

SELECT p.name
FROM orders o
JOIN product p ON o.product_id = p.product_id
WHERE o.order_id = 1;

SELECT *
FROM orders;

SELECT o.order_id, SUM(p.price) AS total_price
FROM orders o
JOIN product p ON o.product_id = p.product_id
GROUP BY o.order_id;

ALTER TABLE orders
ADD FOREIGN KEY (user_id) REFERENCES users (user_id);

SELECT *
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE u.user_id = 1;

SELECT u.user_id, COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN users u ON o.user_id = u.user_id
GROUP BY u.user_id;

SELECT u.user_id, SUM(p.price)
FROM orders o
JOIN product p ON o.product_id = p.product_id
JOIN users u ON o.user_id = u.user_id
GROUP BY u.user_id;

