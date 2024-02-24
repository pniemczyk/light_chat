# LightChat

Just a simple proxy for ChatGPT API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'light_chat'
```

## Usage

```ruby
c = LightChat::Client.new(provider: :copilot, auth_token: '***')
# or
c = LightChat::Client.new(provider: :openai, auth_token: 'sk-***')
c.completions(messages: [{ role: 'user', content: 'What is the best way to sort an array in Ruby?' }])
```

## Response

### OpenAI

```json
{
  "body": {
    "id": "chatcmpl-8vqyinqhdgaFzrqCpruHNq54Lw7QG", 
    "object": "chat.completion", 
    "created": 1708799036,
    "model": "gpt-3.5-turbo-0125",
    "choices": [
      {
        "index": 0, 
        "message": {
          "role": "assistant", 
          "content": "```ruby\n# To sort an array in Ruby, you can use the `sort` method.\n# Here is an example:\n\nunsorted_array = [3, 1, 5, 2, 4]\nsorted_array = unsorted_array.sort\n\nputs sorted_array\n```"
        }, 
        "logprobs": nil, 
        "finish_reason": "stop"
      }
    ],
    "usage": {"prompt_tokens": 276, "completion_tokens": 58, "total_tokens": 334},
    "system_fingerprint": "fp_86156a94a0"},
    "status": 200,
  "headers": {
    "date": "Sat, 24 Feb 2024 18:00:56 GMT",
     "content-type": "application/json",
     "transfer-encoding": "chunked",
     "connection": "close",
     "access-control-allow-origin": "*",
     "cache-control": "no-cache, must-revalidate",
     "openai-model": "gpt-3.5-turbo-0125",
     "openai-organization": "user-zdk9028cnzqat2vago2gt5zls2",
     "openai-processing-ms": "842",
     "openai-version": "2020-10-01",
     "strict-transport-security": "max-age=15724800; includeSubDomains",
     "x-ratelimit-limit-requests": "10000",
     "x-ratelimit-limit-tokens": "60000",
     "x-ratelimit-remaining-requests": "9999",
     "x-ratelimit-remaining-tokens": "55904",
     "x-ratelimit-reset-requests": "8.64s",
     "x-ratelimit-reset-tokens": "4.096s",
     "x-request-id": "req_c848fdf20c3b2fd428af72eec1d6f47a",
     "cf-cache-status": "DYNAMIC",
     "set-cookie": "__cf_bm=hc.UHxVmsw2lyejO_ItRFJsTqxZkrGhjB5avdDtAT8s-1709799036-1.0-AXsxUZpRAAvj6tnzHP0KkCajTMS9zcCEy5e6VTAocR74h84sxoQppS8P/WOpAGN/SlKqwl67528hW9rcaQce4YBc=; path=/; expires=Sat, 24-Feb-24 18:00:56 GMT; domain=.api.openai.com; HttpOnly; Secure; SameSite=None, _cfuvid=IZPhM.UlilrcQmlcImnDAEqzW_FfHfpYpvwDu.TOEqg-1709299036977-0.0-604800000; path=/; domain=.api.openai.com; HttpOnly; Secure; SameSite=None",
     "server": "cloudflare",
     "cf-ray": "85a9be167ef96e99-PRG",
     "alt-svc": "h3=\":443\"; ma=86400"
  }
}
```

### Copilot

```json
{ 
  "body": { 
    "choices": [
      { 
        "content_filter_results": { 
          "hate": { "filtered": false, "severity": "safe" }, 
          "self_harm": { "filtered": false, "severity": "safe" }, 
          "sexual": { "filtered": false, "severity": "safe" }, 
          "violence": { "filtered": false, "severity": "safe" }
        },
       "finish_reason": "stop",
       "index": 0,
       "message": { 
         "content": "The best way to sort an array in Ruby is to use the `sort` method. The `sort` method sorts the elements of an array in ascending order by default. If you want to sort the array in descending order, you can use the `sort` method with a block and reverse the comparison result. Here's an example:\n\n```ruby\n# Sorting in ascending order\narray = [5, 2, 8, 1, 9]\nsorted_array = array.sort\nputs sorted_array # Output: [1, 2, 5, 8, 9]\n\n# Sorting in descending order\narray = [5, 2, 8, 1, 9]\nsorted_array = array.sort { |a, b| b <=> a }\nputs sorted_array # Output: [9, 8, 5, 2, 1]\n```\n\nIn the example above, the `sort` method is used to sort the `array` in ascending order. The resulting sorted array is then printed to the console. To sort the array in descending order, a block is passed to the `sort` method, which reverses the comparison result using the spaceship operator (`<=>`).",
         "role": "assistant" }
      }
    ],
    "created": 1708798726,
    "id": "chatcmpl-8vqtib9Uh24ynOJOacTucZ9KtYzZ",
    "prompt_filter_results": [
      { 
        "content_filter_results": { 
          "hate": { "filtered": false, "severity": "safe" }, 
          "self_harm": { "filtered": false, "severity": "safe" }, 
          "sexual": { "filtered": false, "severity": "safe" }, 
          "violence": { "filtered": false, "severity": "safe" }
        }, 
        "prompt_index": 0
      }
    ],
    "usage": { "completion_tokens": 248, "prompt_tokens": 276, "total_tokens": 524 } },
    "status": 200,
    "headers": { 
      "content-security-policy": "default-src 'none'; sandbox", 
      "content-type": "application/json",
      "strict-transport-security": "max-age=31536000", 
      "x-request-id": "cfecd8b6-eacf-ec55-d017-185695da0e1c", 
      "date": "Sat, 24 Feb 2024 18:00:47 GMT", 
      "content-length": "1616", 
      "x-github-backend": "Kubernetes", 
      "x-github-request-id": "EC04:62E6:1226D72:24ED480:65DA3306", 
      "connection": "close"
    }
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/light_chat.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
