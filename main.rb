require 'sinatra'
require 'discordrb'
require 'dotenv'
require 'googleauth'
require 'google-apis-compute_v1'

Dotenv.load

gce_instance = 0

# Google Cloud APIの認証
gce_client = Google::Apis::ComputeV1::ComputeService.new
gce_client.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: File.open("credential.json"),
  scope: ["https://www.googleapis.com/auth/compute"]
)

# 有効なインスタンスリストの取得
gce_client.list_instances(ENV["GOOGLE_CLOUD_PROJECT_ID"], ENV["GOOGLE_CLOUD_ZONE"]).items.each do |instance|
  next if instance.name != ENV["GOOGLE_CLOUD_INSTANCE_NAME"]

  gce_instance = instance
  break
end

# Discord Botのinitialize
channel = 0

bot = Discordrb::Commands::CommandBot.new(
  :token => ENV["DISCORD_TOKEN"],
  :prefix => "$"
)

bot.command :start_mc do |event|
  p "Start Minecraft Server..."

  gce_client.start_instance(ENV["GOOGLE_CLOUD_PROJECT_ID"], ENV["GOOGLE_CLOUD_ZONE"], gce_instance.name)
  event.respond("サーバーを起動しました")
end

bot.command :stop_mc do |event|
  p "Stop Minecraft Server..."

  gce_client.stop_instance(ENV["GOOGLE_CLOUD_PROJECT_ID"], ENV["GOOGLE_CLOUD_ZONE"], gce_instance.name)
end

# 状態を送信するためのチャンネルを探索して、セットする
bot.ready do
  bot.servers.each do |s|
    s[1].channels.each do |c|
      next if c.name != ENV["DISCORD_CHANNEL"]
      channel = c
      break
    end
  end
end

# バックグラウンドでbotを起動
bot.run(true)

# Sinatra関係（APIによるインターフェース）
get '/health' do
  puts "hogehoge"
  'OK'
end

post '/server-down' do
  # サーバーが終了する際に呼ぶAPI、いたずら防止のために、APIキーを設定
  headers = request.env.select do |key, val|
    key.start_with?("HTTP_")
  end

  if headers["HTTP_AUTHORIZATION"] != ENV["ALLOW_KEY"] then
    return 'Authentication Failed'
  end

  channel.send_message("まもなくサーバーが停止します。\n再起動するには、`$start_mc`コマンドを使ってください。")

  return 'OK'
end