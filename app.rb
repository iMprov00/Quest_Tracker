require 'colorize'
require_relative 'start_message'
require 'win32/sound'
include Win32

module ClearScreen
  module_function

  def clear
    print "\e[H\e[2J"
  end
end


# Запускаем воспроизведение звука в отдельном потоке
sound_thread = Thread.new do
  begin
    # Попробуйте использовать ASYNC, если это возможно
    Sound.play('sound.wav', Sound::ASYNC) # Если не работает, оставьте Sound.play('sound.wav')
  rescue => e
    puts "Ошибка воспроизведения звука: #{e.message}"
  end
end

start = StartMessage.new


start.new_start

ClearScreen.clear

puts "Добро пожаловать в RUBY REALMS!"


loop do 



end