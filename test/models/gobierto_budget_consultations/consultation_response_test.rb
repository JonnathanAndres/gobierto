require "test_helper"

module GobiertoBudgetConsultations
  class ConsultationResponseTest < ActiveSupport::TestCase
    def consultation_response
      @consultation_response ||= gobierto_budget_consultations_consultation_responses(:dennis_madrid_open)
    end

    def test_valid
      assert consultation_response.valid?
    end

    def test_consultation_items
      consultation_response.consultation_items.each do |consultation_response_item|
        assert_kind_of ConsultationResponseItem, consultation_response_item
      end
    end
  end
end
