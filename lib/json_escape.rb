# frozen_string_literal: true

require_relative "json_escape/version"

module JsonEscape
  module Pure
    JSON_ESCAPE = { "&" => '\u0026', ">" => '\u003e', "<" => '\u003c', "\u2028" => '\u2028', "\u2029" => '\u2029' }
    JSON_ESCAPE_REGEXP = /[\u2028\u2029&><]/u
    private_constant :JSON_ESCAPE, :JSON_ESCAPE_REGEXP

    def json_escape(json)
      json = json.to_s
      if json.encoding != Encoding::UTF_8 && json.encoding != Encoding::ASCII
        raise Encoding::CompatibilityError, "input string must be UTF-8 or ASCII"
      end
      json.gsub(JSON_ESCAPE_REGEXP, JSON_ESCAPE)
    end
    module_function :json_escape
  end

  begin
    require_relative "json_escape/json_escape"
  rescue LoadError
    include Pure
  end

  module_function :json_escape
end
