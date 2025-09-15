require 'colorize'
require_relative 'start_message'
require 'win32/sound'
require 'json'
include Win32

class GameMap
  def initialize
    @map = GameJSON.new.parsed_data[:chapter]
    @user = UserJSON.new.parsed_data
  end

  def chapter
      puts "#{@map[(@user[:chapter]).to_sym][:name]}"
      puts "#{@map[(@user[:chapter]).to_sym][:quests]}"
  end
end

class PlayerStatistics 
  def initialize
    @user = UserJSON.new.parsed_data
  end

  def stat_player
    puts "\tСтатистика"
    puts "Имя: #{@user[:name]}"
    puts "Пройдено квестов: #{@user[:quests].length}"
    puts "Побеждено боссов: #{@user[:bosses].length}"
    puts "Уровень: #{( Math.sqrt(@user[:xp]) / 5 ).round} || XP: #{@user[:xp]}"
  end
end

class UserJSON
  attr_reader :parsed_data

  def initialize
    @file_path = File.join(__dir__, 'user.json') #сохраняем в переменную путь к файлу
    read_json
  end

  def read_json #метод чтения и парсинга 
    json_data = File.read(@file_path) # присваиваем переменной команду прочитать файл по пути
    @parsed_data = if File.exist?(@file_path)  #парсим файл
             json_data = File.read(@file_path)
             JSON.parse(json_data, symbolize_names: true)
           else
             {} # Если файла нет, создаем пустой массив задач
           end #парсим данные в переменную
  end
end

class GameJSON
  attr_reader :parsed_data

  def initialize
    @file_path = File.join(__dir__, 'game_map.json') #сохраняем в переменную путь к файлу
    read_json
  end

  def read_json #метод чтения и парсинга 
    json_data = File.read(@file_path) # присваиваем переменной команду прочитать файл по пути
    @parsed_data = if File.exist?(@file_path)  #парсим файл
             json_data = File.read(@file_path)
             JSON.parse(json_data, symbolize_names: true)
           else
             {} # Если файла нет, создаем пустой массив задач
           end #парсим данные в переменную
  end
end

class Messages
  def error
    puts "Некорректный ввод!"
  end
end

module Helper
  module_function

  def clear
    print "\e[H\e[2J"
  end
end


# # Запускаем воспроизведение звука в отдельном потоке
# sound_thread = Thread.new do
#   begin
#     # Попробуйте использовать ASYNC, если это возможно
#     Sound.play('sound.wav', Sound::ASYNC) # Если не работает, оставьте Sound.play('sound.wav')
#   rescue => e
#     puts "Ошибка воспроизведения звука: #{e.message}"
#   end
# end

start = StartMessage.new
message = Messages.new
map = GameMap.new
#start.new_start

Helper.clear

puts "Добро пожаловать в RUBY REALMS!"
sleep(2)
Helper.clear

statistics = PlayerStatistics.new
statistics.stat_player
sleep(5)

loop do 
  Helper.clear

  puts "\tМеню"
  puts "1. Отправиться в путь"
  puts "2. Посмотреть статистику"
  puts "3. Выйти"
  print "Ввод: "
  input = gets.to_i

  case input

  when 1
    Helper.clear
    map.chapter
    gets


  when 2
    Helper.clear
    statistics.stat_player
    sleep(5)
  when 3
    exit
  else
    Helper.clear
    message.error
    sleep(2)
  end

end