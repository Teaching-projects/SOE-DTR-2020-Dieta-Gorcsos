# DTR beadandó
---
## Bevezetés

A döntéstámogató rendszerek tárgy beadandóját egy diétáról írtam. Adott egy halmaz ételekkel és egy halmaz tápanyagokkal. Minden ételnél adott hogy a különböző tápanyagokból mennyit tartalmaznak . A tápanyagoknak van egy napi minimum szükséges beviteli értéke amit el kell érnie a diétának. Ahhoz hogy a karácsonyi egész napos kajálásokból felszedett pár plusz kilót könnyedén leadhassuk olyan ételeket kell ennünk, amivel a bevitt tápanyagok a minimum szükséges értékekhez a legközelebb esnek. Minden egyes diétás ételnek van egy ára amennyiért megvesszük vagy amennyiből el tudjuk készíteni. A program célja az lenne, hogy a legolcsóbb diétát hozzuk létre.

## Beviteli adatok

Elsőként egy táblázatot fogok bemutatni amely tartalmazza a különféle ételeket és az ahhoz tartozó tápanyagok értékeit. 

|  | Energia (kcal) | Szénhidrát (g) | Fehérje (g) | Zsír (g) | Cukor (g) |
| :------ | :------: | :------: | :------: | :------: | :------: |
| Csirkemell és rizs | 960 | 155 | 58 | 6 | 0 | 
| Tojásrántotta 3 tojásból | 186 | 0.55 | 6 | 18 | 0.30 |
| Hamburger | 1200 | 180 | 30 | 50 | 5 |
| Cézát saláta | 300 | 20 | 30 | 50 | 2 |
| Pizza | 1600 | 214 | 60 | 68 | 10 |
| Marhapörkölt és nokedli | 900 | 160 | 26 | 40 | 2 |
| Rántotthús és krumpli | 1100 | 175 | 40 | 35 | 1 |

Napi minimum beviteli érték, hogy fogyni tudjunk :
* Energia: 1700 kcal
* Szénhidrát: 220 gramm
* Fehérje: 120 gramm
* Zsír: 35 gramm
* Cukor: 0 gramm

Modellünk 2 halmazból áll. Egy amelyik az ételeket tartalmazza és egy amelyik a különféle tápanyagokat. 

```ampl
set Etelek;    
set Tapanyag;
```

Három paramétert kellett definiálnom. Az egyik az ételek ára/elkészítési költsége, amelyet mindegyik étel típusra kellett meghatároznom. A második paraméter a minimum napi beviteli érték a tápanyagokból ezt nyilvánvalóan a tápanyagoknál kellett meghatározni. Harmadik paraméter az ételek tartalmára vonatkozik, hogy az egyes tápanyagokból mennyit tartalmaznak.

```ampl
param Etel_ar {Etelek} >=0;  
param Szukseges {Tapanyag} >=0;    
param Tartalom {Etelek,Tapanyag} >=0;
```

Két változót vezettem be. Az egyik a ’Megesszuk’ nevű változó mely az étrendben szerepelő egyes ételek mennyiségének jelölésére szolgál. Ezt a változót az étel típusokra kellett meghatározni. Majd a második változó egy összköltség számoló. Ezzel az összköltség változóval sokkal egyszerűbb a modellünk végén a kiíratás.  

```ampl
var Megesszuk {Etelek} >=0;    
var Osszkoltseg;
```

A modellben van egy jelentős tényező amely korlátozza, hogy melyik ételek/étrendek elfogadhatóak. A korlátozás összeadja a kiválasztott étrendek tápanyagainak értéket, amely nem lehet kevesebb mint a minimális napi beviteli érték. Második korlátozást az összköltség kiszámítására hoztam létre. 

