## Primary table

Tabulka "t_natalie_zykova_project_SQL_primary_final", ze které budeme vycházet pro zodpovězení otázek.  
Zahrnuje data cen potravin a mezd v ČR sjednocených na společné roky.

Tabulka se vytvoří pomocí tří CTE "price_join", "payroll_join" a "gdp_join", které se na konci propojí ve finální query.  
CTE "price_join": Spojuje v sobě informace o cenách s názvy jednotlivých potravin a regiony.  
CTE "payroll_join": Spojuje v sobě informace o výplatách s názvy jednotlivých odvětví.  
CTE "gdp_join": tabulka "economies" zúžená pouze na data gdp v ČR.  
Používám INNER JOIN, takže se vypíše průnik těchto roků, tj. ty roky, které se objevují ve všech použitých tabulkách.

## Secondary table

Tabulka "t_natalie_zykova_project_SQL_secondary_final" pro dodatečná data o dalších evropských státech.

## Otázka 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

**Odpověď:** Ano, mzdy v průběhu let rostou ve všech odvětvích.  

**Rozšířená odpověď:**  
Protože pro všechna odvětví vyšel slope > 0, můžeme říct, že obecně ve všech odvětvích mají mzdy tendenci růst.  
Každé odvětví zaznamenalo aspoň v jednom roce pokles mezd, ale celkově pro celé měřené období mzdy rostou ve všech odvětvích.  
Nejrychleji rostou mzdy v Informačních a komunikačních činnostech.  
Nejpomaleji zase v Profesních, vědeckých a technických činnostech.  
Podrobnější výsledky se zobrazí v Pythonu.

**Popis:**  
Vytvořím si jednoduchou query základních tří sloupců, se kterými budu dále pracovat.  
Vypsaná data jsou ale nepřehledná, nechci mít tři sloupce opakujících se hodnot, ale přehlednou tabulku výplat podle let a odvětví.  
To vede na vytvoření pivotky. Popis řádků: `industry_branch_name`, popis sloupců: `payroll_year`, hodnoty: `avg_payroll`.  
Tuto query tedy exportuju do Pythonu, v Pandas vytvořím pivotku, v Matplotlib grafy pro každé odvětví.  
Dále použiju regresní model pro zjištění koeficientu sklonu = slope.  
V Pythonu potom vypíšu odvětví s min(slope) tj. nejpomaleji rostoucí a max(slope) tj. nejrychleji rostoucí a přehled všech odvětví a jejich slope.
Z tohoto výstupu v Pythonu potom odpovím na otázku.

**Poznámka:** Tato otázka by šla řešit i postupem, který jsem aplikovala v otázce 3.

## Otázka 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

**Odpověď:**  
V roce 2006 je možné si z průměrné výplaty koupit 1190 kg chleba a 1360 litrů mléka.  
V roce 2018 je možné si z průměrné výplaty koupit 1242 kg chleba a 1490 litrů mléka.

**Rozšířená odpověď:**  
Jako první a poslední měřené období bereme první rok = 2006 a poslední rok = 2018.  
Můžeme říct, že na konci měření byla situace finančně přívětivější než na začátku měření.  
Lidé si v roce 2018 mohli ze své výplaty koupit více jednotek zboží než v roce 2006.

**Popis:**  
Vytvoříme CTE "podklad" s hlavními informacemi a dále pomocné CTE "roky" pro dynamické zjištění prvního a posledního období.  
Ve výsledné query potom tyto dvě CTE spojíme pouze pro požadované roky.  
Vydělením průměrné mzdy průměrnou cenou dané potraviny vypočteme hodnotu `units_affordable`, tj. kolik jednotek suroviny jsme schopni si za průměrnou výplatu koupit.  
Vypíšeme výsledné sloupce, které nás zajímají.

## Otázka 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

**Odpověď:**  
Nejpomaleji zdražuje kategorie "Cukr krystalový", cena za měřené roky dokonce klesla, a to o 2.6 %.  
Nejrychleji zdražuje kategorie "Máslo", cena za měřené roky vzrostla o 5.9 %.

