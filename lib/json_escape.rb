# frozen_string_literal: true

require_relative "json_escape/version"
require_relative "json_escape/json_escape"

module JsonEscape
  class Error < StandardError; end

  module Pure
    JSON_ESCAPE = { "&" => '\u0026', ">" => '\u003e', "<" => '\u003c', "\u2028" => '\u2028', "\u2029" => '\u2029' }
    JSON_ESCAPE_REGEXP = /[\u2028\u2029&><]/u
    private_constant :JSON_ESCAPE, :JSON_ESCAPE_REGEXP

    def json_escape(json)
      json.to_s.gsub(JSON_ESCAPE_REGEXP, JSON_ESCAPE)
    end
    module_function :json_escape
  end

  #include Pure

  module_function :json_escape
end
