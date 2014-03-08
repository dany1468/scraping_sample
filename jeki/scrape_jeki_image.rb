# coding: utf-8

require 'open-uri'
require 'FileUtils'

class JekiAdvertisingAwardImageDownloader
  BASE_URL = 'http://www.jeki.co.jp/transit/grandprix'

  # NOTE 年度によっては存在しないものもあるが、全て定義している
  CATEGORIES = %w(grandprix station train signboard media campaign body planning jr)

  class << self
    def download_at(year)
      CATEGORIES.each do |category|
        puts "*** START #{year} #{category}"

        begin
          download year, category
        rescue OpenURI::HTTPError
          puts 'Not Found'
        end
      end
    end

    private

    def download(year, category)
      base_path = "#{BASE_URL}/#{year}/#{category}"
      dir_name = "./#{year}/#{category}/"

      image_paths(base_path).each do |image_path|
        image_url = "#{base_path}/#{image_path}"

        puts "*** Downloading... #{image_url}"
        save_image image_url, dir_name
      end
    end

    def image_paths(base_path)
      url = "#{base_path}/index.html"

      html = open(url).read

      # NOTE 入れ替えようの画像ファイル等は全て JavaScript で定義されているため、正規表現で取得
      html.scan(/new Image.*src = "?([^\s"]*)/i).map(&:first)
    end

    def save_image(url, dir_name)
      fileName = File.basename(url)
      filePath = dir_name + fileName

      FileUtils.mkdir_p(dir_name) unless FileTest.exist?(dir_name)

      open(filePath, 'wb') do |output|
        open(url) do |data|
          output.write(data.read)
        end
      end
    end
  end
end

YEARS = %w(2005 2006 2007 2008 2009 2010 2011 2012)

YEARS.each do |year|
  JekiAdvertisingAwardImageDownloader.download_at(year)
end
