# Jeweler::Utils

<p align="center">
<a href="http://jeweler-staging.bluehelmet.software"><img width="400" src="https://raw.githubusercontent.com/vaskaloidis/jeweler/master/app/assets/images/jeweler-logo-full-alternate.png"></a>

[![CircleCI](https://circleci.com/gh/vaskaloidis/jeweler.svg?style=svg&circle-token=0695c448bed1c7ed2fc9e4d982aa38f0651ca0c4)](https://circleci.com/gh/vaskaloidis/jeweler)
[![Slack](https://img.shields.io/badge/discuss-Slack-brightgreen.svg)](https://bluehelmet.slack.com)
[![Coverage Status](https://coveralls.io/repos/github/vaskaloidis/jeweler/badge.svg?branch=master)](https://coveralls.io/github/vaskaloidis/jeweler?branch=master)
</p>

A utility package of various Core Extensions, helpers and Ruby Patterns we use for developing Jeweler. 

## Usage

### Service Object Pattern
Used to build a Service Object.

- Returns `result` method which is set to the value of the result of the `Call` method
- Returns `errors` method with an Array of any errors placed in the `@errors` variable in the Service Object. These also are logged as a warning. This is combined with the value of the `fatals` array, which contains more serious errors. These get logged as errors.
- It catches and handles Exceptions raised in the call method, so do all the important processing there. 
- Soon it will be logging important information about them specifically for our SAAS platform, like the User ID, ProjectID of the error, to Rollbar
- If `@success` is not set in `call`, then it sets it for you: returns `success` True if errors and fatals is empty, otherwise False.

**Example:**

```ruby
class UpdateTask < Jeweler::Service
  def initialize(task)
    @task = task
  end

  def call
    if task.update(hours: 4)
      Note.create_event(task.sprint.project, 'task_deleted', 'Deleted: ' + task.description)
    else
      task.errors.full_messages.map { |e| fatals << 'Error Destroying Task: ' + e }
    end
    task
  end

  private

  attr_reader :task
end

# Usage:
@service_object = DestroyTask.call(@task)
@service_object.errors # Combined array of fatals and errors. They are logged differently by Jeweler::Service though
@service_object.result # Task<id: 7, hours: 3...> 
```


### String
true? - returns true if the string is explicitly equal to 'true'
```ruby
'true'.true? # returns true ONLY
'truue'.true? # returns false
```
.to_b - converts the string 'true' and 'false' explicitly / respectively to TRUE / FALSE, otherwise it will throw an exception.
```ruby
'true'.to_b # TRUE
'false'.to_b # FALSE
'faalse'.to_b # Throws an Exception
```

### String, BigDecimal, Decimal, Float, Integer

.money - will convert this to a formatted USD money String, rounding it to 0 decimal places if it is a whole number
```ruby
(500.84).money # '$500.84'
(500.00).money # '$500'
```

### BigDecimal, Decimal, Float, Integer, Double
(Double does not have a rate)

.prettify - Rounds the number to 0 decimal places if it is a whole number anyway
```ruby
(500.00).prettify # 500
(500.87).prettify # 500.87
```

.rate - Converts a number to an hourly-rate in USD ($/hr) (String)
```ruby
(55.50) # '$55.50/hr'
```

.hours - Appends hours or hour to the end of a number, converts it to String
```ruby
(5).hours # '5 hrs'
(1).hours # '1 hr'
```

### NilClass
These, as well as the methods above are for displaying these numbers in the UI. I prefer these cleaner methods to the decorator pattern (in these few use-cases), because it is really really clean.

`(nil).prettify` - returns 0 (Integer)
`(nil).hours` - returns '0 hr.' (String)
`(nil).money` - returns '$0' (String)
`(nil).true?` - returns False (Boolean)
`(nil).to_b` - returns False (Boolean)

### Array
.log_errors(prefix_msg = nil) - Logs all of these errors, as errors, prefixed with the param (optionally)

```ruby
sprint.errors.full_messages.log_errors('Error Saving Sprint') 
# log.warn - Error Saving Sprint: the validation error while saving sprint
 
sprint.errors.full_messages.log_errors 
# log.warn - the validation error while saving sprint

```


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'jeweler-utils'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install jeweler-utils
```

## Contributing
Just submit a pull request with your modifications and I will take a look.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
