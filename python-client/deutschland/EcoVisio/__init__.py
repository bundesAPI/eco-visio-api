# flake8: noqa

"""
    Eco-Counter: Eco-Visio-API

    API zum [Eco-Visio-Dashboard](https://data.eco-counter.com/ParcPublic/?id=4586) von Eco-Counter. Eco-Counter ist ein Technologieunternehmen mit Hauptsitz in Lannion, in der Bretagne. Zum Unternehmen zählen Filialen in Montreal (Kanada) und in Köln. Das Untenehmen betreibt u.a. Fahrrad- und Fußgängerzähler in unterschiedlichen Ländern, die in zahlreichen deutschen Städten z.B. Angaben wie \"Radfahrende heute\" oder \"Radfahrende dieses Jahr\" ausweisen. Teilweise sind die Zähler auch vollständig unterirdisch verlegt worden (z.B. zahlreiche Fahrradzählstellen in Hessen, vgl. https://data.eco-counter.com/ParcPublic/?id=8080).   Generell findet man in Deutschland überwiegend Fahrradzähler. In Rostock gibt es daneben auch Fußgängerzähler (https://data.eco-counter.com/ParcPublic/?id=888), ebenso in Schwerin (https://data.eco-counter.com/ParcPublic/?id=6116), in Greifswald (https://data.eco-counter.com/ParcPublic/?id=6997) oder in Böblingen (https://data.eco-counter.com/ParcPublic/?id=6811). In Ludwigsburg gibt es sogar separat ausgewiesene Autozähler von Eco-Counter (https://data.eco-counter.com/ParcPublic/?id=6011).   Eco-Visio ist ein Analysetool zur Auswertung der Daten. Die Daten zahlreicher (aber nicht aller) Zähler sind öffentlich einsehbar (Option 'publicwebpage'), teilweise gruppiert nach Träger/Organisation/Domäne (Option 'publicwebpageplus'). Der Zugriff auf nicht-öffentlich einsehbare Zähler erfolgt über die [Eco-Counter API](https://raw.githubusercontent.com/bundesAPI/eco-visio-api/main/openapi_Eco-Counter_v1.1.yaml) auf die auf [https://developers.eco-counter.com/](https://developers.eco-counter.com/) beschriebene Weise.    # noqa: E501

    The version of the OpenAPI document: 1.0.0
    Contact: kontakt@bund.dev
    Generated by: https://openapi-generator.tech
"""


__version__ = "0.1.0"

# import ApiClient
from deutschland.EcoVisio.api_client import ApiClient

# import Configuration
from deutschland.EcoVisio.configuration import Configuration

# import exceptions
from deutschland.EcoVisio.exceptions import (
    ApiAttributeError,
    ApiException,
    ApiKeyError,
    ApiTypeError,
    ApiValueError,
    OpenApiException,
)
