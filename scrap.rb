require 'open-uri'
require 'pry'
require 'nokogiri'
require 'mechanize'
require 'yaml'

ERROR_LINKS = ['//st.prntscr.com/2020/02/10/0334/img/0_173a7b_211be8ff.png'].freeze
LENGTH_CODE = [4, 5, 6, 7].freeze

def validation_img_link(img_link)
  if ERROR_LINKS.include?(img_link)
    false
  else
    true
  end
end

def validation_code(code)
  code_array = YAML.load(File.read("code_array.yml"))
  if code_array.nil?
    code_array = Array.new
  else
  end

  if code_array.include?(code)
    false
  else
    code_array.push(code)
    File.open("code_array.yml", "w") { |file| file.write(code_array.to_yaml) }
  end
end

def get_random_code
  source = ("a".."z").to_a + (0..9).to_a
  code=""
  LENGTH_CODE.sample.times{ code += source[rand(source.size)].to_s }

  if validation_code(code)
    code
  else
    next
  end
end

def open_url(code)
  url = "https://prnt.sc/#{code}"
  html = open(url)
end

def parse_img(html)
  doc = Nokogiri::HTML(html)
  nodes = doc.xpath("//img[@src]")
  img_link = nodes[0].attributes['src'].value
end


def img_save(img_link, code)
  if validation_img_link(img_link)
    agent = Mechanize.new
    agent.get(img_link).save "img/#{code}.jpg"
    p 'all good'
  else
    next
  end
end

def app
  for i in 0..5
    code = get_random_code
    html = open_url(code)
    img_link = parse_img(html)
    img_save(img_link, code)
  end
end

app
