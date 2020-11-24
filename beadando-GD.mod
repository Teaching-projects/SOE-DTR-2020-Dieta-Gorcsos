set Etelek; #Ételek halmaz
set Tapanyag; #Tápanyagok halmaz


param Etel_ar {Etelek} >=0;		#Mennyibe kerül az adott étel (Ft)
param Szukseges {Tapanyag} >=0;		#Napi szükséges bevitel a különféle tápanyagokból
param Tartalom {Etelek,Tapanyag} >=0;		#Az adott tápanyagokból mennyit tartalmaz a kaja



var Megesszuk {Etelek} >=0 ;
var Osszkoltseg;		#Összes költség


#Korlátozni kell mely ételeket ehetjük meg,
s.t. Tapanyag_szukseglet {t in Tapanyag}:
sum {e in Etelek} Tartalom[e,t] * Megesszuk[e] >= Szukseges[t];


s.t. Osszeskoltseg: Osszkoltseg =
sum {e in Etelek} Etel_ar[e] * Megesszuk[e];

#Minimálizáljuk az összes kaja költségét
minimize Osszes_koltseg: Osszkoltseg;


solve;

#Kiíratás
printf "Összes Költség (Ft): %g\n", Osszkoltseg;
param Tapanyagszukseglet {t in Tapanyag} :=
sum {e in Etelek} Tartalom[e,t] * Megesszuk[e];
for {e in Etelek}
{
printf "Ennyit kell ennünk ebből - %s: %g\n", e, Megesszuk[e];
}
for {t in Tapanyag}
{
printf "Szükséges napi bevitel a(z) %s - ból/ből %g amelyből teljesítettünk %g -ot \n",
t,Szukseges[t], Tapanyagszukseglet[t];
}

#Adatok 
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
					Energia 	Szenhidrat		Feherje 	Zsir	Cukor :=
Csirke 		960			155				58			6		0
Tojasrantotta		186			0.55			6			18		0.30
Hamburger			1200		180				30			50		5
Salata				300			20				30			10		2
Pizza				1600		214				60			68		10
Porkolt				900			160				26			40		2
Rantotthus		1100		175				40			35		1
;

param Szukseges :=
Energia 1700
Szenhidrat 220
Feherje 120
Zsir 35
Cukor 0
;

