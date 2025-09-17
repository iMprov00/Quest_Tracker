require 'colorize'
require_relative 'start_message'
require 'win32/sound'
require 'json'
include Win32


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



class Menu

  def show_main_menu

  end

  def show_quests_menu

  end

  def show_quest_details(index)

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

#start.new_start

message.clear

puts "Добро пожаловать в RUBY REALMS!"
sleep(2)
message.clear
