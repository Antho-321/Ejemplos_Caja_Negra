*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

Suite Setup      Create Session    pokeapi    https://pokeapi.co/api/v2
Suite Teardown   Delete All Sessions

*** Variables ***
${VALID_POKEMON_ID_1}      1
${EXPECTED_NAME_1}         bulbasaur
${EXPECTED_TYPE_1}         grass

${VALID_POKEMON_ID_2}      4
${EXPECTED_NAME_2}         charmander
${EXPECTED_TYPE_2}         fire

*** Test Cases ***
Obtener Pokémon Válido – ID 1
    [Documentation]    Solicita el Pokémon existente (Bulbasaur) y valida campos clave.
    ${response}=    GET On Session    pokeapi    /pokemon/${VALID_POKEMON_ID_1}
    Should Be Equal As Integers      ${response.status_code}    200
    ${json}=        Convert String To Json    ${response.text}

    Dictionary Should Contain Key    ${json}    name
    Should Be Equal                  ${json['name']}            ${EXPECTED_NAME_1}

    ${first_type}=   Set Variable     ${json['types'][0]['type']['name']}
    Should Be Equal                  ${first_type}              ${EXPECTED_TYPE_1}

Obtener Pokémon Válido – ID 4
    [Documentation]    Solicita el Pokémon existente (Charmander) y valida campos clave.
    ${response}=    GET On Session    pokeapi    /pokemon/${VALID_POKEMON_ID_2}
    Should Be Equal As Integers      ${response.status_code}    200
    ${json}=        Convert String To Json    ${response.text}

    Dictionary Should Contain Key    ${json}    name
    Should Be Equal                  ${json['name']}            ${EXPECTED_NAME_2}

    ${first_type}=   Set Variable     ${json['types'][0]['type']['name']}
    Should Be Equal                  ${first_type}              ${EXPECTED_TYPE_2}
