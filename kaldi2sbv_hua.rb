INPUT_FILE = 'input.txt'

def to_timestamp seconds 
  seconds = seconds.to_i
  m_second = seconds % 100
  seconds = seconds / 100
  hour = seconds / 360
  minute = seconds / 60
  second = seconds - 360*hour - 60*minute
  "#{hour}:#{minute.to_s.rjust(2, "0")}:#{second.to_s.rjust(2, "0")}.#{m_second}"
end

def to_hua content
  require "rubygems"
  require "json"
  require "net/http"
  require "uri"
  
  uri = URI.parse("http://10.32.0.120:8000/#{URI.encode(content)}")
  
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  
  response = http.request(request)
  
  if response.code == "200"
    result = JSON.parse(response.body)
    result["漢字"]
  else
    puts "ERROR!!!"
  end
end

result = []
text=File.open(INPUT_FILE).read
# text.gsub!(/\n/, "")
text.each_line do |line|
  linex = line.split(' ')
  start_at = to_timestamp linex[0].split('-')[3]
  end_at = to_timestamp linex[0].split('-')[4]
  content = linex[1] ? linex[1..-1].join(' ') : ''
  result << "#{start_at},#{end_at}\n#{to_hua(content)}\n" if linex[1]
end

%x(touch output.sbv)
File.open('output_hua.sbv', 'w') { |file| file.write(result.join("\n")) }
