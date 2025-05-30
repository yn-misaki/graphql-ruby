# frozen_string_literal: true

require "graphql/tracing/notifications_trace"

module GraphQL
  module Tracing
    # This implementation forwards events to ActiveSupport::Notifications with a `graphql` suffix.
    #
    # @example Sending execution events to ActiveSupport::Notifications
    #   class MySchema < GraphQL::Schema
    #     trace_with(GraphQL::Tracing::ActiveSupportNotificationsTrace)
    #   end
    #
    # @example Subscribing to GraphQL events with ActiveSupport::Notifications
    #   ActiveSupport::Notifications.subscribe(/graphql/) do |event|
    #     pp event.name
    #     pp event.payload
    #   end
    #
    module ActiveSupportNotificationsTrace
      include NotificationsTrace
      def initialize(engine: ActiveSupport::Notifications, **rest)
        super
      end
    end
  end
end
