# Eco-Visio API

API zum [Eco-Visio-Dashboard](https://data.eco-counter.com/ParcPublic/?id=4586) von Eco-Counter. 

Eco-Counter ist ein Technologieunternehmen mit Hauptsitz in Lannion, in der Bretagne. Zum Unternehmen zählen Filialen in Montreal (Kanada) und in Köln. Das Untenehmen betreibt u.a. Fahrrad- und Fußgängerzähler in unterschiedlichen Ländern, die in zahlreichen deutschen Städten z.B. Angaben wie "Radfahrende heute" oder "Radfahrende dieses Jahr" ausweisen. Teilweise sind die Zähler auch vollständig unterirdisch verlegt worden (z.B. zahlreiche Fahrradzählstellen in Hessen, vgl. https://data.eco-counter.com/ParcPublic/?id=8080). 

Generell findet man in Deutschland überwiegend Fahrradzähler. In Rostock gibt es daneben auch Fußgängerzähler (https://data.eco-counter.com/ParcPublic/?id=888), ebenso in Schwerin (https://data.eco-counter.com/ParcPublic/?id=6116), in Greifswald (https://data.eco-counter.com/ParcPublic/?id=6997) oder in Böblingen (https://data.eco-counter.com/ParcPublic/?id=6811). In Ludwigsburg gibt es sogar separat ausgewiesene Autozähler von Eco-Counter (https://data.eco-counter.com/ParcPublic/?id=6011).

Eco-Visio ist ein Analysetool zur Auswertung der Daten. Die Daten zahlreicher (aber nicht aller) Zähler sind öffentlich einsehbar (Option 'publicwebpage'), teilweise gruppiert nach Träger/Organisation/Domäne (Option 'publicwebpageplus').


<img src="https://filer.eco-counter-tools.com/file/36/abbffb1981cff24c155d40cda72890efbd4b5dfeedf05131025d2ed36128a736/14404315699570.jpg" alt="Fahrradzzähler Nürnberg" style="width:200px;"/>


## Publicwebpageplus 

**URL:** https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpageplus/{idOrganisme}

Alle Zähler eines Trägers mit ID *idOrganisme* (z.B. 4586, 20 oder 8080). Eine Übersicht über gültige Ausprägungen des Parameters *idOrganisme* und deren Bedeutung gibt die Tabelle [hier](https://github.com/AndreasFischer1985/eco-visio-api/blob/main/eco-visio-api.csv) (Stand 07.09.2022).


Einige *idOrganisme* sind deutschen Bundesländern und Städten zugeordnet:

8080=Hessen, 6365=Mecklenburg-Vorpommern,
4728=Berlin, 677=Köln, 4701=Bonn, 6011=Ludwigsburg, 4206=Heidelberg, 
607=Stuttgart, 4702=Rhein-Sieg-Kreis, 857=Düsseldorf, 888=Rostock, 
5417=Augsburg, 5972=Leipzig, 7119=Bielefeld, 4197=Mannheim, 7581=Reutlingen, 
7224=Hürth, 4729=Würzburg, 7241=Norderstedt, 751=Freiburg, 6109=Oberbergischer Kreis und Rheinisch-Bergischer Kreis,
4699=Rheinisch-Bergischer Kreis und Oberbergischer Kreis, 
6076=Oberhausen, 6116=Schwerin, 7642=Leverkusen, 
6135=Goslar, 6997=Greifswald, 6471=Ludwigshafen, 7058=Siegen, 
4626=Essen, 6603=Bochum, 6481=Aschaffenburg, 6811=Böblingen, 6150=Dortmund.

Außerdem sind Zähler in deutschen Städten ausgewiesen unter *idOrganisme* 4586 (="Bike Count Display Interactive Map") und 5024 (="National Database Demo").


### Parameter

**Parameter:** *withNull*

Parameter ohne bekannten/dokumentierten Effekt.


**Parameter:** *end* (optional)

Spätestes interessierendes Datum (z.B. "26/05/2022").


**Parameter:** *begin* (optional)

Frühestes interessierendes Datum (z.B. "01/01/2021").


**Parameter:** *pratique* (optional)

"pratique" i.S.v. Beschränkung auf interessierende Zählerart (z.B. 1=Fußgänger, 2=Fahrräder, 4=Autos, oder 12=Sternchen).


### Beispiel

```bash
counters=$(curl -m 60 https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpageplus/4586)
```


## Zählerdaten

**URL:** https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpageplus/data/1

Werte für einen spezifischen Zähler mit ID *idPdc* (z.B. 100125116) der als GET-Parameter zu spezifizieren ist (optional auch ergänzend als Pfad-Parameter statt der 1).


### Parameter

**Parameter:** *idOrganisme* (mandatory)

ID des Trägers (z.B. 4586, 20 oder 8080)


**Parameter:** *idPdc* (mandatory)

ID des Zählers (z.B. 100125116)


**Parameter:** *interval* (mandatory)

- 1
- 2
- 3
- 4
- 5
- 6

Aggregationsintervall (6=Monate, 5=Wochen, 4=Tage, 3=Stunden, 2=Viertelstunden, 1=?).


**Parameter:** *flowIds* (mandatory)

pratique-ID, ggf. mehrere mit Semikolon getrennt' (z.B. 101125116;102125116;353247560;353247561).


**Parameter:** *fin* (optional)

Spätestes interessierendes Datum (z.B. "26/05/2022").


**Parameter:** *debut* (optional)

Frühestes interessierendes Datum (z.B. "01/01/2021").


### Beispiel

```bash
data=$(curl -m 60 "https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpageplus/data/100125116?idOrganisme=4586&idPdc=100125116&interval=4&flowIds=101125116%3B102125116%3B353247560%3B353247561")
```


## Publicwebpage 

**URL:** https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpage/{idPdc}

Metadaten zu ausgewählten Zählern auf Basis der idPdc (z.B. 100063085).


**URL:** https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpage/data/{idPdc}

Zählerdaten zu ausgewählten Zählern auf Basis der idPdc (z.B. 100063085).


**Parameter:** *begin* 

Frühestes interessierendes Datum (z.B. "20201001")


**Parameter:** *end* 

Spätestes interessierendes Datum (z.B. 20221027)


**Parameter:** *step* 

Interval (z.B. 4).


**Parameter:** *domain*

idOrganisme (z.B. 7242).


**Parameter:** *withNull*

Anzeige unspezifizierter Werte (z.B.true)


**Parameter:** *t*

Token (z.B. 81ee145d681ec7d08a28a037257117634ff718053a5e6f639948583cf3fb0f8b)


**URL:** https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpage/stats/{idPdc}

Statistiken zu ausgewählten Zählern auf Basis der idPdc (z.B. 100063085).


**Parameter:** *begin* 

Frühestes interessierendes Datum (z.B. "20201001")


**Parameter:** *end* 

Spätestes interessierendes Datum (z.B. 20221027)


**Parameter:** *step* 

Interval (z.B. 4).


**Parameter:** *domain*

idOrganisme (z.B. 7242).


**Parameter:** *withNull*

Anzeige unspezifizierter Werte (z.B.true)


**Parameter:** *t*

Token (z.B. 81ee145d681ec7d08a28a037257117634ff718053a5e6f639948583cf3fb0f8b)

