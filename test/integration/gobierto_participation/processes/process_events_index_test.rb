# frozen_string_literal: true

require "test_helper"

module GobiertoParticipation
  class ProcessEventsIndexTest < ActionDispatch::IntegrationTest
    def site
      @site ||= sites(:madrid)
    end

    def process
      @process ||= gobierto_participation_processes(:gender_violence_process)
    end

    def process_events_path
      @process_events_path ||= gobierto_participation_process_events_path(
        process_id: process.slug
      )
    end

    def process_events
      process.events_in_collections
    end

    def test_breadcrumb_items
      with_current_site(site) do
        visit process_events_path

        within ".global_breadcrumb" do
          assert has_link? "Participation"
          assert has_link? "Processes"
          assert has_link? process.title
        end
      end
    end

    def test_menu_subsections
      with_current_site(site) do
        visit process_events_path

        within "menu.sub_sections" do
          assert has_link? "About"
          assert has_link? "Issues"
          assert has_link? "Processes"
          assert has_link? "Ask"
          assert has_link? "Ideas"
        end
      end
    end

    def test_secondary_nav
      with_current_site(site) do
        visit process_events_path

        within "menu.secondary_nav" do
          assert has_link? "News"
          assert has_link? "Diary"
          assert has_link? "Documents"
          assert has_link? "Activity"
        end
      end
    end

    def test_subscription_block
      with_current_site(site) do
        visit process_events_path

        within ".site_header" do
          skip "Not yet defined"
        end
      end
    end

    def test_process_events_index
      process_events.first.update_attributes!(starts_at: Time.zone.now + 1.hour, ends_at: Time.zone.now)

      with_current_site(site) do
        visit process_events_path

        within ".events_list" do
          assert_equal process_events.size, all(".person_event-item").size

          assert has_content? "Swimming lessons for elders"
          assert has_link? "Instalaciones Deportivas Canal de Isabel II"

          assert has_content? "Intensive reading club in english"
        end

        assert has_content? "Agenda"
        # TODO: refute has_content? "Agenda for #{process.title}"

        assert all(".has-events").size >= 1
      end
    end
  end
end
