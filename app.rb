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

  def save_task #метод для сохранения изменений в файл
    # Записываем обновленные данные обратно в файл
    File.open(@file_path, 'w') do |file|
      file.write(JSON.pretty_generate(@parsed_data))
    end
  end

  def edit(options={})
    xp = options[:xp]
    who = options[:who]
    name = options[:name]

    read_json #обновляем данные в переменной для парсинга
 
    @parsed_data[who] << name

    xp = @parsed_data[:xp].to_i + xp.to_i

    @parsed_data[:xp] = xp

    save_task #сохраняем эти данные в файл
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

  def save_task #метод для сохранения изменений в файл
    # Записываем обновленные данные обратно в файл
    File.open(@file_path, 'w') do |file|
      file.write(JSON.pretty_generate(@parsed_data))
    end
  end

  def edit(options={}) 
    current_chapter = options[:current_chapter]
    who = options[:who]
    index = options[:index]
    rep = options[:rep]

    read_json #обновляем данные в переменной для парсинга

    quests_data = @parsed_data[current_chapter.to_sym][who][index]

    quests_data[:rep] = rep
    quests_data[:completed] = true 

    options = {xp: quests_data[:xp], who: who, name: quests_data[:name]}

    UserJSON.new.edit(options)

    save_task #сохраняем эти данные в файл
  end

  # def user_data
  #   UserJSON.new.parsed_data
  # end

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
      puts "2. Боссы"
      puts "3. Статистика"
      puts "4. Выйти"
      print "Выберите вариант: "
      
      choice = gets.chomp.to_i
      
      case choice
      when 1
        show_quests_menu(:quests)
      when 2
        show_quests_menu(:bosses)
      when 3
        show_stats
      when 4
        exit
      else
        @screen.clear
        puts "Неверный выбор!"
        sleep(2)
      end
    end
  end

  def game_data
    GameJSON.new.parsed_data
  end

  def user_data
    UserJSON.new.parsed_data
  end

  def current_chapter
    user_data[:chapter]
  end

  def show_quests_menu(who)
    available_quests = game_data[current_chapter.to_sym][who].select {|q| q[:completed] == false }

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
        
        print "Выберите вариант: "
        choice = gets.chomp.to_i

        if choice == available_quests.size + 1 
          return
        elsif choice.between?(1, available_quests.size)
          show_quest_details(available_quests.size - 1, who)
          @screen.clear
          puts "Поздравляю, ты прошел это задание!"
          sleep(3)
          return
        else
          @screen.clear
          puts "Неверный выбор!"
          sleep(2)
        end #end if 2
      end #end if 1
    end #end loop
  end

  def show_quest_details(index, who)
    available_quests = game_data[current_chapter.to_sym][who][index]

    @screen.clear

    puts "=== #{available_quests[:name]} ==="
    puts "Описание: \t#{available_quests[:description]}"
    puts "Подробнее: \t#{available_quests[:other]}"
    puts 
    puts "Репозиторий: #{available_quests[:rep].empty? ? "пусто :(" : available_quests[:rep]}"
    puts
    print "Укажите репозиторий или 1 чтобы вернуться назад: "
    choice = gets.chomp
    
    if choice != "1"
      options = {current_chapter: current_chapter, who: who, index: index, rep: choice}
      GameJSON.new.edit(options)
    end #end if
  end

  def show_stats
    puts "=== Статистика ==="  
    puts "Пройдено заданий: #{user_data[:quests].size}"
    puts "Побеждено боссов: #{user_data[:bosses].size}"
    puts "Текущая глава: #{user_data[:chapter]}"
    puts ""
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
