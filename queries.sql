-- ============================================================
-- IT-Project-Management: Beispielabfragen
-- Datenbank: IT_Project_Management.db (SQLite)
-- ============================================================


-- ------------------------------------------------------------
-- 1. Einfache Abfragen (SELECT, WHERE, ORDER BY)
-- ------------------------------------------------------------

-- Alle Projekte, sortiert nach Budget (höchstes zuerst)
SELECT project_name, status, budget
FROM Projects
ORDER BY budget DESC;

-- Nur aktive Projekte
SELECT project_name, start_date, end_date
FROM Projects
WHERE status = 'Active';


-- ------------------------------------------------------------
-- 2. JOIN: Daten aus mehreren Tabellen verbinden
-- ------------------------------------------------------------

-- Jede Aufgabe mit Projektname und zuständigem Team
SELECT t.task_name,
       p.project_name,
       tm.team_name,
       t.status,
       t.due_date
FROM Tasks t
JOIN Projects p ON t.project_id = p.project_id
JOIN Teams tm   ON t.team_id    = tm.team_id;

-- Alle Projekte, auch ohne Aufgaben (LEFT JOIN)
SELECT p.project_name,
       t.task_name
FROM Projects p
LEFT JOIN Tasks t ON p.project_id = t.project_id;


-- ------------------------------------------------------------
-- 3. GROUP BY: Auswertungen
-- ------------------------------------------------------------

-- Gesamtkosten pro Projekt
SELECT p.project_name,
       SUM(c.amount) AS gesamt_kosten
FROM Projects p
JOIN Costs c ON p.project_id = c.project_id
GROUP BY p.project_name;

-- Budget vs. Kosten: Wie viel Budget ist noch übrig?
SELECT p.project_name,
       p.budget,
       COALESCE(SUM(c.amount), 0)            AS kosten,
       p.budget - COALESCE(SUM(c.amount), 0) AS rest_budget
FROM Projects p
LEFT JOIN Costs c ON p.project_id = c.project_id
GROUP BY p.project_id, p.project_name, p.budget
ORDER BY rest_budget;

-- Anzahl Aufgaben pro Team
SELECT tm.team_name,
       COUNT(t.task_id) AS anzahl_aufgaben
FROM Teams tm
LEFT JOIN Tasks t ON tm.team_id = t.team_id
GROUP BY tm.team_id, tm.team_name;


-- ------------------------------------------------------------
-- 4. Daten ändern (INSERT, UPDATE, DELETE)
--    Hinweis: Diese Befehle ändern die Datenbank.
-- ------------------------------------------------------------

-- Neue Aufgabe anlegen
-- INSERT INTO Tasks (task_name, project_id, team_id, status, due_date)
-- VALUES ('Datenbank testen', 3, 3, 'Open', '2024-07-15');

-- Status eines Projekts ändern
-- UPDATE Projects
-- SET status = 'Active'
-- WHERE project_id = 3;

-- Aufgabe löschen
-- DELETE FROM Tasks
-- WHERE task_id = 3;
