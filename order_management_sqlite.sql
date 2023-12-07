-- Order Management
-- Q1 - Q6

-- Q1 
-- Write a query to Display the product details (product_class_code, product_id, product_desc, product_price,) 
-- as per the following criteria and sort them in descending order of category: 
-- a. If the category is 2050, increase the price by 2000 
-- b. If the category is 2051, increase the price by 500 
-- c. If the category is 2052, increase the price by 600. 
-- Hint: Use case statement. no permanent change in table required. (60 ROWS) [NOTE: PRODUCT TABLE]

SELECT 
	PRODUCT_CLASS_CODE, 
	PRODUCT_ID, 
	PRODUCT_DESC,
	CASE PRODUCT_CLASS_CODE
		WHEN 2050
			THEN PRODUCT_PRICE + 2000
		WHEN 2051
			THEN PRODUCT_PRICE + 500
		WHEN 2052
			THEN PRODUCT_PRICE + 600
		ELSE
			PRODUCT_PRICE
		END PRODUCT_PRICE
FROM PRODUCT 
ORDER BY PRODUCT_CLASS_CODE DESC;



-- Q2
-- Write a query to display (product_class_desc, product_id, product_desc, product_quantity_avail ) and 
-- Show inventory status of products as below as per their available quantity: 
-- a. For Electronics and Computer categories, if available quantity is <= 10, show 'Low stock', 11 <= qty <= 30, show 'In stock', >= 31, show 'Enough stock' 
-- b. For Stationery and Clothes categories, if qty <= 20, show 'Low stock', 21 <= qty <= 80, show 'In stock', >= 81, show 'Enough stock' 
-- c. Rest of the categories, if qty <= 15 – 'Low Stock', 16 <= qty <= 50 – 'In Stock', >= 51 – 'Enough stock' 
-- l categories, if available quantity is 0, show 'Out of stock'. 
-- Hint: Use case statement. (60 ROWS) [NOTE: TABLES TO BE USED – product, product_class]

SELECT 
	PRODUCT_CLASS_DESC, 
	PRODUCT_ID, 
	PRODUCT_DESC, 
	PRODUCT_QUANTITY_AVAIL,
	CASE 
		WHEN PRODUCT_QUANTITY_AVAIL = 0 THEN 'OUT OF STOCK'
	ELSE
		CASE PRODUCT_CLASS_DESC
			WHEN 'Electronics' OR 'Computer' THEN 
				CASE 
					WHEN PRODUCT_QUANTITY_AVAIL <=10 THEN 'LOW STOCK'
					WHEN PRODUCT_QUANTITY_AVAIL >=11 AND PRODUCT_QUANTITY_AVAIL <= 30 THEN 'IN STOCK'
					WHEN PRODUCT_QUANTITY_AVAIL >= 31 THEN 'ENOUGH STOCK'
					END
			WHEN 'Stationery' OR 'Clothes' THEN 
				CASE 
					WHEN PRODUCT_QUANTITY_AVAIL < 20 THEN 'LOW STOCK'
					WHEN PRODUCT_QUANTITY_AVAIL >= 21 AND PRODUCT_QUANTITY_AVAIL <= 80 THEN 'IN STOCK'
					WHEN PRODUCT_QUANTITY_AVAIL >= 81 THEN 'ENOUGH STOCK'
					END 
			ELSE 
				CASE
					WHEN PRODUCT_QUANTITY_AVAIL <= 15 THEN 'LOW STOCK'
					WHEN PRODUCT_QUANTITY_AVAIL >= 16 AND PRODUCT_QUANTITY_AVAIL <= 50 THEN 'IN STOCK'
					WHEN PRODUCT_QUANTITY_AVAIL >= 51 THEN 'ENOUGH STOCK'
					END
			END
	END INVENTORY_STATUS
FROM PRODUCT 
	INNER JOIN PRODUCT_CLASS ON PRODUCT_CLASS.PRODUCT_CLASS_CODE = PRODUCT.PRODUCT_CLASS_CODE ;
	

-- 3
-- Write a query to Show the count of cities in all countries other than USA & MALAYSIA, with more than 1 city, 
-- in the descending order of CITIES. (2 rows) [NOTE: ADDRESS TABLE, Do not use Distinct]

SELECT 
	COUNTRY,
	COUNT(CITY) AS CITY_COUNT
FROM ADDRESS 
GROUP BY COUNTRY 
HAVING 
	COUNTRY NOT IN ('USA','Malaysia') AND 
	COUNT(CITY) > 1;

	

