# Minecraft Discord Bot
- GCPで稼働しているMinecraft Serverを起動するためのDiscord Bot
- プリエンプティブインスタンスで、終了してしまった場合にサーバー側からAPIを叩くことで、Discordの方に終了したことを知らせるメッセージを送信することができます。

## 環境構築
- `docker build .`
- `docker-compose`などはお好みで
- デフォルトで`3000/tcp`を使用します