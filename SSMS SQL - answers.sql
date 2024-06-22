CREATE DATABASE MusicStore

USE MusicStore


-- 1. Who is the senior most employee based on the job title?
select TOP 1 first_name,last_name,max(levels) 
from employee
group by first_name,last_name
ORDER BY max(levels) DESC

-- 2. Which countries have the most invoices?
SELECT TOP 1 billing_country,COUNT(billing_country) total_count_invoices
FROM invoice
GROUP BY billing_country
ORDER BY total_count_invoices DESC

-- 3. What are the top 3 values of total invoice?
select top 3 total from invoice
order by total desc

-- 4. Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
SELECT TOP 1 billing_city,SUM(TOTAL) total_sum FROM invoice
GROUP BY billing_city
ORDER BY total_sum DESC

-- 5. Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money.
SELECT TOP 1 customer_id, SUM(TOTAL) total_invoice
FROM invoice
GROUP BY customer_id
ORDER BY total_invoice DESC

-- Question Set 2: Medium
-- 1. Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A

select distinct email,first_name,last_name from customer c
inner join invoice i on c.customer_id=i.customer_id
inner join invoice_line il on i.invoice_id = il.invoice_id
where track_id in (
	select track_id from track t
	inner join genre g on t.genre_id=g.genre_id
	where g.name like 'rock%'
)
order by email

-- Doing above, using the CTE

with abc as(
	select track_id from track t
	inner join genre g on t.genre_id = g.genre_id
	where g.name LIKE 'rock%'
)

select distinct email, first_name,last_name from customer c
inner join invoice i on c.customer_id= i.customer_id
inner join invoice_line il on i.invoice_id=il.invoice_id
where il.track_id IN (select track_id from abc)
order by email




-- from Gemini
WITH RockTracks AS (
  SELECT track_id
  FROM track t
  INNER JOIN genre g ON t.genre_id = g.genre_id
  WHERE g.name LIKE 'rock%'
)
SELECT DISTINCT email, first_name, last_name
FROM customer c
INNER JOIN invoice i ON c.customer_id = i.customer_id
INNER JOIN invoice_line il ON i.invoice_id = il.invoice_id
WHERE il.track_id IN (SELECT track_id FROM RockTracks)
ORDER BY email;



-- 2. Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands

select top 10 ar.name artist_name,count(g.name) no_of_Rock_tracks
from track t
inner join genre g on t.genre_id = g.genre_id
inner join album ab on t.album_id=ab.album_id
inner join artist ar on ab.artist_id=ar.artist_id
where g.name like 'rock%'
group by ar.name
order by no_of_Rock_tracks desc

-- 3. Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first

select name,milliseconds from track
where milliseconds > (select avg(milliseconds) avg_value from track)
order by milliseconds desc



-- Using CTE
with avglength as (
select avg(milliseconds) avg_value from track)

select name,milliseconds from track
where milliseconds > (select avg_value from avglength)
order by milliseconds desc






-- Question Set 3: Advance
-- 1. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent
-- 
select first_name,last_name,ar.name,sum(i.total) total_spent,
	DENSE_RANK() Over (--PARTITION BY first_name,last_name,AR.NAME 
	ORDER BY sum(i.total) DESC) RANKS
from customer c
inner join invoice i on c.customer_id = i.customer_id 
inner join invoice_line il on i.invoice_id=il.invoice_id
inner join track t on il.track_id=t.track_id
inner join album ab on ab.album_id=t.album_id
inner join artist ar on ar.artist_id=ab.artist_id
group by first_name,last_name,ar.name
order by first_name, total_spent desc


-- Using CTE to write this query about the maximum amount spent on the artist.

 










-- Using subquery:

select first_name,last_name,ar.name,i.total total_spent from customer c
inner join invoice i on c.customer_id = i.customer_id 
inner join invoice_line il on i.invoice_id=il.invoice_id
inner join track t on il.track_id=t.track_id
inner join album ab on ab.album_id=t.album_id
inner join artist ar on ar.artist_id=ab.artist_id






select customer_id,sum(total) total_spent from invoice
group by customer_id
order by total_spent desc















-- 2. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres.

with populargenre as 
(
select country,g.name , total from customer c
inner join invoice i on c.customer_id=i.customer_id
inner join invoice_line il on il.invoice_id = i.invoice_id
inner join track t on t.track_id = il.track_id
inner join genre g on g.genre_id = t.genre_id
)

select * from populargenre


group by country,g.name
order by total_purchase_amount desc,country,g.name






with genretracks as
(
	select g.name from track t
	inner join genre g on t.track_id=g.genre_id
)

select billing_country, sum(distinct total) total_bill from invoice i
inner join invoice_line il on i.invoice_id=il.invoice_id

group by billing_country
order by total_bill desc

select customer_id,sum(total) totall from invoice
group by customer_id
order by totall desc













