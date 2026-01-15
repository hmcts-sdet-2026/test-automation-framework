class BasePage
  include Capybara::DSL

  def has_text?(text)
    page.has_text?(text)
  end

  def has_error_summary?
    page.has_css?(".govuk-error-summary")
  end

  def has_govuk_header?
    page.has_css?(".govuk-header")
  end

  def has_govuk_footer?
    page.has_css?(".govuk-footer")
  end
end
