# UI and GOV.UK Design System step definitions

Then('I should see the GOV.UK header with correct styling') do
  # Check for GOV.UK header component and its key structural classes
  expect(page).to have_css('.govuk-header', visible: true)
  expect(page).to have_css('.govuk-header__container', visible: true)
  expect(page).to have_css('.govuk-header__logotype', visible: true)
end

Then('the header should contain {string}') do |text|
  within('.govuk-header') do
    expect(page).to have_content(text)
  end
end

Then('I should see the GOV.UK footer with correct styling') do
  # Check for GOV.UK footer component and its key structural classes
  expect(page).to have_css('.govuk-footer', visible: true)
  expect(page).to have_css('.govuk-footer__meta', visible: true)
end

Then('the footer should contain {string}') do |text|
  within('.govuk-footer') do
    expect(page).to have_content(text)
  end
end

Then('the footer should contain helpful links') do
  within('.govuk-footer') do
    # Check that footer meta links are present
    expect(page).to have_css('.govuk-footer__meta-item', minimum: 1)

    # Verify expected links from the layout
    expect(page).to have_link('Cookies')
    expect(page).to have_link('Privacy')
    expect(page).to have_link('Terms and conditions')
  end
end
