# SQL Lernprojekt – Von Anfänger bis Fortgeschritten

Dieses Projekt ist eine komplette SQL-Lernumgebung, die Schritt für Schritt vom Anfänger- bis zum Fortgeschrittenenniveau führt.  
Es eignet sich perfekt für das Üben von SQL-Befehlen, Datenbankdesign, Abfragen, Joins, Aggregationen, Stored Procedures, Triggern und Views.

---

## Projektstruktur

SQL/
├── Teil_1_Grundlagen.sql
│   
├── Teil_2_Mittleres_Niveau.sql
│   
├── Teil_3_Fortgeschritten.sql
│  
├── Teil_4_Beispielprojekt.sql
│   
└── README.md


---

##  Teil 1 – Grundlagen (Teil_1_Grundlagen.sql)

**Was enthalten ist:**

- Erstellung einer Datenbank und einfacher Tabellen (`users`, `categories`, `products`)  
- Einfügen von Daten (`INSERT`)  
- Abfragen (`SELECT`) mit Bedingungen (`WHERE`) und Sortierung (`ORDER BY`)  
- Daten aktualisieren (`UPDATE`) und löschen (`DELETE`)  

**Ziel:**  
Grundlagen von SQL verstehen und einfache Datenbankoperationen durchführen.

---

## Teil 2 – Mittleres Niveau (Teil_2_Mittleres_Niveau.sql)

**Was enthalten ist:**

- Erweiterte Tabellen für Bestellungen (`orders`, `order_items`) und Lagerbestand (`inventory`)  
- Beziehungen zwischen Tabellen mittels Foreign Keys  
- Joins (INNER JOIN, LEFT JOIN)  
- Aggregationsfunktionen (`SUM`, `COUNT`, `GROUP BY`)  
- Views zur Vereinfachung wiederkehrender Abfragen  

**Ziel:**  
Komplexere Abfragen und die Modellierung von Beziehungen zwischen Tabellen erlernen.

---

## Teil 3 – Fortgeschrittene Techniken (Teil_3_Fortgeschritten.sql)

**Was enthalten ist:**

- Stored Procedures zur Automatisierung von Abläufen (`sp_create_order`)  
- Trigger zur automatischen Aktualisierung des Lagerbestands (`trg_after_order_paid`)  
- Prepared Statements für dynamische und sichere Abfragen  
- Common Table Expressions (CTEs) und Window Functions  
- Fortgeschrittene Aggregationen und Datenanalyse  

**Ziel:**  
Fortgeschrittene Datenbanklogik implementieren und komplexe Geschäftsprozesse abbilden.

---

## Teil 4 – Beispielprojekt (Teil_4_Beispielprojekt.sql)

**Was enthalten ist:**

- Alle Tabellen und Konzepte der vorherigen Teile kombiniert  
- Beispiel-Daten für Benutzer, Produkte, Kategorien, Bestellungen und Lagerbestand  
- Vollständig funktionierende Stored Procedure für Bestellvorgänge  
- Trigger zur automatischen Lagerbestand-Anpassung  
- Views und Abfragen zur Analyse von Verkäufen und Lagerbestand  

**Ziel:**  
Ein praxisnahes Projekt, das alle gelernten SQL-Kenntnisse vereint und zum Testen und Üben genutzt werden kann.

---

## Nutzung

1. Die `.sql`-Dateien in der Reihenfolge ausführen:  
   1. Teil_1_Grundlagen.sql  
   2. Teil_2_Mittleres_Niveau.sql  
   3. Teil_3_Fortgeschritten.sql  
   4. Teil_4_Beispielprojekt.sql  
2. Stelle sicher, dass du **MySQL 8+** verwendest, um alle Funktionen wie CTEs und Window Functions zu nutzen.  
3. Passe Beispiel-Daten nach Bedarf an, um verschiedene Szenarien zu testen.  

---

## Empfehlung

- Jede Datei einzeln üben und die Kommentare in Deutsch lesen, um die Logik zu verstehen.  
- Experimentiere mit Joins, Aggregationen, Stored Procedures und Triggern.  
- Versuche eigene Abfragen und Prozeduren zu erstellen, um das Gelernte zu vertiefen.

---

##  Lizenz

Dieses Repository ist frei verfügbar für Lern- und Übungszwecke.

---

**Viel Spaß beim Lernen und Experimentieren mit SQL!** 
Sameha

