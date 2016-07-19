# Sauce RSpec

[![Build Status](https://travis-ci.org/bootstraponline/sauce_rspec.svg)](https://travis-ci.org/bootstraponline/sauce_rspec/builds)
[![Gem Version](https://badge.fury.io/rb/sauce_rspec.svg)](https://rubygems.org/gems/sauce_rspec)
[![Coverage Status](https://coveralls.io/repos/bootstraponline/sauce_rspec/badge.svg?branch=master&service=github&nocache=1)](https://coveralls.io/github/bootstraponline/sauce_rspec?branch=master)

A new [Ruby gem](https://github.com/bootstraponline/meta/wiki/Sauce_Ruby_Integration_Roadmap) for using RSpec on Sauce.

```
require 'sauce_rspec'
require 'sauce_rspec/rspec'
```

Note that for Jenkins support, you must enable verbose mode in test-queue
otherwise stdout will not be printed in the Jenkins log.

```
export TEST_QUEUE_VERBOSE=true
```

## Naming jobs

Use Jenkins environment variables to correctly name jobs.

```ruby
# example sauce_helper.rb
require 'sauce_platforms'

SauceRSpec.config do |config|
  config.caps = [
    Platform.windows_10.firefox.v41,
    Platform.windows_10.chrome.v45
  ]

  build = if jenkins?
            [ENV['JOB_NAME'], ENV['BUILD_NUMBER']].join('-')
          else
            "sauce_rspec-#{SecureRandom.random_number(999_999)}"
          end

  config.default_caps({ build: build })
end
```

If you're using the Sauce Jenkins plugin then `ENV['JENKINS_BUILD_NUMBER']` will [already contain the job name and build number.](https://wiki.saucelabs.com/display/DOCS/Setting+Up+Reporting+between+Sauce+Labs+and+Jenkins)
