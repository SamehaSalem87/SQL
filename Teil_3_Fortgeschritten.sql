/* ========================================================
   Teil_3_Fortgeschritten.sql
   Fortgeschrittene SQL-Techniken – Stored Procedures, Triggers, Prepared Statements
   Kommentare auf Deutsch
   Kompatibel mit MySQL 8+
   ======================================================== */

/* ---------------------------
   1) Stored Procedure: Einfacher Bestellvorgang
   --------------------------- */
DELIMITER $$

CREATE PROCEDURE sp_create_order(
  IN in_user_id BIGINT,
  IN in_product_id BIGINT,
  IN in_quantity INT
)
BEGIN
  DECLARE v_order_id BIGINT;
  DECLARE v_price DECIMAL(10,2);

  START TRANSACTION;

  -- Preis des Produkts sperren
  SELECT price INTO v_price FROM products WHERE id = in_product_id FOR UPDATE;

  -- Bestellung einfügen
  INSERT INTO orders (user_id, order_number, status, total)
  VALUES (in_user_id, CONCAT('ORD-', DATE_FORMAT(NOW(), '%Y%m%d%H%i%S'), '-', FLOOR(RAND()*10000)), 'pending', v_price * in_quantity);

  SET v_order_id = LAST_INSERT_ID();

  -- Order_Items hinzufügen
  INSERT INTO order_items (order_id, product_id, sku, product_name, unit_price, quantity, subtotal)
  SELECT v_order_id, p.id, p.sku, p.name, p.price, in_quantity, p.price * in_quantity
  FROM products p WHERE p.id = in_product_id;

  -- Lagerbestand reservieren
  UPDATE inventory
  SET reserved = reserved + in_quantity
  WHERE product_id = in_product_id AND quantity >= in_quantity;

  COMMIT;
END$$

DELIMITER ;

/* ---------------------------
   2) Trigger: Nach Bezahlung Bestellung Lagerbestand aktualisieren
   --------------------------- */
DELIMITER $$

CREATE TRIGGER trg_after_order_paid
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
  IF OLD.status <> 'paid' AND NEW.status = 'paid' THEN
    -- Reserved reduzieren und Menge anpassen
    UPDATE inventory inv
    JOIN order_items oi ON inv.product_id = oi.product_id
    SET inv.reserved = GREATEST(inv.reserved - oi.quantity, 0),
        inv.quantity = GREATEST(inv.quantity - oi.quantity, 0)
    WHERE oi.order_id = NEW.id;
  END IF;
END$$

DELIMITER ;

/* ---------------------------
   3) Prepared Statement: Dynamische Produktsuche
   --------------------------- */
SET @search_term = '%Smartphone%';
PREPARE stmt FROM 'SELECT id, name, price FROM products WHERE name LIKE ? ORDER BY price DESC LIMIT 10';
SET @p1 = @search_term;
EXECUTE stmt USING @p1;
DEALLOCATE PREPARE stmt;

-- Erklärung: Prepared Statements erhöhen Sicherheit und Performance bei wiederholter Ausführung.

/* ---------------------------
   4) CTE + Window Function: Top 3 Produkte pro Kategorie nach Verkaufsmenge
   --------------------------- */
WITH sales_per_product AS (
  SELECT p.id AS product_id, p.name, p.category_id, SUM(oi.quantity) AS total_sold
  FROM order_items oi
  JOIN products p ON oi.product_id = p.id
  GROUP BY p.id, p.name, p.category_id
)
SELECT product_id, name, category_id, total_sold
FROM (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY total_sold DESC) AS rn
  FROM sales_per_product
) t
WHERE rn <= 3;

-- Erklärung: ROW_NUMBER() teilt Rangfolge innerhalb jeder Kategorie zu.

/* ---------------------------
   5) Fortgeschrittene Aggregation: Umsatz pro Tag
   --------------------------- */
SELECT DATE(placed_at) AS sale_date,
       COUNT(*) AS orders_count,
       SUM(total) AS total_revenue
FROM orders
WHERE status IN ('paid','shipped')
GROUP BY DATE(placed_at)
ORDER BY sale_date DESC;

/* ---------------------------
   6) View Beispiel: Top-Seller Produkte
   --------------------------- */
CREATE OR REPLACE VIEW v_top_sellers AS
SELECT p.id, p.name, SUM(oi.quantity) AS sold_quantity
FROM products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name
ORDER BY sold_quantity DESC;

/* ---------------------------
   7) Ende von Teil_3_Fortgeschritten.sql
   --------------------------- */
-- Dieser Teil enthält fortgeschrittene SQL-Techniken für komplexe Geschäftslogik.
-- Mit Stored Procedures, Triggern, Prepared Statements, CTEs und Window Functions.
