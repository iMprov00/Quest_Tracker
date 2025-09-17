require 'fiddle'
require 'fiddle/import'

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
