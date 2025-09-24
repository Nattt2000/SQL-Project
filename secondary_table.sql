--- Secondary table

--- Tabulka "t_natalie_zykova_project_SQL_secondary_final" pro dodatečná data o dalších evropských státech

CREATE TABLE IF NOT EXISTS t_natalie_zykova_project_SQL_secondary_final AS (
	SELECT
		country,
		population,
		gdp,
		gini,
		"year"
	FROM economies AS e
	WHERE "year" BETWEEN 2006 AND 2018
	ORDER BY "year"
);

SELECT * FROM t_natalie_zykova_project_SQL_secondary_final;

