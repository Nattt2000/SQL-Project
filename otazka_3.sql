--- Otázka: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

--- Odpověď:
	--- Nejpomaleji zdražuje kategorie "Cukr krystalový", cena za měřené roky dokonce klesla, a to o 2.6 %.
	--- Nejrychleji zdražuje kategorie "Máslo", cena za měřené roky vzrostla o 5.9 %.

--- Rozšířená odpověď:
	--- Obecně ceny potravin spíše rostly (mezi 0.6 % a 5.9 %).
	--- Pokles ceny jsme zaznamenali pouze u "Cukr krystalový" (-2.6 %) a "Rajská jablka červená kulatá" (-2.3 %).

--- Popis
	--- CTE "podklad": vybírá sloupce, které budeme dále potřebovat. Počítá průměrnou cenu potravin za měřené období.
	--- CTE "prechody" a CTE "extremy_ceny" obě čerpají z "podklad" a počítají pomocné proměnné, které potom použijeme do vzorce geometrického průměru.
	--- CTE "vypis_potravin" počítá procentuální nárůst vzorcem geometrického průměru. Tento vzorec je odvozen z rovnice exponenciálního růstu. 
	--- CTE "vypis_potravin" by už mohla být finální query, pokud bychom chtěli vypsat všechny potraviny a jejich nárůsty.
	--- MIN a MAX bychom potom ale museli hledat ručně. Při velkém množství dat by se nám tyto hodnoty hledaly špatně a trvalo by to dlouho.
	--- Proto máme ještě finální query, která hledá pouze MIN a MAX pomocí ORDER BY a limitu = 1.
	--- Pro zobrazení všech kategorií s procentuálním nárůstem za měřené období stačí vymazat finální query a CTE "vypis_potravin" přeměnit na finální query.

--- Poznámka: Tato otázka by šla řešit i postupem, který jsem aplikovala v otázce 1.

WITH
podklad AS (
	SELECT
		category_name,
		payroll_year,
		round(avg(price)::NUMERIC, 0) AS avg_price
	FROM t_natalie_zykova_project_SQL_primary_final
	GROUP BY category_name, payroll_year
),
prechody AS (
	SELECT
		category_name,
		(count(DISTINCT payroll_year) - 1) AS pocet_prechodu
	FROM podklad
	GROUP BY category_name
),
extremy_ceny AS (
	SELECT
		category_name,
		FIRST_VALUE(avg_price) 
			OVER (PARTITION BY category_name ORDER BY payroll_year) AS first_price,
		LAST_VALUE(avg_price)
			OVER (PARTITION BY category_name ORDER BY payroll_year
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
			AS last_price
	FROM podklad
),
vypis_potravin AS (
	SELECT DISTINCT
		ec.category_name AS category_name,
		round(((power((last_price / first_price), (1.0 / pocet_prechodu)) - 1)*100)::NUMERIC, 1) AS procentualni_narust
	FROM extremy_ceny AS ec
	JOIN prechody AS p
	ON ec.category_name = p.category_name
)
(
	SELECT
		category_name AS category_name_min_max,
		procentualni_narust || '%' AS procentualni_narust_min_max
	FROM vypis_potravin
	ORDER BY procentualni_narust ASC
	LIMIT 1
)
UNION ALL
(
	SELECT
		category_name AS category_name_min_max,
		procentualni_narust || '%' AS procentualni_narust_min_max
	FROM vypis_potravin
	ORDER BY procentualni_narust DESC 
	LIMIT 1
);


