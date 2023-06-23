require "benchmark/ips"
require "json_escape"

benchmarks = [
  "twitter.json",
  "citm_catalog.json",
  "canada.json"
]

Benchmark.ips do |x|
  benchmarks.each do |benchmark|
    data = File.read("#{__dir__}/test/benchmark_data/#{benchmark}")
    x.report "JsonEscape.json_escape(#{benchmark})" do
      JsonEscape.json_escape(data)
    end

    x.report "JsonEscape::Pure.json_escape(#{benchmark})" do
      JsonEscape::Pure.json_escape(data)
    end
  end
end
