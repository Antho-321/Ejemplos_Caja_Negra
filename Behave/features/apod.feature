Feature: Validar la API de APOD de NASA
  Para asegurar que la API de “Astronomy Picture of the Day”:
    • Responda correctamente con código 200.
    • Devuelva un JSON bien formado.
    • Contenga todos los campos esperados para una entrada de APOD.
    • Verifique que ciertos valores (fecha, tipo de medio, URL) cumplan un formato básico.

  Background:
    Given que tengo el endpoint APOD "https://api.nasa.gov/planetary/apod"
    And tengo la api_key "DEMO_KEY"

  Scenario: Solicitar el APOD de la fecha 2022-01-01
    When pido el APOD de la fecha "2022-01-01"
    Then la respuesta debe ser JSON con los campos esperados para APOD
      | campo            |
      | date             |
      | explanation      |
      | hdurl            |
      | media_type       |
      | service_version  |
      | title            |
      | url              |
