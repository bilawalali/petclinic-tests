*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Browser    http://localhost:8080    browser=firefox
Suite Teardown    Close Browser

*** Variables ***
${OWNER_URL}    http://localhost:8080/owners
${TELEPHONE_ERROR_MESSAGE}    Telephone must be a 10-digit number.


*** Test Cases ***
Search For Pet Owner Positive Scenario
    [Documentation]    Test case to search for a pet owner by last name
    Go To    ${OWNER_URL}/find
    Input Text    name=lastName    Black
    Click Button    xpath=//button[@type='submit']
    Page Should Contain    Black

Search For Pet Owner Negative Scenario
    [Documentation]    Test case to search for a pet owner by last name
    Go To    ${OWNER_URL}/find
    Input Text    name=lastName    HelloWorld
    Click Button    xpath=//button[@type='submit']
    Page should not contain  HelloWorld


Create New Pet Owner Negative Scenario
    [Documentation]    Test case to create a new pet owner and validate telephone number (Negative Case)
    Go To    ${OWNER_URL}/new
    Input Text    name=firstName    Bilawal
    Input Text    name=lastName    Ali
    Input Text    name=address    TestStraße123
    Input Text    name=city    Dortmund
    Input Text    name=telephone    0800120
    ${telephone}=    Get Value    name=telephone
    ${is_valid}=    Evaluate    len("${telephone}") == 10 and "${telephone}".isdigit()
    Run Keyword If    not ${is_valid}    Fail    The telephone number should be of 10 digits.
    Click Button    xpath=//button[@type='submit']
    Should Contain      ${TELEPHONE_ERROR_MESSAGE}

Create New Pet Owner Positive Scenario
    [Documentation]    Test case to create a new pet owner and validate telephone number (Positive Case)
    Go To    ${OWNER_URL}/new
    Input Text    name=firstName    Bilawal
    Input Text    name=lastName    Ali
    Input Text    name=address    TestStraße123
    Input Text    name=city    Dortmund
    Input Text    name=telephone    1234567891
    ${telephone}=    Get Value    name=telephone
    ${is_valid}=    Evaluate    len("${telephone}") == 10 and "${telephone}".isdigit()
    Run Keyword If    not ${is_valid}    Fail    The telephone number should be of 10 digits.
    Click Button    xpath=//button[@type='submit']

Search For Pet Owner Successfully Created
    [Documentation]    Test case to search for a pet owner by last name
    Go To    ${OWNER_URL}/find
    Input Text    name=lastName    Black
    Click Button    xpath=//button[@type='submit']
    Page Should Contain    Ali


Create New Pet For Owner
    [Documentation]    Test case to create a new pet for an existing owner
    Go To    ${OWNER_URL}/2/pets/new
    Input Text    name=name    NewPetTest
    Input Text    name=birthDate    2022-01-02
    Select From List By Value    name=type    dog
    Click Button    xpath=//button[@type='submit']
    Page Should Contain    New Pet has been Added

Update Created Pet For Owner
    [Documentation]    Test case to create a new pet for an existing owner
    Go To    ${OWNER_URL}/2/pets/17/edit
    Input Text    name=name    NewPetTest
    Input Text    name=birthDate    2022-01-02
    Select From List By Value    name=type    bird
    Click Button    xpath=//button[@type='submit']
    Page Should Contain    Pet details has been edited

Add New Visit For Pet
    [Documentation]    Test case to add a new visit for a pet
    Go To    ${OWNER_URL}/2/pets/2/visits/new
    Input Text    name=date    2023-07-21
    Input Text    name=description    Normal Checkup
    Click Button    xpath=//button[@type='submit']
    Page Should Contain   Your visit has been booked