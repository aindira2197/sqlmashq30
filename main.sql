CREATE TABLE IF NOT EXISTS TaxRates (
    region VARCHAR(50) PRIMARY KEY,
    tax_percentage DECIMAL(5,2)
);

INSERT INTO TaxRates VALUES ('Toshkent', 12.00), ('Samarqand', 10.00), ('Buxoro', 8.00);

SELECT 
    o.order_id,
    c.cust_name,
    c.region,
    o.total_amount AS net_amount,
    tr.tax_percentage,
    ROUND((o.total_amount * tr.tax_percentage / 100), 2) AS tax_amount,
    ROUND((o.total_amount + (o.total_amount * tr.tax_percentage / 100)), 2) AS gross_total,
    JSON_ARRAYAGG(
        JSON_OBJECT(
            'item', p.prod_name,
            'qty', od.quantity,
            'unit_price', od.unit_price,
            'subtotal', (od.quantity * od.unit_price)
        )
    ) AS invoice_items
FROM Orders o
JOIN Customers c ON o.cust_id = c.cust_id
JOIN TaxRates tr ON c.region = tr.region
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.prod_id = p.prod_id
GROUP BY o.order_id, c.cust_id, tr.tax_percentage;
