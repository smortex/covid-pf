#!/usr/bin/env ruby

require 'json'

marker = 0

confirmed_case_count_offset = 0

ARGF.each_line do |line|
  date, suspect_case_count, confirmed_case_count, test_count, hospitalization_count, intensive_care_count, _, death_count, active_case_count, curred_case_count, mean_age, hospitalization_mean_age, vaccinated_count, revaccinated_count, source_protocol, source_end = line.split(':')

  next if ['', 'Date'].include?(date)

  # Starting on 2020-07-15, all previous data is ignored.
  # Starting on 2020-11-02, old data is uncluded, but from 2020-03-13 only.
  if date == '---'
    case marker
    when 0 then confirmed_case_count = 62
    when 1 then confirmed_case_count = 3
    else fail('Unexpected marker')
    end
    marker += 1
    next
  end

  source = "#{source_protocol}:#{source_end}"

  document = {}

  document['@timestamp'] = "#{date}T10:00:00"
  document['suspect_case_count'] = suspect_case_count.to_i unless suspect_case_count.empty?
  document['confirmed_case_count'] = confirmed_case_count.to_i + confirmed_case_count_offset unless confirmed_case_count.empty?
  document['test_count'] = test_count.to_i unless test_count.empty?
  document['hospitalization_count'] = hospitalization_count.to_i unless hospitalization_count.empty?
  document['intensive_care_count'] = intensive_care_count.to_i unless intensive_care_count.empty?
  document['death_count'] = death_count.to_i unless death_count.empty?
  document['active_case_count'] = active_case_count.to_i unless active_case_count.empty?
  document['curred_case_count'] = curred_case_count.to_i unless curred_case_count.empty?
  document['mean_age'] = mean_age.to_i unless mean_age.empty?
  document['hospitalization_mean_age'] = hospitalization_mean_age.to_i unless hospitalization_mean_age.empty?
  document['vaccinated_count'] = vaccinated_count.to_i unless vaccinated_count.empty?
  document['revaccinated_count'] = revaccinated_count.to_i unless revaccinated_count.empty?
  document['source'] = source

  if !document['confirmed_case_count'] &&
      document['active_case_count'] &&
      document['curred_case_count'] &&
      document['death_count']
    document['confirmed_case_count'] = document['active_case_count'] + document['curred_case_count'] + document['death_count']
  end

  if document['confirmed_case_count'] &&
      !document['active_case_count'] &&
      document['curred_case_count'] &&
      document['death_count']
    document['active_case_count'] = document['confirmed_case_count'] - document['curred_case_count'] - document['death_count']
  end

  if document['vaccinated_count'] && !document['revaccinated_count']
    document['revaccinated_count'] = 0
  end

  puts document.to_json
end
