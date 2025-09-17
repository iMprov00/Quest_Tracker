require 'colorize'
require_relative 'start_message'
require 'win32/sound'
require 'json'
include Win32


require 'fiddle'
require 'fiddle/import'
require 'colorize'

class KeyboardHandler
  # Импортируем функции из msvcrt.dll
  module Console
    extend Fiddle::Importer
    dlload 'msvcrt.dll'
    extern 'int _kbhit()'
    extern 'int _getch()'
  end

  # Коды специальных клавиш
  SPECIAL_KEYS = {
    72 => :up,
    80 => :down,
    75 => :left,
    77 => :right,
    13 => :enter,
    27 => :escape,
    9 => :tab,
    8 => :backspace
  }

  # Буквенные клавиши
  LETTER_KEYS = {
    'a' => :a, 'A' => :a,
    'b' => :b, 'B' => :b,
    'c' => :c, 'C' => :c,
    'd' => :d, 'D' => :d,
    'e' => :e, 'E' => :e,
    'f' => :f, 'F' => :f,
    'g' => :g, 'G' => :g,
    'h' => :h, 'H' => :h,
    'i' => :i, 'I' => :i,
    'j' => :j, 'J' => :j,
    'k' => :k, 'K' => :k,
    'l' => :l, 'L' => :l,
    'm' => :m, 'M' => :m,
    'n' => :n, 'N' => :n,
    'o' => :o, 'O' => :o,
    'p' => :p, 'P' => :p,
    'q' => :q, 'Q' => :q,
    'r' => :r, 'R' => :r,
    's' => :s, 'S' => :s,
    't' => :t, 'T' => :t,
    'u' => :u, 'U' => :u,
    'v' => :v, 'V' => :v,
    'w' => :w, 'W' => :w,
    'x' => :x, 'X' => :x,
    'y' => :y, 'Y' => :y,
    'z' => :z, 'Z' => :z
  }

  def initialize
    @callbacks = {}
    @running = false
  end

  # Регистрация обработчика для клавиши
  def on(key, &block)
    @callbacks[key] = block
  end

  # Запуск прослушивания клавиш
  def start
    @running = true


    loop do
      break unless @running
      process_input
      sleep 0.01
    end
  end

  # Остановка прослушивания
  def stop
    @running = false
  end

  private

  def process_input
    return unless Console._kbhit() != 0

    key = Console._getch()
    key_symbol = nil

    # Обработка специальных клавиш (стрелки и т.д.)
    if key == 0 || key == 224
      key2 = Console._getch()
      key_symbol = SPECIAL_KEYS[key2]
     # puts "Специальная клавиша: #{key_symbol} (код: #{key2})" if key_symbol
    else
      # Обработка обычных клавиш
      char = key.chr
      key_symbol = SPECIAL_KEYS[key] || LETTER_KEYS[char] || char.to_sym
      
      if LETTER_KEYS[char]
       # puts "Буквенная клавиша: #{key_symbol}"
      elsif SPECIAL_KEYS[key]
        #puts "Специальная клавиша: #{key_symbol}"
      else
       # puts "Другая клавиша: #{char.inspect} (код: #{key})"
      end
    end

    # Вызов зарегистрированного обработчика
    if key_symbol && @callbacks[key_symbol]
      @callbacks[key_symbol].call(key_symbol)
    end
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