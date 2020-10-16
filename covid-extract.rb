#!/usr/bin/env ruby

require 'json'

ARGF.each_line do |line|
  date, suspect_case_count, confirmed_case_count, test_count, hospitalization_count, intensive_care_count, _, death_count, active_case_count, curred_case_count, mean_age, hospitalization_mean_age, source_protocol, source_end = line.split(':')

  source = "#{source_protocol}:#{source_end}"

  document = {}

  document['@timestamp'] = "#{date}T10:00:00"
  document['suspect_case_count'] = suspect_case_count.to_i unless suspect_case_count.empty?
  document['confirmed_case_count'] = confirmed_case_count.to_i unless confirmed_case_count.empty?
  document['test_count'] = test_count.to_i unless test_count.empty?
  document['hospitalization_count'] = hospitalization_count.to_i unless hospitalization_count.empty?
  document['intensive_care_count'] = intensive_care_count.to_i unless intensive_care_count.empty?
  document['death_count'] = death_count.to_i unless death_count.empty?
  document['active_case_count'] = active_case_count.to_i unless active_case_count.empty?
  document['curred_case_count'] = curred_case_count.to_i unless curred_case_count.empty?
  document['mean_age'] = mean_age.to_i unless mean_age.empty?
  document['hospitalization_mean_age'] = hospitalization_mean_age.to_i unless hospitalization_mean_age.empty?
  document['source'] = source

  if !document['confirmed_case_count'] &&
      document['active_case_count'] &&
      document['curred_case_count']
    document['confirmed_case_count'] = document['active_case_count'] + document['curred_case_count']
  end

  if document['confirmed_case_count'] &&
      !document['active_case_count'] &&
      document['curred_case_count']
    document['active_case_count'] = document['confirmed_case_count'] - document['curred_case_count']
  end

  puts document.to_json
end
