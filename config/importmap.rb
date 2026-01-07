# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "govuk-frontend", to: "https://cdn.jsdelivr.net/npm/govuk-frontend@5.6.0/dist/govuk/govuk-frontend.min.js"
