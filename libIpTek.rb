#encoding: utf-8

class ScrapIpTek
  URL = "https://intra.epitech.eu/"
  USER_AGENT = "Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36"
  LOGIN = ENV['USER']

  attr_accessor :name
  # @param password [String] your password (to connect with the intra)
  # @param login [String] your login (to connect with the intra)
  # @param name [String] name of your target
  def initialize password, login = nil, name = nil
    @name = name
    @a = Mechanize.new
    @a.user_agent = USER_AGENT
    login = login || LOGIN

    puts "Try to login..." if $verbose
    begin
      p = @a.get(URL)
    rescue Mechanize::ResponseCodeError => exception
      if exception.response_code == '403' then p = exception.page else raise end
    end
    puts "Page loaded..." if $verbose

    puts "Submission..." if $verbose
    p.form do |f|
      f['login'] = login
      f['password'] = password
    end.submit
    puts "Submited !" if $verbose
    pry if $debug
  end

  # @param name [String] name of your target. By default, use the target specified by @name
  # @return [Array] array of [String] of ips
  def ips(name = nil)
    @a.get(URL + "user/#{name || @name}")
    page = @a.page.body
    return page.match(/10\.41[\d\.]+/).to_a
  end

  # @param name [String] name of your target. By default, use the target specified by @name
  # @return [String or nil] ip or [nil] if no ip
  def ip(name = nil)
    return ips(name).first
  end

  def self.ips password, login, name
    ScrapIpTek.new(password, login).ips
  end

  def self.ip password, login, name
    ScrapIpTek.new(password, login, name).ip
  end

end

require 'io/console'
def get_password(prompt="Unix Password: ")
  print prompt
  p = STDIN.noecho(&:gets).chomp
  puts
  p
end
