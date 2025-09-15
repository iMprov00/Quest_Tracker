require 'colorize'
require_relative 'start_message'
require 'win32/sound'
require 'json'
include Win32

class PlayerStatistics 
  def initialize
    @user = UserJSON.new.parsed_data
  end

  def stat_player
    puts "Статистика"
    puts "Имя: #{@user[:name]}"
    puts "Пройдено квестов: #{@user[:locations].length}"
    puts "Побеждено боссов: #{@user[:bosses].length}"
    puts "Уровень: #{( Math.sqrt(@user[:xp]) / 5 ).round} || XP: #{@user[:xp]}"
  end

  def user_json
    
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


module ClearScreen
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

#start.new_start

ClearScreen.clear

puts "Добро пожаловать в RUBY REALMS!"

statistics = PlayerStatistics.new
statistics.stat_player


loop do 



end