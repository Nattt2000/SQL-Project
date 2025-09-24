--- Otázka: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

--- Odpověď:
	--- V roce 2006 je možné si z průměrné výplaty koupit 1190 kg chleba a 1360 litrů mléka.
	--- V roce 2018 je možné si z průměrné výplaty koupit 1242 kg chleba a 1490 litrů mléka.

--- Rozšířená odpověď:
	--- Jako první a poslední měřené období bereme první rok = 2006 a poslední rok = 2018.
	--- Můžeme říct, že na konci měření byla situace finančně přívětivější než na začátku měření.
	--- Lidé si v roce 2018 mohli ze své výplaty koupit více jednotek zboží než v roce 2006.

--- Popis
	--- Vytvoříme CTE "podklad" s hlavními informacemi a dále pomocné CTE "roky" pro dynamické zjištění prvního a posledního období.
	--- Ve výsledné query potom tyto dvě CTE spojíme pouze pro požadované roky.
	--- Vydělením průměrné mzdy průměrnou cenou dané potraviny vypočteme hodnotu units_affordable
	--- Tj. kolik jednotek suroviny jsme schopni si za průměrnou výplatu koupit.
	--- Vypíšeme výsledné sloupce, které nás zajímají.

WITH
podklad AS (
	SELECT
		category_name,
		payroll_year,
		amount,
		unit,
		round(avg(price)::NUMERIC, 0) AS avg_price,
		round(avg(payroll_value)::NUMERIC, 0) AS avg_payroll
	FROM t_natalie_zykova_project_SQL_primary_final
	WHERE (category_name LIKE 'Mléko%' OR category_name LIKE 'Chléb%')
	GROUP BY category_name, payroll_year, amount, unit
),
roky AS (
	SELECT 
		min(payroll_year) AS first_year,
		max(payroll_year) AS last_year
	FROM t_natalie_zykova_project_SQL_primary_final
)
SELECT
	p.category_name,
	p.payroll_year,
	round((avg_payroll / avg_price)::NUMERIC, 0) AS units_affordable,
	p.unit
FROM podklad AS p
JOIN roky AS r
ON p.payroll_year IN (r.first_year, r.last_year)
ORDER BY category_name, payroll_year;




