/* ========================================================
   Teil_1_Grundlagen.sql
   Grundlagen SQL für Anfänger – Kommentare auf Deutsch
   Kompatibel mit MySQL 8+
   ======================================================== */

/* ---------------------------
   1) Datenbank erstellen
   --------------------------- */
-- Erstellen einer neuen Datenbank für das Projekt
CREATE DATABASE IF NOT EXISTS beispiel_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- Datenbank auswählen
USE beispiel_db;

--------------------------------------------------------------------------------
-- 2) Tabelle erstellen: users
--------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,   -- Eindeutige Benutzer-ID
  email VARCHAR(255) NOT NULL UNIQUE,              -- E-Mail-Adresse, muss einzigartig sein
  password_hash VARCHAR(255) NOT NULL,             -- Passwort als Hash speichern
  first_name VARCHAR(100),                         -- Vorname
  last_name VARCHAR(100),                          -- Nachname
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Erstellungszeitpunkt
  is_active BOOLEAN DEFAULT TRUE                   -- Benutzer aktiv/inaktiv
) ENGINE = InnoDB;

--------------------------------------------------------------------------------
-- 3) Daten einfügen (INSERT)
--------------------------------------------------------------------------------
INSERT INTO users (email, password_hash, first_name, last_name)
VALUES
  ('sameha@example.com', 'bcrypt_hash_1', 'Sameha', 'Salem'),
  ('ahmed@example.com', 'bcrypt_hash_2', 'Ahmed', 'Al-Najjar');

-- Erklärung: INSERT INTO <Tabelle> (Spalten) VALUES (...);

--------------------------------------------------------------------------------
-- 4) Daten abfragen (SELECT)
--------------------------------------------------------------------------------
-- Alle Benutzer anzeigen
SELECT * FROM users;

-- Nur bestimmte Spalten anzeigen
SELECT first_name, last_name, email FROM users;

-- Mit Bedingung filtern
SELECT * FROM users WHERE is_active = TRUE;

--------------------------------------------------------------------------------
-- 5) Daten aktualisieren (UPDATE)
--------------------------------------------------------------------------------
-- Benutzer inaktiv setzen (id = 1)
UPDATE users
SET is_active = FALSE
WHERE id = 1;

-- Erklärung: Ohne WHERE würde die Aktualisierung auf alle Zeilen wirken!

--------------------------------------------------------------------------------
-- 6) Daten löschen (DELETE)
--------------------------------------------------------------------------------
-- Benutzer nach E-Mail löschen
DELETE FROM users WHERE email = 'ahmed@example.com';

-- Erklärung: DELETE FROM <Tabelle> WHERE <Bedingung>;

--------------------------------------------------------------------------------
-- 7) Tabelle erstellen: categories
--------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS categories (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,       -- Name der Kategorie
  description TEXT,                 -- Beschreibung
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB;

--------------------------------------------------------------------------------
-- 8) Tabelle erstellen: products
--------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS products (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL DEFAULT 0.00,  -- Preis
  category_id INT UNSIGNED,                     -- FK zur Kategorie
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE = InnoDB;

--------------------------------------------------------------------------------
-- 9) Beispiel-Daten einfügen: categories & products
--------------------------------------------------------------------------------
INSERT INTO categories (name, description) VALUES
  ('Electronics', 'Elektronikgeräte und Zubehör'),
  ('Books', 'Bücher aller Art');

INSERT INTO products (name, description, price, category_id) VALUES
  ('Smartphone X', 'Neues Smartphone Modell X', 499.00, 1),
  ('SQL Lernen', 'Buch über SQL für Anfänger', 29.90, 2);

--------------------------------------------------------------------------------
-- 10) Grundlegende Abfragen (SELECT + WHERE + ORDER BY)
--------------------------------------------------------------------------------
-- Alle Produkte anzeigen
SELECT * FROM products;

-- Produkte nach Preis sortieren
SELECT name, price FROM products ORDER BY price DESC;

-- Produkte einer bestimmten Kategorie anzeigen
SELECT p.name, p.price, c.name AS category_name
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE c.name = 'Books';

--------------------------------------------------------------------------------
-- Ende von Teil_1_Grundlagen.sql
-- Du kannst diesen Code in Visual Studio Code kopieren und ausführen.
--------------------------------------------------------------------------------
