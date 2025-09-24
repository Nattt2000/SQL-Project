--- Primary table

--- Tabulka "t_natalie_zykova_project_SQL_primary_final", ze které budeme vycházet pro zodpovězení otázek.
--- Zahrnuje data cen potravin a mezd v ČR sjednocených na společné roky.

--- Tabulka se vytvoří pomocí tří CTE "price_join", "payroll_join" a "gdp_join", které se na konci propojí ve finální query.
--- CTE "price_join": Spojuje v sobě informace o cenách s názvy jednotlivých potravin a regiony.
--- CTE "payroll_join": Spojuje v sobě informace o výplatách s názvy jednotlivých odvětví.
--- CTE "gdp_join": tabulka "economies" zúžená pouze na data gdp v ČR
--- Finální query potom spojuje všechny tři CTE na základě sloupce "year".
--- Používám INNER JOIN, takže se vypíše průnik těchto roků, tj. ty roky, které se objevují ve všech použitých tabulkách.


SELECT * FROM czechia_payroll_industry_branch;

CREATE TABLE IF NOT EXISTS t_natalie_zykova_project_SQL_primary_final AS (
	WITH
	price_join AS (
		SELECT
			cprc.name AS category_name,
			cprc.price_value AS amount,
			cprc.price_unit AS unit,
			cpr.value AS price,
			cr.name AS region_name,
			date_part('year', cpr.date_from) AS price_year
		FROM czechia_price AS cpr
		JOIN czechia_price_category AS cprc    
		ON cpr.category_code = cprc.code
		JOIN czechia_region AS cr
		ON cpr.region_code = cr.code
		WHERE date_from IS NOT NULL
	),
	payroll_join AS (
		SELECT
			cpib.name AS industry_branch_name,
			cpay.value AS payroll_value,
			cpay.payroll_year AS payroll_year,
			cpay.payroll_quarter AS payroll_quarter
		FROM czechia_payroll AS cpay
		JOIN czechia_payroll_industry_branch AS cpib 
		ON cpay.industry_branch_code = cpib.code
	),
	gdp_join AS (
		SELECT
			"year",
			gdp
		FROM economies AS e
		WHERE country = 'Czech Republic'
	)
	SELECT
		prj.category_name,
		prj.amount,
		prj.unit,
		prj.price,
		prj.region_name,
		paj.industry_branch_name,
		paj.payroll_value,
		paj.payroll_year,
		paj.payroll_quarter,
		gj.gdp
	FROM price_join AS prj
	JOIN payroll_join AS paj
	ON prj.price_year = paj.payroll_year
	JOIN gdp_join AS gj
	ON prj.price_year = gj."year"
);

SELECT * FROM t_natalie_zykova_project_SQL_primary_final;