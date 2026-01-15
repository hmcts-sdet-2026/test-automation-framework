# Helper for retrying flaky steps (focus, timing-sensitive operations)
module RetryHelper
  def with_retry(max_attempts: 3, wait: 0.1)
    attempts = 0
    begin
      attempts += 1
      yield
    rescue RSpec::Expectations::ExpectationNotMetError => e
      if attempts < max_attempts
        sleep wait
        retry
      else
        raise e
      end
    end
  end
end

World(RetryHelper)
