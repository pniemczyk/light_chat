# frozen_string_literal: true

require 'securerandom'

module LightChat
  class Client
    class Helpers
      def self.hex_str(length)
        SecureRandom.hex(length / 2)
      end

      def self.new_machine_id
        hex_str(64)
      end

      def self.new_session_id
        "#{hex_str(8)}-#{hex_str(4)}-#{hex_str(4)}-#{hex_str(4)}-#{hex_str(25)}"
      end

      def self.request_id
        "#{hex_str(8)}-#{hex_str(4)}-#{hex_str(4)}-#{hex_str(4)}-#{hex_str(12)}"
      end
    end
  end
end
