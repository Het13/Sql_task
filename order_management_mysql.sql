-- order management
-- Q7 - Q10
-- 7
SELECT 
	CARTON.CARTON_ID,
	(CARTON.LEN * CARTON.WIDTH * CARTON.HEIGHT) AS CARTON_VOL
FROM 
	CARTON
WHERE 
	(CARTON.LEN * CARTON.WIDTH * CARTON.HEIGHT) >= (
		SELECT 
			SUM(PRODUCT.LEN * PRODUCT.HEIGHT * PRODUCT.WIDTH * ORDER_ITEMS.PRODUCT_QUANTITY) AS PRODUCT_VOL
		FROM 
			ORDER_ITEMS
		INNER JOIN PRODUCT ON PRODUCT.PRODUCT_ID = ORDER_ITEMS.PRODUCT_ID
		WHERE ORDER_ITEMS.ORDER_ID = 10006
	)
ORDER BY CARTON_VOL LIMIT 1; 


-- 8
SELECT 
	ONLINE_CUSTOMER.CUSTOMER_ID,
	ONLINE_CUSTOMER.CUSTOMER_FNAME || ' '  || ONLINE_CUSTOMER.CUSTOMER_LNAME AS CUSTOMER_NAME,
	ORDER_HEADER.ORDER_ID,
	SUM(ORDER_ITEMS.PRODUCT_QUANTITY) AS TOTAL_ORDER_QTY
FROM 
	ONLINE_CUSTOMER
	INNER JOIN ORDER_HEADER ON ORDER_HEADER.CUSTOMER_ID = ONLINE_CUSTOMER.CUSTOMER_ID
	INNER JOIN ORDER_ITEMS ON ORDER_ITEMS.ORDER_ID = ORDER_HEADER.ORDER_ID
WHERE 
	ORDER_HEADER.ORDER_STATUS = 'Shipped'
GROUP BY
	ONLINE_CUSTOMER.CUSTOMER_ID,
	ORDER_HEADER.ORDER_ID
HAVING 
	SUM(ORDER_ITEMS.PRODUCT_QUANTITY) > 10;


-- 9
SELECT 
	ONLINE_CUSTOMER.CUSTOMER_ID,
	ORDER_HEADER.ORDER_ID,
	ONLINE_CUSTOMER.CUSTOMER_FNAME || ' ' || ONLINE_CUSTOMER.CUSTOMER_LNAME AS CUSTOMER_FULL_NAME,
	SUM(ORDER_ITEMS.PRODUCT_QUANTITY)
FROM
	ONLINE_CUSTOMER
	INNER JOIN ORDER_HEADER ON ORDER_HEADER.CUSTOMER_ID = ONLINE_CUSTOMER.CUSTOMER_ID
	INNER JOIN ORDER_ITEMS ON ORDER_ITEMS.ORDER_ID = ORDER_HEADER.ORDER_ID
WHERE 
	ORDER_HEADER.ORDER_STATUS = 'Shipped'
GROUP BY 
	ORDER_HEADER.ORDER_ID
HAVING
	ORDER_HEADER.ORDER_ID > 10060;
    
    
-- 10
SELECT 
	PRODUCT_CLASS.PRODUCT_CLASS_DESC,
	SUM(ORDER_ITEMS.PRODUCT_QUANTITY) AS TOTAL_QUANTITY,
	SUM(ORDER_ITEMS.PRODUCT_QUANTITY * PRODUCT.PRODUCT_PRICE) AS TOTAL_VALUE 
FROM 
	PRODUCT
	INNER JOIN PRODUCT_CLASS ON PRODUCT_CLASS.PRODUCT_CLASS_CODE = PRODUCT.PRODUCT_CLASS_CODE
	INNER JOIN ORDER_ITEMS ON ORDER_ITEMS.PRODUCT_ID = PRODUCT.PRODUCT_ID
	INNER JOIN ORDER_HEADER ON ORDER_HEADER.ORDER_ID = ORDER_ITEMS.ORDER_ID
	INNER JOIN ONLINE_CUSTOMER ON ONLINE_CUSTOMER.CUSTOMER_ID = ORDER_HEADER.CUSTOMER_ID
	INNER JOIN ADDRESS ON ADDRESS.ADDRESS_ID = ONLINE_CUSTOMER.ADDRESS_ID
WHERE 
	COUNTRY NOT IN ('India','USA')
GROUP BY 
	PRODUCT.PRODUCT_CLASS_CODE
ORDER BY 
	TOTAL_QUANTITY DESC LIMIT 1;
    
    
