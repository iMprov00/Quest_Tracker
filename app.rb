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

class Screen
  def clear
    print "\e[H\e[2J"
  end
end

class Menu
  def initialize
    @screen = Screen.new
  end

  def show_main_menu
    loop do
      @screen.clear
      puts "=== RUBY REALMS ==="
      puts "1. Мои задания"
      puts "2. Статистика"
      puts "3. Выйти"
      print "Выберите вариант: "
      
      choice = gets.chomp.to_i
      
      case choice
      when 1
        show_quests_menu
      when 2
        show_stats
      when 3
        exit
      else
        @screen.clear
        puts "Неверный выбор!"
        sleep(2)
      end
    end
  end

  def show_quests_menu
    user_data = UserJSON.new.parsed_data
    game_data = GameJSON.new.parsed_data
    current_chapter = user_data[:chapter]

    available_quests = game_data[current_chapter.to_sym][:quests].select {|q| q[:completed] == false }

    loop do
      @screen.clear
      puts "=== #{game_data[current_chapter.to_sym][:name]} ==="

      if available_quests.empty?
        puts "Ты уже выполнил все задания в этой главе!"
        sleep(3)
        return
      else
        available_quests.each_with_index do |value, index|
          puts "#{index + 1}. #{value[:name]}"
        end
        puts "#{available_quests.size + 1}. Назад"
        
        choice = gets.chomp.to_i

        if choice == available_quests.size + 1 
          return
        elsif choice.between?(1, available_quests.size)
          show_quest_details(available_quests.size - 1)
        else
          @screen.clear
          puts "Неверный выбор!"
          sleep(2)
        end #end if 2
      end #end if 1
    end #end loop
  end

  def show_quest_details(index)
    game_data = GameJSON.new.parsed_data


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
screen = Screen.new
menu = Menu.new

#start.new_start

screen.clear

puts "Добро пожаловать в RUBY REALMS!"
sleep(2)

loop do 
  menu.show_main_menu
end
