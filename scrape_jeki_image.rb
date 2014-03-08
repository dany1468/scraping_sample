# coding: utf-8

require 'open-uri'
require 'nokogiri'

url = 'http://www.jeki.co.jp/transit/grandprix/2005/index.html'

charset = nil
html = open(url) do |f|
  charset = f.charset
  f.read
end
if charset == "iso-8859-1"
  charset = html.scan(/charset="?([^\s"]*)/i).first.join
end

doc = Nokogiri::HTML.parse(html, nil, charset)

p doc.title
