#!/usr/bin/env ruby

require 'date'
require 'json'

module SpreadSheet
  class Cell
    attr_reader :leftstring, :rightstring, :let

    def set(hash = {})
      @leftstring = hash[:leftstring] if hash.key?(:leftstring)
      @rightstring = hash[:rightstring] if hash.key?(:rightstring)

      @let = hash[:let] if hash.key?(:let)
    end
  end

  class Line
    attr_reader :cells

    def initialize
      @cells = []
    end
  end

  class Sheet
    attr_reader :lines

    def initialize
      @lines = []
    end

    def self.load(io)
      sheet = new
      io.each_line do |line|
        line.chomp!

        next if line.empty?
        next if line.match(/^#/)

        if 0 == (/(?<command>leftstring|let|rightstring) (?<position>[A-Z]\d+) = (?<value>.*)/ =~ line)
          if value.match(/\A".*"\z/)
            value = value[1...-1]
          else
            value = value.to_i
          end
          sheet.set(position, command.to_sym => value)
        end
      end
      sheet
    end

    def set(position, hash)
      /\A(?<x>[[:alnum:]])(?<y>\d+)\z/ =~ position

      x = x.ord - 'A'.ord
      y = y.to_i

      lines[y] ||= Line.new
      lines[y].cells[x] ||= Cell.new
      lines[y].cells[x].set(hash)
    end
  end
end

class CovidDataPoint
  attr_accessor :date, :suspect_case_count, :confirmed_case_count, :test_count, :hospitalization_count, :intensive_care_count, :death_count, :active_case_count, :curred_case_count, :mean_age, :hospitalization_mean_age, :vaccinated_count, :revaccinated_count, :source

  def initialize(data)
    @date, @suspect_case_count, @confirmed_case_count, @test_count, @hospitalization_count, @intensive_care_count, _, @death_count, @active_case_count, @curred_case_count, @mean_age, @hospitalization_mean_age, @vaccinated_count, @revaccinated_count, source_protocol, source_end = *data
    @source = "#{source_protocol}:#{source_end}"
  end

  def previous_week_date
    @previous_week_date ||= (Date.parse(date) - 7).iso8601
  end

  def next_week_date
    @next_week_date ||= (Date.parse(date) + 7).iso8601
  end

  def to_json
    document = {}

    document['@timestamp'] = "#{date}T00:00:00-1000"
    document['suspect_case_count'] = suspect_case_count.to_i unless suspect_case_count.nil?
    document['confirmed_case_count'] = confirmed_case_count.to_i unless confirmed_case_count.nil?
    document['test_count'] = test_count.to_i unless test_count.nil?
    document['hospitalization_count'] = hospitalization_count.to_i unless hospitalization_count.nil?
    document['intensive_care_count'] = intensive_care_count.to_i unless intensive_care_count.nil?
    document['death_count'] = death_count.to_i unless death_count.nil?
    document['active_case_count'] = active_case_count.to_i unless active_case_count.nil?
    document['curred_case_count'] = curred_case_count.to_i unless curred_case_count.nil?
    document['mean_age'] = mean_age.to_i unless mean_age.nil?
    document['hospitalization_mean_age'] = hospitalization_mean_age.to_i unless hospitalization_mean_age.nil?
    document['vaccinated_count'] = vaccinated_count.to_i unless vaccinated_count.nil?
    document['revaccinated_count'] = revaccinated_count.to_i unless revaccinated_count.nil?
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

    document.to_json
  end
end

sheet = SpreadSheet::Sheet.load(ARGF)

confirmed_case_count_offset = 0
marker = 0

data_points = {}

sheet.lines.each do |line|
  next unless line

  data = line.cells.map { |x| x&.let || x&.rightstring || x&.leftstring }
  date = data[0]

  next if ['', 'Date'].include?(date)

  # Starting on 2020-07-15, all previous data is ignored.
  # Starting on 2020-11-02, old data is uncluded, but from 2020-03-13 only.
  if date == '---'
    case marker
    when 0 then confirmed_case_count_offset = 62
    when 1 then confirmed_case_count_offset = 3
    else fail('Unexpected marker')
    end
    marker += 1
    next
  end

  data_points[date] = CovidDataPoint.new(data)
  data_points[date].confirmed_case_count += confirmed_case_count_offset if data_points[date].confirmed_case_count
end


data_points.each do |_date, data_point|
  puts data_point.to_json
end
