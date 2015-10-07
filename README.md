# Sauce RSpec

[![Build Status](https://travis-ci.org/bootstraponline/sauce_rspec.svg)](https://travis-ci.org/bootstraponline/sauce_rspec/builds)
[![Gem Version](https://badge.fury.io/rb/sauce_rspec.svg)](https://rubygems.org/gems/sauce_rspec)
[![Coverage Status](https://coveralls.io/repos/bootstraponline/sauce_rspec/badge.svg?branch=master&service=github&nocache=true)](https://coveralls.io/github/bootstraponline/sauce_rspec?branch=master)

A new [Ruby gem](https://github.com/bootstraponline/meta/wiki/Sauce_Ruby_Integration_Roadmap) for using RSpec on Sauce.

```
require 'sauce_rspec'
require 'sauce_rspec/rspec'
```

Note that for Jenkins support, you must enable verbose mod in test-queue
otherwise stdout will not be printed in the Jenkins log.

```
export TEST_QUEUE_VERBOSE=true
```
