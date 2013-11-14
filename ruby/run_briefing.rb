require 'nokogiri'
require 'open-uri'
require 'json'

# Get a Nokogiri::HTML::Document for the page we’re interested in...

HOST = 'http://www.briefing.com'

doc = Nokogiri::HTML(open('http://www.briefing.com/investor/calendars/economic/2013/11/'))

arr = []

def get_day_string(s)
  day = s.split(' ')
  "2013,11,#{day[1]}"
end

def get_obj(tds)
  day_string = get_day_string(tds[0].content)
  a = tds[2].search('a').first
  { :startDate => day_string,
    :endDate => day_string,
    :headline => tds[2].content + " at " + tds[1].content,
    :text => a.nil? ? tds[2].content : HOST + a['href']
  }
end

doc.search('table.calendar-table', '//tr').each do |tr|
  #p tr.content
  tds = tr.search('td')
  #p tds.size
  next unless tds.size == 9
  p "#{tds[0].content}, #{tds[1].content}, #{tds[2].content}"
  
  arr << get_obj(tds)
end

data = { :timeline => { 
            :headline => "Nov",
            :type => "default",
            :text => "Breifing",
            "startDate" => "2013,11,1",
            :date => arr
       } }


File.open('../11.json', 'w') { |f| f.write(JSON.pretty_generate(data) ) }