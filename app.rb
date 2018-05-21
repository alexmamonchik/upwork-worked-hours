require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/json'
require 'dotenv/load'
require 'date'
require 'upwork/api'
require 'upwork/api/routers/auth'
require 'upwork/api/routers/reports/time'
require './upwork_helper'

helpers UpworkApiWrapper

get '/' do
  begin
    now = Date.today
    monday = now - (now.wday - 1) % 7
    sunday = now + (7 - (now.wday))

    report_response = report.get_by_freelancer_limited(
      ENV['UPWORK_USERNAME'],
      tqx: 'out:json',
      tq: "select hours where worked_on >= '#{monday.strftime("%Y-%m-%d")}' AND worked_on <= '#{sunday.strftime("%Y-%m-%d")}' order by worked_on"
    )
    times = report_response['table']['rows'].map do |row|
      if row['c'].is_a?(Array)
        row['c'].map { |c| c['v'].to_f }.inject(:+)
      else
        row['c']['v'].to_f
      end
    end
    hours = times.inject(:+).to_f.floor(1)
  rescue => e
    puts e.message
    puts e.backtrace
  end

  json hours: (hours || '...')
end