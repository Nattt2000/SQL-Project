--- Otázka:
	--- Má výška HDP vliv na změny ve mzdách a cenách potravin?
	--- Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

--- Odpověď: Ne, obecně v pozorovaných letech výraznější růst HDP nemá vliv na růst cen ani mezd. Nejde pozorovat přímá souvislost.

--- Rozšířená odpověď:
	--- U některých roků se může zdát, že jsou výsledky opravdu provázané, např. v roce 2007.
	--- 2007: HDP vzrostlo o 6 %, ceny potravin vzrostly o 4 % a mzdy vzrostly o 6 %. 
	--- Pokud ale máme konečně mnoho pozorování, tvrzení z nich nelze potvrdit, pouze vyvrátit protipříkladem. 
	--- Protipříklad k tvrzení: "Když HDP roste, ceny potravin i mzdy také rostou."
		--- 2009: HDP kleslo o 5 %, ceny potravin klesly o 6 %, ale mzdy vzrostly o 6 %.
		--- 2017: HDP vzrostlo o 5 %, ceny potravin vzrostly o 11 %, ale mzdy klesly o 2 %.
		--- Na protipříkladu tedy můžeme pozorovat, že se za zkoumané období alespoň jednou stala situace: HDP vzrostlo, mzdy klesly (2017), HDP kleslo, mzdy vzrostly (2009).

--- Popis: Funguje stejně jako query pro otázku 4, jen zde navíc provádíme ty stejné vzorce ještě pro gdp.

--- Poznámka: Exaktně by se tato otázka řešila lag korelací a regresní analýzou.

WITH
previous AS (
	SELECT
		payroll_year,
		round(avg(price)::numeric, 0) AS avg_price,
		lag(round(avg(price)::numeric, 0)) 
			OVER (ORDER BY payroll_year) AS prev_price,
		round(avg(payroll_value)::numeric, 0) AS avg_payroll,
		lag(round(avg(payroll_value)::numeric, 0)) 
			OVER (ORDER BY payroll_year) AS prev_payroll,	
		round(min(gdp)::numeric, 0) AS gdp,
		lag(round(min(gdp)::numeric, 0)) 
			OVER (ORDER BY payroll_year) AS prev_gdp
	FROM t_natalie_zykova_project_SQL_primary_final
	GROUP BY payroll_year
),
differences AS (
	SELECT
		*,
		(avg_price - prev_price) AS diff_price,
		(avg_payroll - prev_payroll) AS diff_payroll,
		(gdp - prev_gdp) AS diff_gdp
	FROM previous
)
SELECT
	payroll_year,
	avg_price,
	round((diff_price / prev_price) * 100::NUMERIC, 0) || '%' AS price_increase,
	avg_payroll,
	round((diff_payroll / prev_payroll) * 100::NUMERIC, 0) || '%' AS payroll_increase,
	gdp,
	round((diff_gdp / prev_gdp) * 100::NUMERIC, 0) || '%' AS gdp_increase
FROM differences
ORDER BY payroll_year;
