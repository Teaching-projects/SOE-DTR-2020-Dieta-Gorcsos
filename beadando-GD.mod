set Etelek; #�telek halmaz
set Tapanyag; #T�panyagok halmaz


param Etel_ar {Etelek}, >=0;		#Mennyibe ker�l az adott �tel (Ft)
param Szukseges {Tapanyag}, >=0;		#Napi sz�ks�ges bevitel a k�l�nf�le t�panyagokb�l
param Tartalom {Etelek,Tapanyag}, >=0;		#Az adott t�panyagokb�l mennyit tartalmaz a kaja



var megesszuk {Etelek}, >=0 ;
var Osszkoltseg;		#�sszes k�lts�g


#Korl�tozni kell mely �teleket ehetj�k meg,
s.t. Tapanyag_szukseglet {t in Tapanyag}:
sum {e in Etelek} Tartalom[e,t] * megesszuk[e] >= Szukseges[t];


s.t. Osszeskoltseg: Osszkoltseg =
sum {e in Etelek} Etel_ar[e] * megesszuk[e];

#Minim�liz�ljuk az �sszes kaja k�lts�g�t
minimize Osszes_koltseg: Osszkoltseg;


solve;

#Ki�rat�s
printf "�sszes K�lts�g (Ft): %g\n", Osszkoltseg;
param Tapanyagszukseglet {t in Tapanyag} :=
sum {e in Etelek} Tartalom[e,t] * megesszuk[e];
for {e in Etelek}
{
printf "Ennyit kell enn�nk ebb�l: %s: %g\n", e, megesszuk[e];
}
for {t in Tapanyag}
{
printf "Sz�ks�ges napi bevitel a(z) %s - b�l/b�l %g amelyb�l teljes�tett�nk %g -ot \n",
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

