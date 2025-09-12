require 'colorize'
require_relative 'start_message'


def clear_screen
  print "\e[H\e[2J"
end


start = StartMessage.new

start.new_start

clear_screen

puts "Добро пожаловать в RUBY REALMS!"


loop do 



end