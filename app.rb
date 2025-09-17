require 'colorize'
require_relative 'start_message'
require_relative 'keybord'
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

class TextArray
  def arr(text, x)
    view(text.split("/"), x)
  end

  def view(text, x)
    text.each_with_index do |value, index|
      if index == x 
        puts value.on_white.black
      else
        puts value
      end
    end
  end

end

class Messages
  def error
    puts "Некорректный ввод!"
  end

  def view(arr)
    arr.each do |value|
      puts "#{value}"
    end
  end

  def clear
    print "\e[H\e[2J"
  end
end

class TextGame

  def menu
    "Отправиться в путь/Посмотреть статистику/Выйти"
  end

end
#on_white.black
class PositionChoice
  attr_accessor :x

  def initialize
    @x = 0
  end

  def up(arr)
    @x = [@x - 1, 0].max
  end

  def down(arr)
    @x = [@x + 1, arr.length - 1].min
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
keyboard = KeyboardHandler.new
text_game = TextGame.new
text_arr = TextArray.new
position = PositionChoice.new

#start.new_start

message.clear

puts "Добро пожаловать в RUBY REALMS!"
sleep(2)
message.clear

  keyboard.on(:up) do 
    menu_items = text_game.menu.split("/")
    position.up(menu_items)
  end

  keyboard.on(:down) do 
    menu_items = text_game.menu.split("/")
    position.down(menu_items)
  end

  Thread.new { keyboard.start }

loop do 
  message.clear
  puts "\t Меню"
  text_arr.arr(text_game.menu, position.x)
  sleep 0.1
end