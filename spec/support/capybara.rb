require 'capybara/rspec'

Capybara.save_path = Rails.root.join('tmp/capybara')
Capybara.enable_aria_label = true

Capybara.register_driver :selenium_chrome_headless do |app|
  opts = Selenium::WebDriver::Chrome::Options.new
  # Für moderne Chromes:
  opts.add_argument('--headless=new') unless ENV['NO_HEADLESS']
  opts.add_argument('--disable-gpu')
  opts.add_argument('--window-size=1400,1400')
  opts.add_argument('--no-sandbox') if ENV['CI'] # wichtig in Docker/CI
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: opts)
end

Capybara.javascript_driver = :selenium_chrome_headless
