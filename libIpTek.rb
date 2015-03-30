#encoding: utf-8

require 'pry'
require 'mechanize'

class ScrapIpTek
  URL = "https://intra.epitech.eu/"
  USER_AGENT = "Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36"
  LOGIN = ENV['USER']

  attr_accessor :target
  alias name target
  alias name= target=
  # @param password [String] your password (to connect with the intra)
  # @param login [String] your login (to connect with the intra)
  # @param target [String] target of your target
  def initialize password, login = nil, target = nil
    @target = target
    @a = Mechanize.new
    @a.user_agent = USER_AGENT
    login = login || LOGIN

    connect_to_intranet(login, password)
    pry if $debug
  end

  def connect_to_intranet(login, password)
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
  end

  # @param target [String] target of your target. By default, use the target specified by @target
  # @return [Array] array of [String] of ips
  def ips(target = nil)
    @a.get(URL + "user/#{target || @target}")
    pry if $debug
    return @a.page.body.match(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/).to_a.uniq
  end

  # @param target [String] target of your target. By default, use the target specified by @target
  # @return [String or nil] ip or [nil] if no ip
  def ip(target = nil)
    return ips(target).first
  end

  def self.ips password, login, target
    ScrapIpTek.new(password, login).ips
  end

  def self.ip password, login, target
    ScrapIpTek.new(password, login, target).ip
  end

end

require 'io/console'
def get_password(prompt="Unix Password: ")
  print prompt
  p = STDIN.noecho(&:gets).chomp
  puts
  p
end