**Rozšířená odpověď:**  
Obecně ceny potravin spíše rostly (mezi 0.6 % a 5.9 %).  
Pokles ceny jsme zaznamenali pouze u "Cukr krystalový" (-2.6 %) a "Rajská jablka červená kulatá" (-2.3 %).

**Popis:**  
CTE "podklad": vybírá sloupce, které budeme dále potřebovat. Počítá průměrnou cenu potravin za měřené období.  
CTE "prechody" a CTE "extremy_ceny" obě čerpají z "podklad" a počítají pomocné proměnné, které potom použijeme do vzorce geometrického průměru.  
CTE "vypis_potravin" počítá procentuální nárůst vzorcem geometrického průměru. Tento vzorec je odvozen z rovnice exponenciálního růstu.  
CTE "vypis_potravin" by už mohla být finální query, pokud bychom chtěli vypsat všechny potraviny a jejich nárůsty.  
MIN a MAX bychom potom ale museli hledat ručně. Při velkém množství dat by se nám tyto hodnoty hledaly špatně a trvalo by to dlouho.  
Proto máme ještě finální query, která hledá pouze MIN a MAX pomocí `ORDER BY` a `LIMIT 1`.  
Pro zobrazení všech kategorií s procentuálním nárůstem za měřené období stačí vymazat finální query a CTE "vypis_potravin" přeměnit na finální query.

**Poznámka:** Tato otázka by šla řešit i postupem, který jsem aplikovala v otázce 1.

## Otázka 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

**Odpověď:** Ano, existuje, je to rok 2017, kdy cena potravin vzrostla o 11 %. Naproti tomu mzdy klesly o 2 %.

**Rozšířená odpověď:**  
Špatná ekonomická situace:  
- 2017: Ceny vzrostly o 11 %, mzdy klesly o 2 %.  
- 2013: Ceny vzrostly o 6 %, mzdy klesly o 7 %.  

Dobrá ekonomická situace:  
- 2009: Ceny klesly o 6 % a mzdy vzrostly o 6 %.  
- 2014: Ceny nevzrostly (drží se stejné) a mzdy vzrostly o 6 %.  
- 2016: Ceny klesly o 2 %, mzdy vzrostly o 9 %.  
- 2018: Ceny vzrostly o 2 %, mzdy vzrostly o 13 %.

**Popis:**  
První CTE "previous" vytváří pomocí agregací sloupce průměrů za rok.  
K nim vytváří sloupec identických hodnot posunutých o řádek dolů (pomocí fce `lag`).  
Druhá CTE "differences" potom vytvoří sloupec rozdílů hodnot mezi jednotlivými roky.  
Finální query provádí výpočet procent z hodnot rozdílů. Vypíše všechny potřebné sloupce.

## Otázka 5: Má výška HDP vliv na změny ve mzdách a cenách potravin?

**Odpověď:** Ne, obecně v pozorovaných letech výraznější růst HDP nemá vliv na růst cen ani mezd. Nejde pozorovat přímá souvislost.

**Rozšířená odpověď:**  
U některých roků se může zdát, že jsou výsledky opravdu provázané, např. v roce 2007:  
- HDP vzrostlo o 6 %, ceny potravin vzrostly o 4 % a mzdy vzrostly o 6 %.  

Pokud ale máme více pozorování, tvrzení z nich nelze potvrdit, pouze vyvrátit protipříkladem:  
- 2009: HDP kleslo o 5 %, ceny potravin klesly o 6 %, ale mzdy vzrostly o 6 %.  
- 2017: HDP vzrostlo o 5 %, ceny potravin vzrostly o 11 %, ale mzdy klesly o 2 %.  

**Popis:**  
Funguje stejně jako query pro otázku 4, jen zde navíc provádíme ty stejné vzorce ještě pro HDP.  
Z tohoto výstupu v Pythonu potom odpovím na otázku.

**Poznámka:** Exaktně by se tato otázka řešila lag korelací a regresní analýzou.

