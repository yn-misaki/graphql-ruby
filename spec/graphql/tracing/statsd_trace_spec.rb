# frozen_string_literal: true
require "spec_helper"

describe GraphQL::Tracing::StatsdTracing do
  module TraceMockStatsd
    class << self
      def time(key)
        self.timings << key
        yield
      end

      def timing(key, ms)
        self.timings << key
      end

      attr_reader :timings

      def clear
        @timings = []
      end
    end
  end

  class StatsdTraceTestSchema < GraphQL::Schema
    class Thing < GraphQL::Schema::Object
      field :str, String
      def str; "blah"; end
    end

    class Query < GraphQL::Schema::Object
      field :int, Integer, null: false

      def int
        1
      end

      field :thing, Thing
      def thing; :thing; end
    end

    query(Query)

    trace_with GraphQL::Tracing::StatsdTrace, statsd: TraceMockStatsd
  end

  before do
    TraceMockStatsd.clear
  end

  it "gathers timings" do
    StatsdTraceTestSchema.execute("query X { int thing { str } }")
    expected_timings = [
      "graphql.execute",
      (USING_C_PARSER ? "graphql.lex" : nil),
      "graphql.parse",
      "graphql.validate",
      "graphql.analyze",
      "graphql.authorized.Query",
      "graphql.Query.thing",
      "graphql.authorized.Thing",
    ].compact
    assert_equal expected_timings, TraceMockStatsd.timings
  end
end
