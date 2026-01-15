Feature: UI and GOV.UK Design System
    As a user
    I want the interface to follow GOV.UK Design System standards
    So that the application is consistent with government services

    @ui @govuk @smoke
    Scenario: GOV.UK Design System components are present
        Given I am on the login page
        Then I should see the GOV.UK header with correct styling
        And the header should contain "GOV.UK"
        And the header should contain "HMCTS Login Test"
        And I should see the GOV.UK footer with correct styling
        And the footer should contain "Open Government Licence"
        And the footer should contain helpful links

