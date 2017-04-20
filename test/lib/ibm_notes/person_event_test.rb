require 'test_helper'

class PersonEventTest < ActiveSupport::TestCase

  def setup
    super
    persisted_ibm_notes_event_gobierto_event.save!
  end

  def person
    @person ||= gobierto_people_people(:richard)
  end

  def utc_time(date)
    d = Time.parse(date)
    Time.utc(d.year, d.month, d.day, d.hour, d.min, d.sec)
  end

  def persisted_ibm_notes_event_response_data
    @persisted_ibm_notes_event_response_data ||= {
      'id' => 'Ibm Notes persisted event ID',
      'summary' => 'Ibm Notes persisted event title',
      'start' =>  { 'date' => '2017-04-11', 'time' => '10:00:00', 'utc' => true },
      'end'   =>  { 'date' => '2017-04-11', 'time' => '11:00:00', 'utc' => true },
      'transparency' => 'transparent',
    }
  end

  def persisted_ibm_notes_event
    @persisted_ibm_notes_event ||= IbmNotes::PersonEvent.new(person, persisted_ibm_notes_event_response_data)
  end

  def persisted_ibm_notes_event_gobierto_event
    @persisted_ibm_notes_event_gobierto_event ||= GobiertoPeople::PersonEvent.new(
      external_id: 'Ibm Notes persisted event ID',
      title: 'Ibm Notes persisted event title',
      starts_at: utc_time("2017-04-11 10:00:00"),
      ends_at:   utc_time("2017-04-11 11:00:00"),
      state: 'published',
      person: person
    )
  end

  def new_ibm_notes_event_response_data
    @new_ibm_notes_event_response_data ||= {
      'id' => 'Ibm Notes new event ID',
      'summary' => 'Ibm Notes new event title',
      'start' =>  { 'date' => '2017-04-11', 'time' => '10:00:00', 'utc' => true },
      'end'   =>  { 'date' => '2017-04-11', 'time' => '11:00:00', 'utc' => true },
      'transparency' => 'transparent',
    }
  end

  def new_ibm_notes_event
    @new_ibm_notes_event ||= IbmNotes::PersonEvent.new(person, new_ibm_notes_event_response_data)
  end

  def test_initialize
    assert_equal persisted_ibm_notes_event.external_id, 'Ibm Notes persisted event ID'
    assert_equal persisted_ibm_notes_event.title,        'Ibm Notes persisted event title'
    assert_equal persisted_ibm_notes_event.state,        'published'
    assert_equal persisted_ibm_notes_event.person,       person
    assert_equal persisted_ibm_notes_event.starts_at,    utc_time('2017-04-11 10:00:00')
    assert_equal persisted_ibm_notes_event.ends_at,      utc_time('2017-04-11 11:00:00')
  end

  def test_gobierto_event
    assert_equal persisted_ibm_notes_event.gobierto_event, persisted_ibm_notes_event_gobierto_event
    assert_nil new_ibm_notes_event.gobierto_event
  end

  def test_has_gobierto_event?
    assert persisted_ibm_notes_event.has_gobierto_event?
    refute new_ibm_notes_event.has_gobierto_event?
  end

  def test_gobierto_event_outdated?
    refute persisted_ibm_notes_event.gobierto_event_outdated?

    persisted_ibm_notes_event.gobierto_event.update_attribute(:title, 'New Title')

    assert persisted_ibm_notes_event.gobierto_event_outdated?
  end

end