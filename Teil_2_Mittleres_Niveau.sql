/* ========================================================
   Teil_2_Mittleres_Niveau.sql
   Mittleres Niveau SQL – Beziehungen, JOINs, Aggregation
   Kommentare auf Deutsch
   Kompatibel mit MySQL 8+
   ======================================================== */

/* ---------------------------
   1) Tabelle: inventory (Lagerbestand)
   --------------------------- */
CREATE TABLE IF NOT EXISTS inventory (
  product_id BIGINT UNSIGNED PRIMARY KEY,   -- FK zu products.id
  quantity INT NOT NULL DEFAULT 0,          -- verfügbare Menge
  reserved INT NOT NULL DEFAULT 0,          -- reserviert für Bestellungen
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Erklärung: CASCADE löscht Lagerbestand automatisch, wenn Produkt gelöscht wird.

/* ---------------------------
   2) Tabelle: orders
   --------------------------- */
CREATE TABLE IF NOT EXISTS orders (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED,                  -- FK zu users.id
  order_number VARCHAR(50) NOT NULL UNIQUE,
  status ENUM('pending','paid','shipped','cancelled') DEFAULT 'pending',
  total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  placed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE = InnoDB;

-- Erklärung: ON DELETE SET NULL verhindert Löschen von Bestellungen, wenn Benutzer gelöscht wird.

/* ---------------------------
   3) Tabelle: order_items
   --------------------------- */
CREATE TABLE IF NOT EXISTS order_items (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT UNSIGNED NOT NULL,        -- FK zu orders.id
  product_id BIGINT UNSIGNED,               -- FK zu products.id
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
VALUES ('fatima@example.com', 'bcrypt_hash_3', 'Fatima', 'Al-Hassan');

INSERT INTO orders (user_id, order_number, status, total)
VALUES (3, 'ORD-20251103-0001', 'pending', 499.00);

INSERT INTO order_items (order_id, product_id, sku, product_name, unit_price, quantity, subtotal)
VALUES (1, 1, 'SKU-001', 'Smartphone X', 499.00, 1, 499.00);

INSERT INTO inventory (product_id, quantity) VALUES (1, 50);

/* ---------------------------
   5) JOIN-Beispiele
   --------------------------- */
-- 5.1 INNER JOIN: Zeigt alle Bestellungen mit Benutzername
SELECT o.order_number, o.status, u.first_name, u.last_name, o.total
FROM orders o
INNER JOIN users u ON o.user_id = u.id;

-- 5.2 LEFT JOIN: Alle Produkte, auch wenn kein Lagerbestand existiert
SELECT p.name, COALESCE(i.quantity,0) AS quantity
FROM products p
LEFT JOIN inventory i ON p.id = i.product_id;

-- 5.3 Aggregation: Summe der Bestellungen je Benutzer
SELECT u.id, u.first_name, u.last_name, SUM(o.total) AS total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.first_name, u.last_name
ORDER BY total_spent DESC;

/* ---------------------------
   6) Views (Ansichten) – einfaches Beispiel
   --------------------------- */
CREATE OR REPLACE VIEW v_active_products AS
SELECT p.id, p.name, p.price, COALESCE(i.quantity,0) AS quantity
FROM products p
LEFT JOIN inventory i ON p.id = i.product_id
WHERE p.id IS NOT NULL;

-- Erklärung: Views erleichtern wiederkehrende Abfragen.

/* ---------------------------
   7) Beispiel: Top 3 Produkte nach Lagerbestand
   --------------------------- */
SELECT p.name, i.quantity
FROM products p
JOIN inventory i ON p.id = i.product_id
ORDER BY i.quantity DESC
LIMIT 3;

/* ---------------------------
   8) Beispiel für dynamische WHERE-Bedingung
   --------------------------- */
SELECT p.name, p.price
FROM products p
WHERE p.price BETWEEN 20 AND 500
ORDER BY p.price ASC;

/* ---------------------------
   9) Ende von Teil_2_Mittleres_Niveau.sql
   --------------------------- */
-- Jetzt sind Tabellen für Orders, Order_Items und Inventory bereit.
-- JOINs, Aggregates und Views für mittleres Niveau werden demonstriert.
