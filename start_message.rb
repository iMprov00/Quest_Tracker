class SplitText
  def dialog_each(text)
    text.each do |i|
      print i 
      sleep(0.05)
    end
  end

  def dialog_split(text)
    dialog_each(text.split(''))
  end
end

class StartMessage

  def initialize
    @dialog = SplitText.new
  end

  def sleep_dialog
    sleep(1)
  end

  def clear_scren
    print "\e[H\e[2J"
  end

  def new_start
    clear_scren

    print ">> "
    sleep_dialog

    @dialog.dialog_split("SYSTEM BOOT...")

    puts

    print ">> "
    sleep_dialog

    @dialog.dialog_split("LOADING PROTOCOL: LEGACY_CORE...")
    sleep_dialog

    clear_scren

    text = 
    [
      "Царство чистого кода пало...",
      "Из глубин системы пробудился МОРДЕКОД — воплощение хаоса, порождённое спагетти-кодом и забытыми багами",
      "Его оружие — Legacy Code, превращающее логику в извивающихся тварей",
      "Его дыхание выжигает саму реальность ошибками NullPointerException",
      "Ты — СТРАЖ СИНТАКСИСА, последняя аномалия, способная видеть код и намерение за ним",
      "Начни путь на руинах Деревни Новичков. Пройди чащобу Объектов и Классов, защити Городские Ворота и пересеки выжженную Пустошь Алгоритмов",
      "Каждая строка кода — удар по тьме",
      "Каждая программа — шаг к победе"
    ]

    text.each do |value|
      @dialog.dialog_split(value)
      sleep_dialog
      sleep_dialog
      clear_scren
    end

    puts "..."
    sleep_dialog

    print ">> "
    sleep_dialog

    @dialog.dialog_split("YOUR_JOURNEY_BEGINS_NOW")

    sleep_dialog
    clear_scren

    print ">> "
    sleep_dialog

    @dialog.dialog_split("RUN: quest_tracker.rb")

    sleep_dialog
    clear_scren

    print '...'
    sleep_dialog
    sleep_dialog
    clear_scren
  end

end

