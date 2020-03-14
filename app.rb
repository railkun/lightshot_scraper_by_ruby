require_relative 'scrap'

class App
  def self.run
    new.run
  end

  def run
    loop do
      system('clear')

      app

      print 'Do you want to continue?
      Y/N
      '
      answer = gets.chop
      break unless answer == 'Y'

    end
  end

  def app
    system('clear')

    p 'Enter how many images you want to scrap?'

    length = gets.to_i
    scrap = Scrap.new
    scrap.start_scraping(length)
  end
end

App.run
