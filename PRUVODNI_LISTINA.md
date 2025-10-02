# Průvodní listina k projektu 

---

## Úvod:
Tento dokument shrnuje výsledky SQL projektu zaměřeného na **analýzu mezd, cen potravin a HDP** v České republice a dalších evropských zemích v období let **2006–2018**.
Cílem projektu bylo analyzovat dostupnost základních potravin pro širokou veřejnost v České republice. 

Výsledkem jsou dvě tabulky:

- t_monika_mendlikova_project_sql_primary_final – data o mzdách a cenách potravin v ČR.  
- t_monika_mendlikova_project_sql_secondary_final – data o HDP, populaci a GINI koeficientu vybraných evropských států.


Na základě těchto tabulek byla připravena sada SQL dotazů, které odpovídají na níže definované výzkumné otázky.

---

## Výzkumné otázky a odpovědi:


## 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

Mzdy v České republice v období 2006–2018 vykazují dlouhodobě rostoucí trend ve všech sledovaných odvětvích. Ve většině sektorů se však objevují krátké meziroční poklesy, zejména 2009–2013. Tyto výkyvy souvisí s hospodářskými cykly a krizovými obdobími.

➡️Celkově však platí, že průměrné mzdy v žádném odvětví dlouhodobě neklesají a z pohledu celého sledovaného období došlo k jejich významnému růstu.


## 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední období?

V roce 2006 bylo možné za průměrnou mzdu koupit přibližně 1 312 kilogramů chleba nebo 1 466 litrů mléka, zatímco v roce 2018 už to bylo přibližně 1 365 kilogramů chleba a 1 670 litrů mléka.
Reálná kupní síla v obou případech vzrostla. U chleba jen mírně (+52 kg oproti roku 2006).
U mléka výrazněji (+204 litrů oproti roku 2006).

➡️Celkově tedy růst mezd převážil nad růstem cen těchto základních potravin.


## 3. Která kategorie potravin zdražuje nejpomaleji?  

➡️Nejnižší průměrný meziroční nárůst cen má kategorie banány žluté (0,81 %).  
To znamená, že banány v celém sledovaném období (2006–2018) rostly cenově jen velmi mírně oproti ostatním potravinám a někdy dokonce stagnovaly nebo zlevňovaly.


## 4. Existuje rok, kdy byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (>10 %)?
  
Ve sledovaném období 2007–2018 se rozdíl mezi meziročním růstem cen potravin a růstem mezd nikdy nepřehoupl přes hranici 10%. 
Největší rozdíl byl v roce 2009, kdy ceny potravin klesly o 6,4 %, zatímco mzdy stále rostly o 3 %. 
Naopak v roce 2017 se ceny zvýšily nejrychleji (+9,6 %), ale mzdy také rostly (+6,2 %), takže rozdíl byl jen 3,5.

➡️Na základě dat neexistuje žádný rok, kdy by ceny potravin rostly výrazně rychleji než mzdy. Většinou platí, že pokud ceny rostly, rostly i mzdy, pokud ceny klesaly, mzdy zpravidla pokračovaly v růstu, ale rozdíl nikdy nepřekročil stanovený limit.

## 5. Má výška HDP vliv na změny ve mzdách a cenách potravin?  

Obecně ano, růst HDP je většinou spojen s růstem mezd i cen.
Mzdy jsou stabilnější a mají tendenci růst i v letech, kdy je růst HDP slabší. Například v roce 2009 klesl HDP o -4,66 %, ale mzdy i přesto vzrostly.
Ceny potravin jsou kolísavější než mzdy. V některých letech rostly rychleji než HDP (např. 2017), v jiných stagnovaly nebo dokonce klesly i při růstu HDP (např. 2012, 2015–2016).
Výjimky přišly v roce 2009, kdy HDP kleslo, mzdy stále rostly, ceny potravin klesly. V letech 2012–2013 – smíšený vývoj, bez jasné vazby.

➡️Závěrem, HDP není jediným faktorem, který krátkodobě ovlivňuje mzdy a ceny potravin (význam hrají také světové trhy, regulace nebo smluvní závazky). Z dlouhodobého pohledu ale růst HDP obvykle souvisí s růstem mezd i cen potravin.

---

## Poznámky:
Nevážené průměry: mzdy byly počítány jako prosté průměry bez ohledu na počet zaměstnanců v jednotlivých odvětvích.  
Ceny: průměry byly počítány na národní úrovni bez regionálního vážení.  
Ekonomická data: některé státy mají chybějící roky u HDP a GINI koeficientu.

---

## Závěr:

Projekt ukazuje, že v ČR mezi lety 2006–2018 došlo k výraznému růstu mezd, který zpravidla převyšoval růst cen potravin. Díky tomu se zlepšila kupní síla obyvatel. Hospodářský růst měřený HDP se většinou odráží ve výši mezd i cen, i když krátkodobé výkyvy (např. krize 2009) mohou tento vztah narušit. Celkově lze říci, že ekonomický růst v tomto období přispěl k růstu životní úrovně.

