--- Otázka: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

--- Odpověď: Ano, mzdy v průběhu let rostou ve všech odvětvích.

--- Rozšířená odpověď:
	--- Protože pro všechna odvětví vyšel slope > 0, můžeme říct, že obecně ve všech odvětvích mají mzdy tendenci růst.
	--- Každé odvětví zaznamenalo aspoň v jednom roce pokles mezd, ale celkově pro celé měřené období mzdy rostou ve všech odvětvích.
	--- Nejrychleji rostou mzdy v Informačních a komunikačních činnostech.
	--- Nejpomaleji zase v Profesních, vědeckých a technických činnostech.
	--- Podrobnější výsledky se zobrazí v Pythonu.

--- Popis
	--- Vytvořím si jednoduchou query základních tří sloupců, se kterými budu dále pracovat.
	--- Vypsaná data jsou ale takto nepřehledná, nechci mít tři sloupce opakujících se hodnot, ale přehlednou tabulku výplat podle let a odvětví.
	--- To vede na vytvoření pivotky. popis řádků: industry_branch_name, popis sloupců: payroll_year, hodnoty: avg_payroll.
	--- Tuto query tedy exportuju do Pythonu, v Pandas vytvořím pivotku, v Matplotlib grafy pro každé odvětví.
	--- Dále použiju regresní model pro zjištění koeficientu sklonu = slope.
	--- V Pythonu potom vypíšu odvětví s min(slope) tj. nejpomaleji rostoucí a max(slope) tj. nejpomaleji rostoucí a přehled všech odvětví a jejich slope.
	--- Z tohoto výstupu v Pythonu potom odpovím na otázku.

--- Poznámka: Tato otázka by šla řešit i postupem, který jsem aplikovala v otázce 3.

--- Query pro export
SELECT
	industry_branch_name,
	payroll_year,
	round(avg(payroll_value)::NUMERIC, 0) AS avg_payroll
FROM t_natalie_zykova_project_SQL_primary_final
GROUP BY industry_branch_name, payroll_year
ORDER BY industry_branch_name, payroll_year;