-- 4
-- Write a query to display the customer_id,customer full name ,city,pincode,and order details 
-- (order id, product class desc, product desc, subtotal(product_quantity * product_price)) 
-- for orders shipped to cities whose pin codes do not have any 0s in them. Sort the output on customer name and subtotal. 
-- (52 ROWS) [NOTE: TABLE TO BE USED - online_customer, address, order_header, order_items, product, product_class]

SELECT 
	ONLINE_CUSTOMER.CUSTOMER_ID, 
	ONLINE_CUSTOMER.CUSTOMER_FNAME || ' ' || ONLINE_CUSTOMER.CUSTOMER_LNAME AS CUSTOMER_NAME,
	ADDRESS.CITY, 
	CAST(ADDRESS.PINCODE AS TEXT) AS PINCODE,
	ORDER_ITEMS.ORDER_ID,
	PRODUCT_CLASS.PRODUCT_CLASS_DESC,
	PRODUCT.PRODUCT_DESC,
	ORDER_ITEMS.PRODUCT_QUANTITY * PRODUCT.PRODUCT_PRICE AS SUBTOTAL
FROM
	ONLINE_CUSTOMER
	INNER JOIN ADDRESS ON ONLINE_CUSTOMER.ADDRESS_ID = ADDRESS.ADDRESS_ID
	INNER JOIN ORDER_HEADER ON ONLINE_CUSTOMER.CUSTOMER_ID = ORDER_HEADER.CUSTOMER_ID
	INNER JOIN ORDER_ITEMS ON ORDER_HEADER.ORDER_ID = ORDER_ITEMS.ORDER_ID
	INNER JOIN PRODUCT ON ORDER_ITEMS.PRODUCT_ID = PRODUCT.PRODUCT_ID
	INNER JOIN PRODUCT_CLASS ON PRODUCT.PRODUCT_CLASS_CODE = PRODUCT_CLASS.PRODUCT_CLASS_CODE
WHERE 
	PINCODE NOT LIKE '%0%' AND ORDER_HEADER.ORDER_STATUS = 'Shipped'
ORDER BY
	CUSTOMER_NAME, SUBTOTAL;


	
-- 5	
-- Write a Query to display product id,product description,totalquantity(sum(product quantity) for an item 
-- which has been bought maximum no. of times (Quantity Wise) along with product id 201. 
-- (USE SUB-QUERY) (1 ROW) [NOTE: ORDER_ITEMS TABLE, PRODUCT TABLE]

SELECT	
	PRODUCT.PRODUCT_ID,
	PRODUCT.PRODUCT_DESC,
	(
		SELECT SUM(ORDER_ITEMS.PRODUCT_QUANTITY) 
		FROM ORDER_ITEMS 
		WHERE 
			ORDER_ITEMS.ORDER_ID IN (
				SELECT ORDER_ID 
				FROM ORDER_ITEMS
				WHERE PRODUCT_ID = 201
			) 
			AND PRODUCT.PRODUCT_ID = ORDER_ITEMS.PRODUCT_ID 
		GROUP BY ORDER_ITEMS.PRODUCT_ID
	) AS TOTAL_QUANTITY
FROM 
	PRODUCT
ORDER BY TOTAL_QUANTITY DESC
LIMIT 1;



-- 6
-- Write a query to display the customer_id,customer name, email and order details 
-- (order id, product desc,product qty, subtotal(product_quantity * product_price)) 
-- for all customers even if they have not ordered any item.(225 ROWS) 
-- [NOTE: TABLE TO BE USED - online_customer, order_header, order_items, product]

SELECT 
	ONLINE_CUSTOMER.CUSTOMER_ID,
	ONLINE_CUSTOMER.CUSTOMER_FNAME || ' '  || ONLINE_CUSTOMER.CUSTOMER_LNAME AS CUSTOMER_NAME,
	ONLINE_CUSTOMER.CUSTOMER_EMAIL,
	ORDER_HEADER.ORDER_ID,
	PRODUCT.PRODUCT_DESC,
	ORDER_ITEMS.PRODUCT_QUANTITY,
	ORDER_ITEMS.PRODUCT_QUANTITY * PRODUCT.PRODUCT_PRICE AS SUBTOTAL
FROM 
	ONLINE_CUSTOMER
	LEFT JOIN ORDER_HEADER ON ONLINE_CUSTOMER.CUSTOMER_ID = ORDER_HEADER.CUSTOMER_ID
	LEFT JOIN ORDER_ITEMS ON ORDER_HEADER.ORDER_ID = ORDER_ITEMS.ORDER_ID
	LEFT JOIN PRODUCT ON PRODUCT.PRODUCT_ID = ORDER_ITEMS.PRODUCT_ID;


	