# frozen_string_literal: true

module GobiertoParticipation
  module Processes
    class InformationController < BaseController
      def show
        @information_text = current_process.information_text
      end
    end
  end
end
