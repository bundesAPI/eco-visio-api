# "Eco-Visio-API"

API zum [Eco-Visio-Dashboard](https://data.eco-counter.com/ParcPublic/?id=4586) von Eco-Counter. Eco-Counter ist ein Technikunternehmen mit Hauptsitz in Lannion, in der Bretagne. Zum Unternehmen zählen Filialen in Montreal (Kanada) und in Köln. Das Untenehmen betreibt Fahrrad- und/oder Fußgängerzähler in unterschiedlichen Ländern, die Angaben die in zahlreichen deutschen Städten z.B. "Radfahrende heute" oder "Radfahrende dieses Jahr" ausweisen. Teilweise scheinen die Zähler auch unterirdisch verlegt worden zu sein (z.B. zahlreiche Fahrradzählstellen in Hessen, vgl. https://data.eco-counter.com/ParcPublic/?id=8080). Eco-Visio ist ein Analysetool zur Auswertung der Daten. Auf dem Dashboard ("Bike Count Display Interactive Map") können die Zahlen unterschiedlicher Zähler eingesehen und verglichen werden.


<img src="https://filer.eco-counter-tools.com/file/36/abbffb1981cff24c155d40cda72890efbd4b5dfeedf05131025d2ed36128a736/14404315699570.jpg" alt="Fahrradzzähler Nürnberg" style="width:200px;"/>


# Filter

## Fahrradzähler 

**URL:** https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpageplus/{idOrganisme}

Alle Fahrradzähler eines Trägers *idOrganisme* (z.B. 4586, 20 oder 8080).


**Parameter:** *withNull*

Parameter ohne bekannten/dokumentierten Effekt.



## Fahrradzählerdetails

**URL:** https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpageplus/data/1

Werte für einen spezifischen Fahrradzählers *idPdc* (z.B. 100125116) der als GET-Parameter zu spezifizieren ist (optional auch ergänzend als Pfad-Parameter statt der 1).


**Parameter:** *idOrganisme* (mandatory)

ID des Trägers *idOrganisme* (z.B. 4586, 20 oder 8080)


**Parameter:** *idPdc* (mandatory)

ID des Fahrradzählers (z.B. 100125116)


**Parameter:** *interval* (mandatory)

- 1
- 2
- 3
- 4
- 5
- 6

Aggregationsintervall (6=Monate, 5=Wochen, 4=Tage, ...).


**Parameter:** *flowIds* (mandatory)

'"pratique" mit ";" getrennt' (z.B. 101125116;102125116;353247560;353247561)


**Parameter:** *fin* (optional)

Spätestes interessierendes Datum (z.B. "26/05/2022").


**Parameter:** *debut* (optional)

Frühestes interessierendes Datum (z.B. "01/01/2021").


## Beispiel

```bash
counter=$(curl -m 60 https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpageplus/4586)
details=$(curl -m 60 "https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpageplus/data/100125116?idOrganisme=4586&idPdc=100125116&interval=4&flowIds=101125116%3B102125116%3B353247560%3B353247561")
```
