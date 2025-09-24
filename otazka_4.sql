--- Otázka: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

--- Odpověď: Ano, existuje, je to rok 2017, kdy cena potravin vzrostla o 11 %. Naproti tomu mzdy klesly o 2 %.

--- Rozšířená odpověď:
	--- Špatná ekonomická situace
		--- 2017: Ceny vzrostly o 11 %, mzdy klesly o 2 %.
		--- 2013: Ceny vzrostly o 6 %, mzdy klesly o 7 %.
	--- Dobrá ekonomická situace
		--- 2009: Ceny klesly o 6 % a mzdy vzrostly o 6 %.
		--- 2014: Ceny nevzrostly (drží se stejné) a mzdy vzrostly o 6 %.
		--- 2016: Ceny klesly o 2 %, mzdy vzrostly o 9 %.
		--- 2018: Ceny vzrostly o 2 %, mzdy vzrostly o 13 %.

--- Popis:
	--- První CTE "previous" vytváří pomocí agregací sloupce průměrů za rok.
	--- K nim vytváří sloupec identických hodnot posunutých o řádek dolů (pomocí fce lag).
	--- Druhá CTE "differences" potom vytvoří sloupec rozdílů hodnot mezi jednotlivými roky.
	--- Finální query potom provádí výpočet procent z hodnot rozdílů. Vypíše všechny potřebné sloupce.

WITH
previous AS (
	SELECT
		payroll_year,
		round(avg(price)::numeric, 0) AS avg_price,
		lag(round(avg(price)::numeric, 0)) 
			OVER (ORDER BY payroll_year) AS prev_price,
		round(avg(payroll_value)::numeric, 0) AS avg_payroll,
		lag(round(avg(payroll_value)::numeric, 0)) 
			OVER (ORDER BY payroll_year) AS prev_payroll
	FROM t_natalie_zykova_project_SQL_primary_final
	GROUP BY payroll_year	
),
differences AS (
	SELECT
		*,
		(avg_price - prev_price) AS diff_price,
		(avg_payroll - prev_payroll) AS diff_payroll
	FROM previous
)
SELECT
	payroll_year,
	avg_price,
	round((diff_price / prev_price) * 100::NUMERIC, 0) || '%' AS price_increase,
	avg_payroll,
	round((diff_payroll / prev_payroll) * 100::NUMERIC, 0) || '%' AS payroll_increase
FROM differences
ORDER BY payroll_year;
