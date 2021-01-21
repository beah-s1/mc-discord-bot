# Minecraft Discord Bot
- GCPで稼働しているMinecraft Serverを起動するためのDiscord Bot
- プリエンプティブインスタンスで、終了してしまった場合にサーバー側からAPIを叩くことで、Discordの方に終了したことを知らせるメッセージを送信することができます。

## 環境構築
- `docker build .`
- `docker-compose`などはお好みで
- デフォルトで`3000/tcp`を使用します
- 直下に、GCP Consoleで作成したサービスアカウントのCredentialを含んだJSON Fileを`credential.json`として作成します（デフォルトでgitignoreされています）

- 環境変数は以下の通り作成します
```dotenv
DISCORD_CLIENT_ID=DiscordBotのクライアントID
DISCORD_TOKEN=DiscordBotのToken
DISCORD_CHANNEL=通知を行う先のDiscordチャンネル名
ALLOW_KEY=GCEから操作を行う際のAPIキー（いたずら防止）
GOOGLE_CLOUD_PROJECT_ID=操作対象のGCEインスタンスが含まれるプロジェクトID
GOOGLE_CLOUD_ZONE=操作対象のGCEインスタンスを含んでいるゾーン（≠リージョン）
GOOGLE_CLOUD_INSTANCE_NAME=操作対象のGCEインスタンス名
```
