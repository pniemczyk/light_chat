# frozen_string_literal: true

require 'json'
require 'net/http'
require_relative 'client/helpers'

module LightChat
  class Client
    ROLES = %w[system user assistant].freeze

    def initialize(provider:, options: {}, headers: {}, auth_token: nil, machine_id: nil, session_id: nil,
                   providers_definition: nil)
      @provider = provider
      @options = options
      @headers = headers
      @auth_token = auth_token
      @machine_id = machine_id
      @session_id = session_id
      @providers = providers_definition || default_providers_definition
    end

    attr_reader :provider, :options, :headers, :auth_token, :machine_id, :session_id, :providers

    def completions(messages:, opts: {}, with_system_setup: true, token: nil)
      request(
        http_method: :post,
        url: "#{providers[provider][:base_url]}/#{providers[provider][:completions_path]}",
        body: build_body(messages: messages, opts: opts, with_system_setup: with_system_setup),
        headers: completions_headers(token: token)
      )
    end

    private

    def build_body(messages:, opts: {}, with_system_setup: true)
      return completions_options.merge(opts).merge(messages: messages) unless with_system_setup

      updated_messages = if messages.find do |message|
                              message['role'] == 'system'
                            end
                           messages
                         else
                           [system_setup_message] + messages
                         end

      completions_options.merge(opts).merge(messages: updated_messages)
    end

    def system_setup_message
      {
        role: 'system',
        content: providers[provider][:system_setup]
      }
    end

    def request(http_method:, url:, body: nil, headers: {})
      uri = URI(url)

      http = ::Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'

      request_class = case http_method.to_sym
                      when :get
                        Net::HTTP::Get
                      when :post
                        Net::HTTP::Post
                      when :put
                        Net::HTTP::Put
                      when :delete
                        Net::HTTP::Delete
                      else
                        raise ArgumentError, "Unsupported HTTP method: #{http_method}"
                      end

      request = request_class.new(uri)
      request['Content-Type'] = 'application/json'
      headers.each { |key, value| request[key] = value }
      request.body = JSON.generate(body) if body

      response = http.request(request)

      body = if response.content_type == 'application/json'
               JSON.parse(response.body)
             else
               response.body
             end
      {
        'body' => body,
        'status' => response.code.to_i,
        'headers' => response.each_header.to_a.to_h
      }
    end

    def completions_options
      providers[provider][:completions_default_options].merge(options)
    end

    def completions_headers(token: nil)
      providers[provider][:default_headers].merge(headers).merge('Authorization' => "Bearer #{token || auth_token}",
                                                                 'X-Request-Id' => Helpers.request_id)
    end

    def default_providers_definition # rubocop:disable Metrics/MethodLength
      {
        openai: {
          base_url: 'https://api.openai.com',
          completions_path: 'v1/chat/completions',
          completions_default_options: {
            model: 'gpt-3.5-turbo',
            max_tokens: 4096,
            temperature: 0.1
          },
          models: %w[gpt-3.5-turbo gpt-3.5-turbo-16k gpt-3.5-turbo-instruct gpt-3.5-turbo-0125 gpt-3.5-turbo-0301
                     gpt-3.5-turbo-0613],
          default_headers: {
            'Content-Type' => 'application/json',
            'X-Request-Id' => Helpers.request_id
          },
          system_setup: "\nYou are an AI programming assistant.\nFollow the user's requirements carefully & to the letter.\nYour expertise is strictly limited to software development topics.\nKeep your answers short and impersonal.\n\nYou can answer general programming questions and perform the following tasks:\n* Ask a question about the files in your current workspace\n* Explain how the selected code works\n* Generate unit tests for the selected code\n* Propose a fix for the problems in the selected code\n* Scaffold code for a new workspace\n* Create a new Jupyter Notebook\n* Find relevant code to your query\n* Ask questions about VS Code\n* Generate query parameters for workspace search\n* Ask about VS Code extension development\n* Ask how to do something in the terminal\nYou use the GPT-3.5-TURBO version of OpenAI's GPT models.\nFirst think step-by-step - describe your plan for what to build in pseudocode, written out in great detail.\nThen output the code in a single code block.\nMinimize any other prose.\nUse Markdown formatting in your answers.\nMake sure to include the programming language name at the start of the Markdown code blocks.\nAvoid wrapping the whole response in triple backticks.\nYou can only give one reply for each conversation turn." # rubocop:disable Layout/LineLength
        },
        copilot: {
          base_url: 'https://api.githubcopilot.com',
          completions_path: 'chat/completions',
          completions_default_options: {
            model: 'gpt-3.5-turbo',
            max_tokens: 4096,
            temperature: 0.1,
            top_p: 1,
            n: 1,
            stream: false
          },
          models: ['gpt-3.5-turbo'],
          default_headers: {
            'Content-Type' => 'application/json',
            'X-GitHub-Api-Version' => '2023-07-07',
            'VScode-MachineId' => machine_id || Helpers.new_machine_id,
            'Editor-Version' => 'vscode/1.86.2',
            'Editor-Plugin-Version' => 'copilot-chat/0.12.2',
            'Openai-Organization' => 'github-copilot',
            'Copilot-Integration-Id' => 'vscode-chat',
            'VScode-SessionId' => session_id || Helpers.new_session_id,
            'Accept' => '*/*',
            'Connection' => 'close',
            'X-Request-Id' => Helpers.request_id
          },
          system_setup: "\nYou are an AI programming assistant.\nFollow the user's requirements carefully & to the letter.\nYour expertise is strictly limited to software development topics.\nKeep your answers short and impersonal.\n\nYou can answer general programming questions and perform the following tasks:\n* Ask a question about the files in your current workspace\n* Explain how the selected code works\n* Generate unit tests for the selected code\n* Propose a fix for the problems in the selected code\n* Scaffold code for a new workspace\n* Create a new Jupyter Notebook\n* Find relevant code to your query\n* Ask questions about VS Code\n* Generate query parameters for workspace search\n* Ask about VS Code extension development\n* Ask how to do something in the terminal\nYou use the GPT-3.5-TURBO version of OpenAI's GPT models.\nFirst think step-by-step - describe your plan for what to build in pseudocode, written out in great detail.\nThen output the code in a single code block.\nMinimize any other prose.\nUse Markdown formatting in your answers.\nMake sure to include the programming language name at the start of the Markdown code blocks.\nAvoid wrapping the whole response in triple backticks.\nYou can only give one reply for each conversation turn." # rubocop:disable Layout/LineLength
        }
      }
    end
  end
end
