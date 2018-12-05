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

result = []
text=File.open(INPUT_FILE).read
# text.gsub!(/\n/, "")
text.each_line do |line|
  linex = line.split(' ')
  start_at = to_timestamp linex[0].split('-')[3]
  end_at = to_timestamp linex[0].split('-')[4]
  content = linex[1] ? linex[1..-1].join(' ') : ''
  result << "#{start_at},#{end_at}\n#{content}\n" if linex[1]
end

%x(touch output.sbv)
File.open('output.sbv', 'w') { |file| file.write(result.join("\n")) }
