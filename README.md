# HMCTS Test Automation Framework

> Comprehensive test automation framework for Rails 8 Authentication - HMCTS Senior Developer in Test Assessment

[![CI](https://github.com/YOUR_USERNAME/test-automation-framework/workflows/CI/badge.svg)](https://github.com/YOUR_USERNAME/test-automation-framework/actions)

## Table of Contents

- [Overview](#overview)
- [Technology Stack](#technology-stack)
- [Quick Start](#quick-start)
- [Running Tests](#running-tests)
- [Viewing Test Reports](#viewing-test-reports)
- [Test Coverage](#test-coverage)
- [Design Decisions](#design-decisions)
- [CI/CD Pipeline](#cicd-pipeline)
- [Project Structure](#project-structure)
- [Future Improvements](#future-improvements)

## Overview

This project demonstrates a production-ready test automation framework for login functionality, implementing multiple testing layers and modern best practices for government digital services.

### Why Rails Instead of Java/Spring Boot?

The job specification mentions Java, Spring Framework, and Angular/React. I initially explored the [HMCTS Spring Boot template](https://github.com/hmcts/spring-boot-template) to align with your production stack, but encountered environment setup challenges (private Docker image dependencies) that would have consumed significant assessment time.

**Strategic decision**: Rather than troubleshoot infrastructure, I chose Rails 8 (released December 2024) to focus on demonstrating **test automation expertise** over language-specific syntax.

**What this demonstrates**:

✅ **Transferable testing skills**: Page Objects, BDD, multi-layer testing, and CI/CD principles apply across any tech stack
✅ **Modern architecture understanding**: Rails 8 authentication mirrors Spring Security patterns (session management, CSRF protection, rate limiting)
✅ **Production-grade focus**: Testing real authentication with security features, not toy examples
✅ **Pragmatic decision-making**: Maximized assessment value by removing blockers
✅ **Domain exploration**: Opportunity to test GOV.UK Design System components (forms, error summaries, accessibility patterns) which are new to me and directly relevant to HMCTS digital services. At the DVLA the services I tested are all internal.

**Direct Java/Spring equivalents**:
- **Page Object Model** → Same pattern with Selenium Java
- **RSpec request specs** → Spring MockMvc / RestAssured tests
- **Cucumber BDD** → Identical Gherkin syntax across languages
- **axe-core accessibility** → Same library, Java bindings available
- **GitHub Actions CI** → Framework-agnostic YAML configuration

I'm confident this framework demonstrates the senior-level testing expertise you're seeking, with skills that translate directly to your Java/Spring/Angular stack.

**Additional motivation**: I wanted to explore the GOV.UK Design System (forms, components, accessibility patterns) which I hadn't used before. Since HMCTS uses this in production, it provided domain-relevant learning while building realistic test scenarios. The experience of testing government-standard components adds direct value for this role.

### Why Rails 8 Authentication?

I chose to test Rails 8's built-in authentication (released December 2024) to provide realistic, production-grade test scenarios including:

- ✅ Security features (rate limiting, CSRF protection, secure sessions)
- ✅ Form validation and error handling
- ✅ Session persistence across requests
- ✅ GOV.UK Design System integration (domain-relevant for HMCTS)
- ✅ Accessibility compliance (WCAG 2.1 AA required for UK government services)

This provides more comprehensive testing challenges than a basic HTML form. Also, this is new to me as previously I've used third party authentication libraries with Rails.

## 🛠 Technology Stack

| Layer                  | Technology                              | Purpose                        |
| ---------------------- | --------------------------------------- | ------------------------------ |
| **Language**           | Ruby 3.3.6                              | Programming language           |
| **Framework**          | Rails 8.1.1                             | Web application framework      |
| **BDD Testing**        | Cucumber 9.2.0                          | Feature-level behavior testing |
| **Unit/Integration**   | RSpec 7.1                               | Request specs and unit tests   |
| **Browser Automation** | Capybara 3.40 + Selenium WebDriver 4.27 | UI interaction                 |
| **Design Pattern**     | Page Object Model                       | Test maintainability           |
| **UI Framework**       | GOV.UK Design System 5.6.0              | Government-standard components |
| **Accessibility**      | axe-core 4.10                           | WCAG 2.1 AA compliance testing |
| **Database**           | SQLite3                                 | Lightweight database for tests |
| **CI/CD**              | GitHub Actions                          | Automated testing pipeline     |

## Quick Start

### Prerequisites

- Ruby 3.3.6 (use `rbenv` or `rvm`)
- Bundler 2.x
- SQLite3
- Chrome/Chromium browser (for feature tests)

### Installation

```bash
# 1. Clone the repository
git clone <repository-url>
cd hmcts

# 2. Install dependencies
bundle install

# 3. Setup database
bin/rails db:create db:migrate db:seed

# 4. Verify installation
bin/rails server
# Visit http://localhost:3000/session/new
```

### Test Users

Seeded test accounts (see `db/seeds.rb`):

| Email         | Password    | Notes         |
| ------------- | ----------- | ------------- |
| test@test.com | password123 | Standard user |

## Running Tests

### Run All Tests

```bash
# Run entire test suite
bundle exec rspec && bundle exec cucumber
```

### Run Test Layers Individually

#### 1. Request/Integration Specs (Fast - ~0.2s)

Tests HTTP layer without browser:

```bash
# All request specs
bundle exec rspec spec/requests

# Specific spec file
bundle exec rspec spec/requests/sessions_spec.rb

# With documentation format
bundle exec rspec spec/requests --format documentation
```

**What's tested**: HTTP status codes, redirects, session cookies, rate limiting, CSRF protection

#### 2. Accessibility Specs (Fast - ~2.5s)

Tests WCAG 2.1 AA compliance:

```bash
# All accessibility specs
bundle exec rspec spec/features/accessibility_spec.rb

# With detailed output
bundle exec rspec spec/features/accessibility_spec.rb --format documentation
```

**What's tested**: Color contrast, form labels, ARIA attributes, keyboard navigation, GOV.UK component accessibility

#### 3. Cucumber Feature Tests (Slower - ~45s)

Tests user-facing behavior with browser:

```bash
# All features
bundle exec cucumber

# Specific feature
bundle exec cucumber features/login.feature

# Specific scenario by line number
bundle exec cucumber features/login.feature:12

# Pretty format
bundle exec cucumber --format pretty
```

**What's tested**: Complete user workflows, UI rendering, JavaScript interactions, cross-browser compatibility

### Run with HTML Reports

```bash
# Generate HTML test reports
mkdir -p reports

# RSpec reports
bundle exec rspec spec/requests --format html --out reports/rspec-requests.html

# Cucumber reports
bundle exec cucumber --format html --out reports/cucumber.html

# Open reports
open reports/*.html
```

## Viewing Test Reports

### GitHub Pages (CI Reports)

All test reports from CI runs are automatically published to GitHub Pages:

**📊 Latest Reports:**
```
https://hmcts-sdet-2026.github.io/test-automation-framework/test-reports-index.html
```

**Individual Report Types:**
- **Cucumber BDD Tests**: Feature-level acceptance tests with scenario results
- **RSpec Request Specs**: Controller/API integration test results
- **Accessibility Tests**: WCAG 2.1 AA compliance report with axe-core

Each CI run on the `main` branch generates a new report set accessible at:
```
https://hmcts-sdet-2026.github.io/test-automation-framework/test-reports/<run-number>/index.html
```

**Features:**
- ✅ Persistent report history (30 days in GitHub Actions Artifacts)
- ✅ Browsable index page listing all test runs
- ✅ Direct links to Cucumber HTML, RSpec HTML, and Accessibility reports
- ✅ Commit SHA and timestamp for each run
- ✅ Publicly accessible for sharing with stakeholders

## Test Coverage

### Testing Pyramid

```
        /\         Feature Tests (Cucumber)
       /  \        10 scenarios - User workflows
      /    \       ~45s execution time
     /------\
    /        \     Request Specs (RSpec)
   /          \    29 tests - HTTP/API layer
  /            \   ~0.2s execution time
 /--------------\
/                \ Accessibility Tests (RSpec)
------------------5 tests - WCAG compliance
                  ~2.5s execution time
```

### What's Tested

#### ✅ Positive Scenarios
- Successful login with valid credentials
- Session creation and cookie management
- Homepage access after authentication
- Logout functionality

#### ✅ Negative Scenarios
- Invalid email format validation
- Empty field validation
- Wrong password handling
- Non-existent user handling
- Generic error messages (prevents email enumeration)

#### ✅ Security Features
- Rate limiting (10 attempts per 3 minutes)
- CSRF protection enabled
- Session cookie attributes (HttpOnly, Secure, SameSite)
- Email enumeration prevention

#### ✅ Accessibility
- WCAG 2.1 AA compliance for login page
- WCAG 2.1 AA compliance for authenticated homepage
- GOV.UK error summary accessibility
- Form validation error accessibility

#### ✅ GOV.UK Design System
- Form components rendering
- Error summary pattern
- Header and footer components

### Test Statistics

- **Total Tests**: 44 (29 RSpec + 10 Cucumber scenarios + 5 accessibility)
- **Execution Time**: ~48 seconds (full suite)
- **Pass Rate**: 100%
- **Code Coverage**: Focus on critical authentication paths

## 🏗 Design Decisions

### 1. Page Object Model (POM)

**Implementation**: `spec/support/pages/`

```
BasePage (shared functionality)
  ├── LoginPage (login form interactions)
  └── HomePage (authenticated user page)
```

**Benefits**:
- Separates test logic from UI structure
- Single source of truth for selectors
- Easy maintenance when UI changes
- Readable test code

**Example**:
```ruby
# Instead of:
fill_in 'email_address', with: 'test@test.com'

# Use:
login_page.fill_in_email('test@test.com')
```

### 2. Multi-Layer Testing Strategy

**Why three layers?**

| Layer         | Speed  | Coverage   | Purpose                        |
| ------------- | ------ | ---------- | ------------------------------ |
| Request Specs | ⚡ Fast | HTTP/API   | Catch integration bugs quickly |
| Feature Tests | 🐌 Slow | Full Stack | Validate user experience       |
| Accessibility | ⚡ Fast | Compliance | WCAG requirements              |

**Complementary coverage**: Each layer catches different bug types without full duplication.

### 3. GOV.UK Design System

**Why?** HMCTS uses GOV.UK Design System in production. This demonstrates:
- Domain awareness for government digital services
- Understanding of UK accessibility regulations
- Familiarity with production-grade component libraries

**Testing approach**: Validate both component rendering AND accessibility compliance.

### 4. Test Data Strategy

**Approach**: Database seeding with `db/seeds.rb`

**Why not factories?** For this focused exercise, seeded users provide:
- Consistency across test runs
- Simple setup
- Easy to verify manually

**Production consideration**: Would use FactoryBot for larger test suites.

### 5. Retry Strategy for Flaky Tests

**Implementation**: `features/support/retry_helper.rb`

```ruby
def with_retry(max_attempts: 3, &block)
  # Retry mechanism for Selenium timing issues
end
```

**Why?** Browser tests can be flaky due to timing. Retry strategy improves reliability without ignoring real failures.

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

Located at `.github/workflows/ci.yml`

**Pipeline stages**:

1. **Security Scans**
   - Brakeman (Rails security vulnerabilities)
   - Bundler Audit (gem vulnerabilities)
   - Importmap Audit (JavaScript dependencies)

2. **Code Quality**
   - RuboCop linting

3. **Test Automation**
   - Database setup
   - Rails server startup with health check (`/up` endpoint)
   - RSpec request specs
   - RSpec accessibility specs
   - Cucumber feature tests
   - Screenshot capture on failure

4. **Reporting**
   - HTML test reports uploaded as artifacts (30-day retention)
   - GitHub Pages deployment (on main branch)
   - Screenshots uploaded on test failure

### Screenshot Capture on Failure

Automatic screenshot capture is configured for debugging test failures:

- **Cucumber scenarios**: Screenshots embedded in HTML reports + saved to `tmp/screenshots/failure-{scenario-name}-{timestamp}.png`
- **RSpec feature specs**: Screenshots saved to `tmp/screenshots/failure-{filename}-{line}-{timestamp}.png`
- **CI pipeline**: Uploads all screenshots as GitHub Actions artifacts for team investigation
- **Only for browser tests**: Captures only when Selenium driver is active (`@javascript` tagged tests)

**Implementation**: After hooks in [features/support/env.rb](features/support/env.rb) and [spec/rails_helper.rb](spec/rails_helper.rb) detect failures and call `page.save_screenshot`.

This aids debugging race conditions, layout issues, and JavaScript errors without requiring local reproduction.

### Health Check Pattern

```yaml
- name: Wait for Rails server health check
  run: |
    timeout 30 bash -c 'until curl -f http://localhost:3000/up; do sleep 1; done'
```

**Why?** Ensures server is fully initialized before running tests, preventing flaky failures.

### Report Access

After CI runs:
- **Artifacts**: Download from Actions tab → Run → Artifacts
- **GitHub Pages**: `https://YOUR_USERNAME.github.io/REPO_NAME/test-reports/RUN_NUMBER/`

## 📁 Project Structure

```
hmcts/
├── app/                          # Rails application
│   ├── controllers/
│   │   └── sessions_controller.rb   # Login/logout logic
│   ├── models/
│   │   ├── user.rb                   # User authentication
│   │   └── session.rb                # Session management
│   └── views/
│       └── sessions/                 # Login forms (GOV.UK)
├── spec/
│   ├── requests/
│   │   └── sessions_spec.rb          # 29 HTTP layer tests
│   ├── features/
│   │   └── accessibility_spec.rb     # 5 WCAG tests
│   └── support/
│       └── pages/                    # Page Object Model
│           ├── base_page.rb
│           ├── login_page.rb
│           └── home_page.rb
├── features/                     # Cucumber BDD
│   ├── login.feature                 # 10 scenarios
│   ├── UI.feature                    # GOV.UK validation
│   ├── step_definitions/
│   │   └── login_steps.rb            # Step implementations
│   └── support/
│       ├── env.rb                    # Capybara config
│       └── retry_helper.rb           # Flaky test handling
├── dev/                          # Documentation
│   ├── TASK.md                       # Implementation plan
│   ├── response_explainer.md         # Request testing deep dive
│   ├── request_spec_justification.md # Test rationale
│   └── accessibility_testing_explainer.md  # A11y guide
├── .github/
│   └── workflows/
│       └── ci.yml                    # CI/CD pipeline
└── README.md                     # This file
```

## 🔮 Future Improvements

Given additional time, I would implement:

### 1. Visual Regression Testing
- **Tool**: Percy or BackstopJS
- **Why**: Catch unintended UI changes
- **Scope**: Login page, error states, responsive layouts

### 2. Performance Testing
- **Tool**: k6
- **Focus**: Rate limiting thresholds, concurrent user load
- **Metrics**: Response times, throughput, error rates

### 3. API Testing Layer
- **Tool**: RSpec with JSON schemas
- **Purpose**: If authentication exposed as API
- **Coverage**: Token generation, refresh, revocation

### 4. Cross-Browser Testing
- **Tool**: Selenium Grid or BrowserStack
- **Browsers**: Chrome, Firefox, Safari, Edge
- **Why**: Government services must work across browsers

### 5. Security Testing
- **Tools**: OWASP ZAP
- **Focus**: Session fixation, XSS, SQL injection
- **Integration**: Automated security scans in CI

### 6. Test Data Management
- **Tool**: FactoryBot + Faker
- **Why**: More flexible test data generation
- **Benefit**: Reduce coupling to seeded data

### 7. Parallel Test Execution
- **Tool**: parallel_tests gem
- **Why**: Faster CI feedback (critical for large suites)
- **Target**: Sub-30-second execution time

### 8. Enhanced Reporting
- **Tool**: Allure Framework
- **Features**: Test history, flaky test detection, trend analysis
- **Dashboard**: Centralized test results visualization

### 9. Test suite extension
- **Additional pages**: For existing functionality - Password reset page

## 📚 Resources & References

- [Rails 8 Authentication Guide](https://guides.rubyonrails.org/security.html#authentication)
- [GOV.UK Design System](https://design-system.service.gov.uk/)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Page Object Model Pattern](https://martinfowler.com/bliki/PageObject.html)
- [Cucumber Best Practices](https://cucumber.io/docs/bdd/)

## 🤝 Interview Discussion Points

### Technical Decisions
- Why multi-layer testing vs single approach?
- Trade-offs between test speed and coverage
- When to use Page Objects vs direct Capybara
- Handling flaky tests in CI

### Design Patterns
- Page Object Model implementation
- Test data management strategies
- Retry mechanisms for browser tests
- Report generation and artifact storage

---

**Developed for**: HMCTS Senior Developer in Test Assessment
**Focus**: Comprehensive test automation with production-grade practices
**Development approach**: AI-assisted (as per assignment guidelines)
**Time Investment**: 10-12 hours
**Key Achievements**: 44 tests, 100% pass rate, WCAG compliance, multi-layer coverage
