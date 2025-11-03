/* ========================================================
   Teil_4_Beispielprojekt.sql
   Komplettes Beispielprojekt – Kombination aller vorherigen Teile
   Kommentare auf Deutsch
   Kompatibel mit MySQL 8+
   ======================================================== */

/* ---------------------------
   1) Datenbank erstellen & verwenden
   --------------------------- */
CREATE DATABASE IF NOT EXISTS beispielprojekt
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE beispielprojekt;

/* ---------------------------
   2) Tabellen: Users, Categories, Products
   --------------------------- */
CREATE TABLE IF NOT EXISTS users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_active BOOLEAN DEFAULT TRUE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS categories (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS products (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  category_id INT UNSIGNED,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS inventory (
  product_id BIGINT UNSIGNED PRIMARY KEY,
  quantity INT NOT NULL DEFAULT 0,
  reserved INT NOT NULL DEFAULT 0,
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE = InnoDB;

/* ---------------------------
   3) Tabellen: Orders & Order_Items
   --------------------------- */
CREATE TABLE IF NOT EXISTS orders (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED,
  order_number VARCHAR(50) NOT NULL UNIQUE,
  status ENUM('pending','paid','shipped','cancelled') DEFAULT 'pending',
  total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  placed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS order_items (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED,
  sku VARCHAR(100),
  product_name VARCHAR(255),
  unit_price DECIMAL(10,2) NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  subtotal DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id)
) ENGINE = InnoDB;

/* ---------------------------
   4) Beispiel-Daten einfügen
   --------------------------- */
INSERT INTO users (email, password_hash, first_name, last_name)
VALUES
('samira@example.com','bcrypt_hash_1','Samira','Al-Salem'),
('ahmed@example.com','bcrypt_hash_2','Ahmed','Al-Najjar');

INSERT INTO categories (name, description) VALUES
('Electronics','Elektronikgeräte und Zubehör'),
('Books','Bücher aller Art'),
('Clothing','Kleidung für Damen und Herren');

INSERT INTO products (name, description, price, category_id) VALUES
('Smartphone X','Neues Smartphone Modell X',499.00,1),
('SQL Lernen','Buch über SQL für Anfänger',29.90,2),
('Cotton T-Shirt','Bequemes Baumwollshirt',15.00,3);

INSERT INTO inventory (product_id, quantity) VALUES
(1,50),(2,200),(3,150);

/* ---------------------------
   5) Stored Procedure: Bestellung erstellen
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

  SELECT price INTO v_price FROM products WHERE id = in_product_id FOR UPDATE;

  INSERT INTO orders (user_id, order_number, status, total)
  VALUES (in_user_id, CONCAT('ORD-', DATE_FORMAT(NOW(), '%Y%m%d%H%i%S'), '-', FLOOR(RAND()*10000)), 'pending', v_price*in_quantity);

  SET v_order_id = LAST_INSERT_ID();

  INSERT INTO order_items (order_id, product_id, sku, product_name, unit_price, quantity, subtotal)
  SELECT v_order_id, p.id, p.sku, p.name, p.price, in_quantity, p.price*in_quantity
  FROM products p WHERE p.id = in_product_id;

  UPDATE inventory
  SET reserved = reserved + in_quantity
  WHERE product_id = in_product_id AND quantity >= in_quantity;

  COMMIT;
END$$
DELIMITER ;

/* ---------------------------
   6) Trigger: Lagerbestand nach Bezahlung aktualisieren
   --------------------------- */
DELIMITER $$
CREATE TRIGGER trg_after_order_paid
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
  IF OLD.status <> 'paid' AND NEW.status = 'paid' THEN
    UPDATE inventory inv
    JOIN order_items oi ON inv.product_id = oi.product_id
    SET inv.reserved = GREATEST(inv.reserved - oi.quantity,0),
        inv.quantity = GREATEST(inv.quantity - oi.quantity,0)
    WHERE oi.order_id = NEW.id;
  END IF;
END$$
DELIMITER ;

/* ---------------------------
   7) View: Aktive Produkte mit Lagerbestand
   --------------------------- */
CREATE OR REPLACE VIEW v_active_products AS
SELECT p.id, p.name, p.price, COALESCE(i.quantity,0) AS quantity
FROM products p
LEFT JOIN inventory i ON p.id = i.product_id
WHERE p.id IS NOT NULL;

/* ---------------------------
   8) Beispiel-Abfragen
   --------------------------- */
-- Alle Bestellungen mit Benutzer anzeigen
SELECT o.order_number, o.status, u.first_name, u.last_name, o.total
FROM orders o
JOIN users u ON o.user_id = u.id;

-- Top 3 Produkte nach Lagerbestand
SELECT p.name, i.quantity
FROM products p
JOIN inventory i ON p.id = i.product_id
ORDER BY i.quantity DESC
LIMIT 3;

-- Umsatz pro Kategorie berechnen
SELECT c.name AS category_name, SUM(oi.subtotal) AS category_revenue
FROM categories c
JOIN products p ON p.category_id = c.id
JOIN order_items oi ON oi.product_id = p.id
JOIN orders o ON o.id = oi.order_id AND o.status IN ('paid','shipped')
GROUP BY c.id, c.name;

/* ---------------------------
   9) Ende von Teil_4_Beispielprojekt.sql
   --------------------------- */
-- Dieses Beispielprojekt verbindet alle vorherigen Teile:
-- Grundlagen, mittleres Niveau, fortgeschrittene Techniken
-- Fertig zum Testen und Üben in Visual Studio Code
