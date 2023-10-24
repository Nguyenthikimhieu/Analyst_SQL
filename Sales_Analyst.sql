-- Liệt kê tất cả các quản lý (Managers) và thông tin liên quan của họ:
SELECT * FROM Managers

-- Đếm số lượng đơn hàng bị trả lại (Returned) trong toàn bộ dữ liệu:
SELECT COUNT(*) AS Total_Returned_Orders FROM Returns

-- Tính tổng lợi nhuận (Profit) từ tất cả các đơn hàng:
SELECT SUM(profit) AS Total_Profit FROM Orders

--  Liệt kê tất cả các quản lý (Managers) và số lượng đơn hàng (Orders) mà họ đã xử lý:
SELECT m.manager_name, COUNT(o.order_id) AS Total_Orders from Orders o
LEFT JOIN Profiles p ON o.region = p.region
LEFT JOIN Managers m ON p.manager = m.manager_name 
GROUP BY m.manager_name

-- Tìm quản lý (Manager) có nhiều đơn hàng (Orders) nhất:
SELECT top 1 m.manager_name, COUNT(o.order_id) AS Total_Orders
FROM Managers m
LEFT JOIN Profiles p ON m.manager_name = p.manager
LEFT JOIN Orders o ON p.region = o.region
GROUP BY m.manager_name
ORDER BY Total_Orders DESC

-- Tính tổng lợi nhuận (Profit) theo từng khu vực (Region):
SELECT p.region, SUM(o.profit) AS Total_Profit
FROM Profiles p
LEFT JOIN Orders o ON p.region = o.region
GROUP BY p.region

--Tính lợi nhuận trung bình (Average Profit) từ đơn hàng (Orders) có giá trị (Value) lớn hơn một ngưỡng cụ thể:
SELECT AVG(profit) AS Average_Profit
FROM Orders
WHERE value > 1000; -- Điều kiện ngưỡng cụ thể

-- Liệt kê tất cả các quản lý (Managers) và số lượng đơn hàng bị trả lại (Returned) mà họ đã xử lý:
SELECT m.manager_name, COUNT(r.order_id) AS Total_Returned_Orders
FROM Managers m
LEFT JOIN Profiles p ON p.manager = m.manager_name 
LEFT JOIN Orders o ON p.region = o.region
LEFT JOIN Returns r ON r.order_id =o.order_id
GROUP BY m.manager_name

--  Tính tỷ lệ đơn hàng bị trả lại (Return) trên tổng số đơn hàng (Orders) cho từng khu vực (Region):
SELECT p.region, 
       COUNT(r.order_id) AS Total_Returned_Orders,
       COUNT(o.order_id) AS Total_Orders,
       ROUND(CAST(COUNT(r.order_id) AS DECIMAL) / CAST(COUNT(o.order_id) AS DECIMAL) * 100, 2) AS Return_Rate,
	   CASE 
           WHEN COUNT(o.order_id) > 0 THEN ROUND(CAST(COUNT(r.order_id) AS DECIMAL) / CAST(COUNT(o.order_id) AS DECIMAL) * 100, 2)
           ELSE 0.0  -- Tránh trường hợp chia cho 0
       END AS Return_Rate
FROM Profiles p
LEFT JOIN Orders o ON p.region = o.region
LEFT JOIN Returns r ON r.order_id =o.order_id
GROUP BY p.region

-- Tìm sản phẩm (Product) có lợi nhuận (Profit) cao nhất và thấp nhất trong từng danh mục sản phẩm (Product Category):
SELECT product_category, 
       product_name ,
       MAX(profit) AS Max_Profit
FROM Orders
GROUP BY product_category,  product_name
HAVING MAX(profit) = (SELECT MAX(profit) FROM Orders WHERE product_category = Orders.product_category)

--
SELECT product_category, 
       product_name ,
       MIN(profit) AS Min_Profit
FROM Orders
GROUP BY product_category, product_name 
HAVING MIN(profit) = (SELECT MIN(profit) FROM Orders WHERE product_category = Orders.product_category)

-- Tính tổng giá trị đơn hàng (Value) theo từng tỉnh (Province):
SELECT province, SUM(value) AS Total_Value
FROM Orders
GROUP BY province

-- SELECT EXTRACT(MONTH FROM order_date) AS Month,
WITH Date_  AS ( 
	SELECT  Month( order_date) AS MONTH_,
       year(order_date ) AS YEAR_,
	   order_id
	FROM Orders) 
select * from Date_
SELECT MONTH, YEAR,
       COUNT(order_id) AS Total_Orders
FROM Date_
LEFT JOIN Orders ON Orders.order_id = Date_.order_id
GROUP BY  MONTH_, YEAR_
ORDER BY Total_Orders DESC

-- Tính tổng số đơn hàng (Orders) cho từng phân đoạn khách hàng (Customer Segment):
SELECT customer_segment, COUNT(order_id) AS Total_Orders
FROM Orders
GROUP BY customer_segment

--Tính tỷ lệ đơn hàng bị trả lại (Return) theo từng phân đoạn khách hàng (Customer Segment):
SELECT customer_segment, 
       COUNT(r.order_id) AS Total_Returned_Orders,
       COUNT(o.order_id) AS Total_Orders,
       ROUND(CAST(COUNT(r.order_id) AS DECIMAL) / CAST(COUNT(o.order_id) AS DECIMAL) * 100, 2) AS Return_Rate
FROM Orders o
LEFT JOIN Returns   r ON r.order_id = o.order_id
GROUP BY customer_segment


-- Tính chi phí vận chuyển trung bình cho từng phương thức vận chuyển:
SELECT shipping_mode, AVG(shipping_cost) AS Average_Shipping_Cost
FROM Orders
GROUP BY shipping_mode

--Tìm sản phẩm (Product) có tổng doanh số cao nhất theo từng vùng (Region):
SELECT region, product_name , MAX(profit) AS Highest_Sales
FROM Orders
GROUP BY region, product_name
HAVING MAX(profit)     = (SELECT MAX(profit)    FROM Orders WHERE region = Orders.region)
select * from orders

-- Tính tổng lợi nhuận cho mỗi người quản lý (Manager):
SELECT m.manager_name, SUM(o.profit) AS Total_Profit
FROM Managers m
LEFT JOIN Profiles p ON p.manager = m.manager_name 
LEFT JOIN Orders o ON p.region = o.region
LEFT JOIN Returns r ON r.order_id =o.order_id
GROUP BY m.manager_name

--Tìm tỉnh (Province) có tổng lợi nhuận cao nhất
SELECT  Top 1   province, SUM(profit) AS Total_Profit
FROM Orders
GROUP BY province
ORDER BY Total_Profit DESC

-- Tìm người quản lý (Người quản lý) có tổng doanh thu cao nhất cho một danh mục sản phẩm cụ thể (Danh mục sản phẩm)
SELECT      p.manager, m.manager_name, product_category, SUM(profit)    AS Total_Sales
FROM Managers m
LEFT JOIN Profiles p ON m.manager_id = p.manager
LEFT JOIN Orders o ON p.region = o.region
WHERE o.product_category = 'Electronics'  -- Replace with the desired product category
GROUP BY p.manager, m.manager_name, product_category
ORDER BY Total_Sales DESC