```ampl
s.t. Tapanyag_szukseglet {t in Tapanyag}:  
sum {e in Etelek} Tartalom[e,t] * Megesszuk[e] >= Szukseges[t];

s.t. Osszeskoltseg: Osszkoltseg =  
sum {e in Etelek} Etel_ar[e] * Megesszuk[e];
```

Mivel a modell célja a lehető legolcsóbb diéta elkészítése, így a célfüggvény egy minimum számítás.

```ampl
minimize Osszes_koltseg: Osszkoltseg;
```

Készítettem egy kiíratást is, melynek segítségével látható az összes költség amit elköltöttünk különféle ételekre, mely ételekből mennyit kell ennünk a diétában továbbá látható az is, hogy a tápanyagok minimum napi beviteli értékeiből mekkora az az érték amit teljesítettünk.

```ampl
printf "Összes Költség (Ft): %g\n", Osszkoltseg;  
param Tapanyagszukseglet {t in Tapanyag} :=  
sum {e in Etelek} Tartalom[e,t] * Megesszuk[e];  
for {e in Etelek}  
{  
printf "Ennyit kell ennünk ebből: %s: %g\n", e, Megesszuk[e];  
}  
for {t in Tapanyag}  
{  
printf "Szükséges napi bevitel a(z) %s - ból/ből %g amelyből teljesítettünk %g -ot \n",  
t,Szukseges[t], Tapanyagszukseglet[t];  
}
```

## Adatok feltöltése
```ampl
data;

set Etelek := Csirke Tojasrantotta Hamburger Salata Pizza Porkolt Rantotthus;  

set Tapanyag := Energia Szenhidrat Feherje Zsir Cukor;  

param Etel_ar :=  
Csirke 1200  
Tojasrantotta 600  
Hamburger 1590  
Salata 1000  
Pizza 1450  
Porkolt 1200  
Rantotthus 1300  
;

param Tartalom:
		 Energia 	Szenhidrat	 Feherje 	Zsir	 Cukor :=  
Csirke 		 960		155		 58		6	 0  
Tojasrantotta    186		0.55		 6		18	 0.30  
Hamburger	 1200		180		 30		50	 5  
Salata		 300		20		 30		10 	 2  
Pizza		 1600		214		 60		68	 10  
Porkolt	 	 900		160	 	 26		40	 2  
Rantotthus	 1100		175		 40		35	 1  
;

param Szukseges :=  
Energia 1700  
Szenhidrat 220  
Feherje 120  
Zsir 35  
Cukor 0  
;
```
## Teljes kód
```ampl
set Etelek; 
set Tapanyag;  

param Etel_ar {Etelek} >=0;  
param Szukseges {Tapanyag} >=0;  
param Tartalom {Etelek,Tapanyag} >=0;  

var megesszuk {Etelek} >=0;  
var Osszkoltseg;  

s.t. Tapanyag_szukseglet {t in Tapanyag}:  
sum {e in Etelek} Tartalom[e,t] * megesszuk[e] >= Szukseges[t];  

s.t. Osszeskoltseg: Osszkoltseg =  
sum {e in Etelek} Etel_ar[e] * megesszuk[e];  

**minimize Osszes_koltseg: Osszkoltseg;  

solve;

data;

set Etelek := Csirke Tojasrantotta Hamburger Salata Pizza Porkolt Rantotthus;  

set Tapanyag := Energia Szenhidrat Feherje Zsir Cukor;  

param Etel_ar :=  
Csirke 1200  
Tojasrantotta 600  
Hamburger 1590  
Salata 1000  
Pizza 1450  
Porkolt 1200  
Rantotthus 1300  
;

param Tartalom:
		 Energia 	Szenhidrat	 Feherje 	Zsir	 Cukor :=  
Csirke 		 960		155		 58		6	 0  
Tojasrantotta    186		0.55		 6		18	 0.30  
Hamburger	 1200		180		 30		50	 5  
Salata		 300		20		 30		10 	 2  
Pizza		 1600		214		 60		68	 10  
Porkolt	 	 900		160	 	 26		40	 2  
Rantotthus	 1100		175		 40		35	 1  
;

param Szukseges :=  
Energia 1700  
Szenhidrat 220  
Feherje 120  
Zsir 35  
Cukor 0  
;
```
## Futtatás után

