*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Browser    http://localhost:8080    browser=firefox
Suite Teardown    Close Browser

*** Variables ***
${OWNER_URL}    http://localhost:8080/owners
${OWNER_ID}    4
${TELEPHONE_ERROR_MESSAGE}    Telephone must be a 10-digit number


*** Test Cases ***
Test 1 Search For Pet Owner Positive Scenario
    [Documentation]    Test case to search for a pet owner by last name
    Go To    ${OWNER_URL}/find
    Input Text    name=lastName    Black
    Click Button    xpath=//button[@type='submit']
    Page Should Contain    Black

Test 2 Search For Pet Owner Negative Scenario
    [Documentation]    Test case to search for a pet owner by last name
    Go To    ${OWNER_URL}/find
    Input Text    name=lastName    HelloWorld
    Click Button    xpath=//button[@type='submit']
    Page should not contain  HelloWorld


Test 3 Create New Pet Owner Negative Scenario
    [Documentation]    Test case to create a new pet owner and validate telephone number (Negative Case)

    Go To    ${OWNER_URL}/new
    Input Text    name=firstName    Bilawal
    Input Text    name=lastName    Ali
    Input Text    name=address    TestStraße123
    Input Text    name=city    Dortmund
    Input Text    name=telephone    123456789789456123

    # Submit the form
    Click Button    xpath=//button[@type='submit']

    # Verify the error message is displayed
    Page Should Contain    ${TELEPHONE_ERROR_MESSAGE}

Test 4 Create New Pet Owner Positive Scenario
    [Documentation]    Test case to create a new pet owner and validate telephone number (Positive Case)
    Go To    ${OWNER_URL}/new
    Input Text    name=firstName    Bilawal
    Input Text    name=lastName    Ali
    Input Text    name=address    TestStraße123
    Input Text    name=city    Dortmund
    Input Text    name=telephone    12345678912
    ${telephone}=    Get Value    name=telephone
    ${is_valid}=    Evaluate    len("${telephone}") == 10 and "${telephone}".isdigit()
    Click Button    xpath=//button[@type='submit']



Test 5 Create New Pet For Owner
    [Documentation]    Test case to create a new pet for an existing owner
    Go To    ${OWNER_URL}/${OWNER_ID}/pets/new
    Input Text    name=name    NewPet123456
    Input Text    name=birthDate    2022-01-02
    Select From List By Value    name=type    dog
    Click Button    xpath=//button[@type='submit']
    Page Should Contain         New Pet has been Added

Test 6 Update Created Pet For Owner
    [Documentation]    Test case to create a new pet for an existing owner
    Go To    ${OWNER_URL}/2/pets/17/edit
    Input Text    name=name    NewPetTest
    Input Text    name=birthDate    2022-01-02
    Select From List By Value    name=type    bird
    Click Button    xpath=//button[@type='submit']
    Page Should Contain    Pet details has been edited

Test 7 Add New Visit For Pet
    [Documentation]    Test case to add a new visit for a pet
    Go To    ${OWNER_URL}/2/pets/2/visits/new
    Input Text    name=date    2023-07-21
    Input Text    name=description    Normal Checkup
    Click Button    xpath=//button[@type='submit']
    Page Should Contain   Your visit has been booked