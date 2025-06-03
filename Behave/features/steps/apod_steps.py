import requests
from behave import given, when, then
import json

@given('que tengo el endpoint APOD "{endpoint}"')
def step_given_endpoint(context, endpoint):
    context.apod_endpoint = endpoint.rstrip('/')

@given('tengo la api_key "{api_key}"')
def step_given_api_key(context, api_key):
    context.api_key = api_key

@when('pido el APOD de la fecha "{fecha}"')
def step_when_request_apod(context, fecha):
    params = {
        "date": fecha,
        "api_key": context.api_key
    }
    url = f"{context.apod_endpoint}"
    response = requests.get(url, params=params)
    context.http_response = response

    try:
        context.json_data = response.json()
    except json.JSONDecodeError:
        context.json_data = None

    print("\n📦 Cuerpo JSON recibido:")
    print(json.dumps(context.json_data, indent=2, ensure_ascii=False))
    print("─────────────────────────────────────────────────────────\n")

@then('la respuesta debe ser JSON con los campos esperados para APOD')
def step_then_validate_json(context):
    assert context.http_response.status_code == 200, \
        f"Esperaba código 200, pero obtuve {context.http_response.status_code}"

    assert isinstance(context.json_data, dict), \
        f"Respuesta no fue JSON válido: {context.http_response.text}"

    for row in context.table:
        campo = row['campo']
        assert campo in context.json_data, \
            f"Falta el campo '{campo}' en la respuesta JSON.\nJSON completo: {context.json_data}"

    date_val = context.json_data.get("date")
    assert isinstance(date_val, str) and len(date_val) == 10 and date_val.count("-") == 2, \
        f"Campo 'date' no tiene formato YYYY-MM-DD: {date_val}"

    media = context.json_data.get("media_type")
    assert media in ("image", "video"), \
        f"'media_type' debe ser 'image' o 'video', no '{media}'"

    url_val = context.json_data.get("url", "")
    assert isinstance(url_val, str) and url_val.startswith("http"), \
        f"Campo 'url' no parece una URL: {url_val}"