Modellünk lefuttatása után optimális megoldást kapunk. 

```ampl
Problem:    beadando
Rows:       7
Columns:    8
Non-zeros:  43
Status:     OPTIMAL
Objective:  Osszes_koltseg = 2559.012277 (MINimum)


OPTIMAL LP SOLUTION FOUND
Time used:   0.0 secs
Memory used: 0.1 Mb (128932 bytes)
Összes Költség (Ft): 2559.01
Ennyit kell ennünk ebből: Csirke: 1.69085
Ennyit kell ennünk ebből: Tojasrantotta: 0
Ennyit kell ennünk ebből: Hamburger: 0
Ennyit kell ennünk ebből: Salata: 0
Ennyit kell ennünk ebből: Pizza: 0.365513
Ennyit kell ennünk ebből: Porkolt: 0
Ennyit kell ennünk ebből: Rantotthus: 0
Szükséges napi bevitel a(z) Energia - ból/ből 1700 amelyből teljesítettünk 2208.04 -ot 
Szükséges napi bevitel a(z) Szenhidrat - ból/ből 220 amelyből teljesítettünk 340.301 -ot 
Szükséges napi bevitel a(z) Feherje - ból/ből 120 amelyből teljesítettünk 120 -ot 
Szükséges napi bevitel a(z) Zsir - ból/ből 35 amelyből teljesítettünk 35 -ot 
Szükséges napi bevitel a(z) Cukor - ból/ből 0 amelyből teljesítettünk 3.65513 -ot 
Model has been successfully processed

```


Láthatjuk, hogy az egyes ételekből mennyit kell ennünk, hogy a lehető legolcsóbban fogyni tudjunk.

Megnéztem, hogy 3 étteremnél hogyan alakultak az ételek árai és az összes költség.

Az első étterem árai :
|Étel megnevezése| Ár|
|---|----|
|Csirkemell és rizs|1200|
|Tojásrántotta 3 tojásból|600|
|Hamburger|1590|
|Cézár saláta|1000|
|Pizza|1450|
|Marhapörkölt és nokedli|1200|
|Rántotthús és krumpli|1300|

Összköltség ennél az éttermnél :

```ampl
OPTIMAL LP SOLUTION FOUND
Time used:   0.0 secs
Memory used: 0.1 Mb (128932 bytes)
Összes Költség (Ft): 2559.01 
```

Második étterem árai: 
|Étel megnevezése| Ár|
|---|----|
|Csirkemell és rizs|800|
|Tojásrántotta 3 tojásból|300|
|Hamburger|1100|
|Cézár saláta|700|
|Pizza|950|
|Marhapörkölt és nokedli|1000|
|Rántotthús és krumpli|1100|

Összköltség ennél az éttermnél :

```ampl
OPTIMAL LP SOLUTION FOUND
Time used:   0.0 secs
Memory used: 0.1 Mb (128932 bytes)
Összes Költség (Ft): 1699.92
```

Harmadik étterem árai: 
|Étel megnevezése| Ár|
|---|----|
|Csirkemell és rizs|1600|
|Tojásrántotta 3 tojásból|900|
|Hamburger|1900|
|Cézár saláta|1200|
|Pizza|1800|
|Marhapörkölt és nokedli|1600|
|Rántotthús és krumpli|1300|

Összköltség ennél az éttermnél :

```ampl
OPTIMAL LP SOLUTION FOUND
Time used:   0.0 secs
Memory used: 0.1 Mb (128932 bytes)
Összes Költség (Ft): 3363.28
```

**A második étteremben tudunk a legkedvezőbben diétás ételeket enni.**
