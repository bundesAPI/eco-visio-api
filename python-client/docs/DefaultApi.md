# EcoVisio.DefaultApi

All URIs are relative to *https://www.eco-visio.net/api/aladdin/1.0.0*

Method | HTTP request | Description
------------- | ------------- | -------------
[**zaehler**](DefaultApi.md#zaehler) | **GET** /pbl/publicwebpageplus/{idOrganisme} | Zähler
[**zaehlerdaten**](DefaultApi.md#zaehlerdaten) | **GET** /pbl/publicwebpageplus/data/1 | Zählerdaten


# **zaehler**
> AllCounter zaehler()

Zähler

Alle Zähler eines Trägers mit ID idOrganisme (z.B. 4586, 20 oder 8080). Eine Übersicht über gültige Ausprägungen des Parameters idOrganisme und deren Bedeutung gibt die Tabelle [hier](https://github.com/bundesAPI/eco-visio-api/blob/main/eco-visio-api.csv) (Stand 07.09.2022). Einige idOrganisme sind deutschen Bundesländern und Städten zugeordnet: 8080=Hessen, 6365=Mecklenburg-Vorpommern, 4728=Berlin, 677=Köln, 4701=Bonn, 6011=Ludwigsburg, 4206=Heidelberg, 607=Stuttgart, 4702=Rhein-Sieg-Kreis, 857=Düsseldorf, 888=Rostock, 5417=Augsburg, 5972=Leipzig, 7119=Bielefeld, 4197=Mannheim, 7581=Reutlingen, 7224=Hürth, 4729=Würzburg, 7241=Norderstedt, 751=Freiburg, 6109=Oberbergischer Kreis und Rheinisch-Bergischer Kreis, 4699=Rheinisch-Bergischer Kreis und Oberbergischer Kreis, 6076=Oberhausen, 6116=Schwerin, 7642=Leverkusen, 6135=Goslar, 6997=Greifswald, 6471=Ludwigshafen, 7058=Siegen, 4626=Essen, 6603=Bochum, 6481=Aschaffenburg, 6811=Böblingen, 6150=Dortmund.   Außerdem sind Zähler in deutschen Städten ausgewiesen unter idOrganisme 4586 (='Bike Count Display Interactive Map') und 5024 (='National Database Demo'). 

### Example


```python
import time
from deutschland import EcoVisio
from deutschland.EcoVisio.api import default_api
from deutschland.EcoVisio.model.all_counter import AllCounter
from pprint import pprint
# Defining the host is optional and defaults to https://www.eco-visio.net/api/aladdin/1.0.0
# See configuration.py for a list of all supported configuration parameters.
configuration = EcoVisio.Configuration(
    host = "https://www.eco-visio.net/api/aladdin/1.0.0"
)


# Enter a context with an instance of the API client
with EcoVisio.ApiClient() as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    with_null = True # bool | Parameter ohne bekannten/dokumentierten Effekt. (optional)
    end = "26/05/2022" # str | Spätestes interessierendes Datum (z.B. 26/05/2022). (optional)
    begin = "01/01/2021" # str | Frühestes interessierendes Datum (z.B. 01/01/2021). (optional)
    pratique = 1 # int | pratique i.S.v. interessierende Zählerart (z.B. 1=Fußgänger,2=Fahrräder, oder 12=Sternchen) (optional)

    # example passing only required values which don't have defaults set
    try:
        # Zähler
        api_response = api_instance.zaehler()
        pprint(api_response)
    except EcoVisio.ApiException as e:
        print("Exception when calling DefaultApi->zaehler: %s\n" % e)

    # example passing only required values which don't have defaults set
    # and optional values
    try:
        # Zähler
        api_response = api_instance.zaehler(with_null=with_null, end=end, begin=begin, pratique=pratique)
        pprint(api_response)
    except EcoVisio.ApiException as e:
        print("Exception when calling DefaultApi->zaehler: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id_organisme** | **int**| Träger ID | defaults to 4586
 **with_null** | **bool**| Parameter ohne bekannten/dokumentierten Effekt. | [optional]
 **end** | **str**| Spätestes interessierendes Datum (z.B. 26/05/2022). | [optional]
 **begin** | **str**| Frühestes interessierendes Datum (z.B. 01/01/2021). | [optional]
 **pratique** | **int**| pratique i.S.v. interessierende Zählerart (z.B. 1&#x3D;Fußgänger,2&#x3D;Fahrräder, oder 12&#x3D;Sternchen) | [optional]

### Return type

[**AllCounter**](AllCounter.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | OK |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **zaehlerdaten**
> [str] zaehlerdaten(id_pdc, interval, flow_ids)

Zählerdaten

Werte für einen spezifischen Fahrradzählers mit ID idPdc (z.B. 100125116) der als GET-Parameter zu spezifizieren ist (optional auch ergänzend als Pfad-Parameter statt der 1).

### Example


```python
import time
from deutschland import EcoVisio
from deutschland.EcoVisio.api import default_api
from pprint import pprint
# Defining the host is optional and defaults to https://www.eco-visio.net/api/aladdin/1.0.0
# See configuration.py for a list of all supported configuration parameters.
configuration = EcoVisio.Configuration(
    host = "https://www.eco-visio.net/api/aladdin/1.0.0"
)


# Enter a context with an instance of the API client
with EcoVisio.ApiClient() as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    id_pdc = 100125116 # int | ID des Fahrradzählers
    interval = 4 # int | Aggregationsintervall (6=Monate, 5=Wochen, 4=Tage, 3=Stunden, 2=Viertelstunden, 1=?).
    flow_ids = "101125116;102125116;353247560;353247561" # str | pratique-ID mit Semikolon getrennt
    fin = Date("26/05/2022") # Date | Spätestes interessierendes Datum (z.B. '26/05/2022'). (optional)
    debut = Date("26/04/2021") # Date | Frühestes interessierendes Datum (z.B. '01/01/2021'). (optional)

    # example passing only required values which don't have defaults set
    try:
        # Zählerdaten
        api_response = api_instance.zaehlerdaten(id_pdc, interval, flow_ids)
        pprint(api_response)
    except EcoVisio.ApiException as e:
        print("Exception when calling DefaultApi->zaehlerdaten: %s\n" % e)

    # example passing only required values which don't have defaults set
    # and optional values
    try:
        # Zählerdaten
        api_response = api_instance.zaehlerdaten(id_pdc, interval, flow_ids, fin=fin, debut=debut)
        pprint(api_response)
    except EcoVisio.ApiException as e:
        print("Exception when calling DefaultApi->zaehlerdaten: %s\n" % e)
```


### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id_pdc** | **int**| ID des Fahrradzählers |
 **interval** | **int**| Aggregationsintervall (6&#x3D;Monate, 5&#x3D;Wochen, 4&#x3D;Tage, 3&#x3D;Stunden, 2&#x3D;Viertelstunden, 1&#x3D;?). |
 **flow_ids** | **str**| pratique-ID mit Semikolon getrennt |
 **id_organisme** | **int**| Träger ID | defaults to 4586
 **fin** | **Date**| Spätestes interessierendes Datum (z.B. &#39;26/05/2022&#39;). | [optional]
 **debut** | **Date**| Frühestes interessierendes Datum (z.B. &#39;01/01/2021&#39;). | [optional]

### Return type

**[str]**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | OK |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

