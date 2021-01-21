require 'sinatra'
require 'discordrb'
require 'dotenv'

Dotenv.load

channel = 0

bot = Discordrb::Commands::CommandBot.new(
  :token => ENV["DISCORD_TOKEN"],
  :prefix => "$"
)

bot.command :start_mc do |event|
  p "Start Minecraft Server..."
  event.respond("サーバーを起動します...")
end

bot.ready do
  bot.servers.each do |s|
    s[1].channels.each do |c|
      next if c.name != ENV["DISCORD_CHANNEL"]
      channel = c
      return
    end
  end
end

bot.run(true)

get '/health' do
  puts "hogehoge"
  'OK'
end

post '/server-down' do
  headers = request.env.select do |key, val|
    key.start_with?("HTTP_")
  end

  if headers["HTTP_AUTHORIZATION"] != ENV["ALLOW_KEY"] then
    return 'Authentication Failed'
  end

  channel.send_message("まもなくサーバーが停止します。\n再起動するには、`start_mc`コマンドを使ってください。")

  return 'OK'
end