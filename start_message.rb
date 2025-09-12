class StartMessage

  def clear_scren
    print "\e[H\e[2J"
  end

  def sleep_dialog
    sleep(0.05)
  end

  def dialog_each(text)
    text.each do |i|
      print i 
      sleep_dialog
    end
  end

  def dialog_split(text)
    dialog_each(text.split(''))
  end



  def new_start
    clear_scren

    print ">> "
    sleep(1)

    dialog_split("SYSTEM BOOT...")

    puts

    print ">> "
    sleep(1)

    dialog_split("LOADING PROTOCOL: LEGACY_CORE...")
    sleep(1)

    clear_scren

    arr = 
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

    arr.each do |i|

      dialog_split(i)
      sleep(2)
      clear_scren
    end

    puts "..."
    sleep(1)

    print ">> "
    sleep(1)

    dialog_split("YOUR_JOURNEY_BEGINS_NOW")

    sleep(1)
    clear_scren

    print ">> "
    sleep(1)

    dialog_split("RUN: quest_tracker.rb")

    sleep(1)
    clear_scren

    print '...'
    sleep(2)
  end

end

