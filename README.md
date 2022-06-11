# "Eco-Visio-API"

API zum Eco-Visio-Dashboard von Eco-Counter 


# Filter

## Fahrradzähler 

**URL:** https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpageplus/{idOrganisme}

Alle Fahrradzähler eines Trägers *idOrganisme* (z.B. 4586)


**Parameter:** *withNull*

Unbekannt TODO



## Fahrradzählerdetails

**URL:** https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpageplus/data/1

Werte für einen spezifischen Fahrradzähler 


**Parameter:** *idOrganisme* 

ID eines eines Trägers *idOrganisme* (z.B. 4586)


**Parameter:** *idPdc* 

ID des Fahrradzählers (z.B. 100125116)


**Parameter:** *fin* 

Bis Datum (z.B. "26/05/2022")


**Parameter:** *debut* 

Von Datum (z.B. "26/04/2022")


**Parameter:** *interval* (mandatory)

Unbekannt TODO (z.B. 4)


**Parameter:** *flowIds* (mandatory)

'"pratique" mit ";" getrennt' (z.B. 101125116;102125116;353247560;353247561)


## Beispiel

```bash
result=$(curl -m 60 https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpageplus/4586)
```
