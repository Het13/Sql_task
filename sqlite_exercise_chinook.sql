-- Exercise 1
-- Using the chinook database, write SQLite queries to answer the following questions in DB Browser. 

-- Q.1 What is the title of the album with AlbumId 67? 

SELECT 
	TITLE 
FROM 
	albums 
WHERE 
	AlbumId = 67;


-- Q.2 Find the name and length (in seconds) of all tracks that have length between 50 and 70 seconds. 

SELECT 
	NAME, 
	Milliseconds / 1000 AS SECONDS
FROM 
	tracks
WHERE 
	SECONDS BETWEEN 50 AND 70;



-- Q.3 List all the albums by artists with the word ‘black’ in their name. 

SELECT 
	albums.TITLE AS ALBUM_TITLE
FROM 
	albums
	INNER JOIN artists ON albums.ArtistId = artists.ArtistId
WHERE
	NAME LIKE '%black%';


-- Q.4 Provide a query showing a unique/distinct list of billing countries from the Invoice table 

SELECT 
	DISTINCT(BillingCountry) AS BillingCountry
FROM
	invoices;


-- Q.5 Display the city with highest sum total invoice. 

SELECT 
	BillingCity
FROM
	invoices
group by 
	BillingCity
order by 
	sum(total) desc 
limit 1;


-- Q.6 Produce a table that lists each country and the number of customers in that country. 
-- (You only need to include countries that have customers) in descending order. (Highest count at the top) 

select  
	Country,
	count(country) as Num_of_Customers
from
	customers
group by country
order by Num_of_Customers desc;


-- Q.7 Find the top five customers in terms of sales i.e. find the five customers whose total combined 
-- invoice amounts are the highest. Give their name, CustomerId and total invoice amount. Use join 

select  
	customers.FirstName || ' ' || customers.LastName as name,
	customers.CustomerId,
	sum(invoices.total) AS Invoice_Total
from
	customers
	inner join invoices on invoices.CustomerId = customers.CustomerId
group by 
	customers.CustomerId
order by 
	Invoice_Total DESC 
limit 5;



-- Q.8 Find out state wise count of customerID and list the names of states with count of customerID in decreasing order. 
-- Note:- do not include where states is null value. 

select 
	state,
	count(state) as CustomerCount
from 
	customers
where 
	state is not NULL
group by 
	state
order by
	CustomerCount desc;



-- Q.9 How many Invoices were there in 2009 and 2011? 

select
	count(InvoiceDate) as InvoiceCount
from 
	invoices
where 
	strftime("%Y",InvoiceDate) = '2009' 
	or strftime("%Y", InvoiceDate) = '2011';


-- Q.10 Provide a query showing only the Employees who are Sales Agents. 

select
	FirstName || ' ' || LastName AS Name
from 
	employees
where 
	title = 'Sales Agents';



-- Exercise 2
-- Using the chinook database, write SQLite queries to answer the following questions in DB Browser.

-- Q.1 Display Most used media types: their names and count in descending order. 

select 
	media_types.Name,
	count(media_types.Name) as UsageCount
from 
	media_types
	inner join tracks on tracks.MediaTypeId = media_types.MediaTypeId
group by
	media_types.Name
order by 
	UsageCount desc;



-- Q.2 Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show 
-- the customer's full name, Invoice ID, Date of the invoice and billing country.

select 
	customers.FirstName || ' ' || customers.LastName as FullName, 
	invoices.InvoiceId,
	invoices.InvoiceDate,
	invoices.BillingCountry
from 
	customers
	inner join invoices on invoices.CustomerId = customers.CustomerId
where 
	customers.Country = 'Brazil';
	


 
-- Q.3 Display artist name and total track count of the top 10 rock bands from dataset.

select 
	tracks.Composer,
	count(tracks.composer) TrackCount
from 
	invoice_items
	inner join tracks on tracks.TrackId = invoice_items.TrackId
	inner join genres on genres.GenreId = tracks.GenreId
where 
	tracks.Composer is not NULL
	and genres.Name = 'Rock'
group by 
	tracks.Composer
order by 
	sum(invoice_items.UnitPrice * invoice_items.Quantity) desc 
limit 10;
 
 

 
-- Q.4 Display the Best customer (in case of amount spent). Full name (first name and last name) 

select 
	customers.FirstName || ' ' || customers.LastName as Best_Customer
from 
	invoices
	inner join customers on customers.CustomerId = invoices.CustomerId
group by 
	invoices.CustomerId
order by 
	sum(invoices.total) desc 
limit 1;


-- Q.5 Provide a query showing Customers (just their full names, customer ID and country) who are not in the US. 

select 
	FirstName || ' ' || LastName as Full_Name,
	CustomerId,
	Country
from 
	customers
where 
	Country != 'USA';



-- Q.6 Provide a query that shows the total number of tracks in each playlist in descending order. The Playlist 
-- name should be included on the resultant table.

select 
	playlists.Name,
	count(playlist_track.TrackId) as Num_of_Tracks
from 
	playlist_track
	inner join playlists on playlists.PlaylistId = playlist_track.PlaylistId
group by 
	playlist_track.PlaylistId
order by 
	Num_of_Tracks desc;


 
-- Q.7 Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre. 

select 
	albums.Title as Album_name,
	media_types.Name as Media_type,
	genres.Name as Genre_type
from 
	tracks
	inner join albums on albums.AlbumId = tracks.AlbumId
	inner join media_types on media_types.MediaTypeId = tracks.MediaTypeId
	inner join genres on genres.GenreId = tracks.GenreId;
	


-- Q.8 Provide a query that shows the top 10 bestselling artists. (In terms of earning). 

select 
	tracks.Composer as Bestselling_Artists
from 
	invoice_items
	inner join tracks on tracks.TrackId = invoice_items.TrackId
where 
	tracks.Composer is not NULL
group by 
	tracks.Composer
order by 
	sum(invoice_items.UnitPrice * invoice_items.Quantity) desc 
limit 10;



-- Q.9 Provide a query that shows the most purchased Media Type. 

select 
	media_types.Name as Most_Purchased_Media_Type
from 
	media_types
	inner join tracks on tracks.MediaTypeId = media_types.MediaTypeId
	inner join invoice_items on invoice_items.TrackId = tracks.TrackId
group by 
	media_types.Name
order by 
	sum(invoice_items.UnitPrice * invoice_items.Quantity) desc 
limit 1;



-- Q.10 Provide a query that shows the purchased tracks of 2013. Display Track name and Units sold. 

select 
	tracks.Name,
	sum(invoice_items.quantity) as Units_Sold
from 
	invoices
	inner join invoice_items on invoice_items.InvoiceId = invoices.InvoiceId
	inner join tracks on tracks.TrackId = invoice_items.TrackId
where 
	strftime("%Y",InvoiceDate) = '2013'
group by 
	invoice_items.TrackId;

