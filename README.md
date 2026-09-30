# KARTE In-App Messaging × Flutter — タブ高速切替時に UI が操作不能になる事象の再現サンプル

## 事象の概要

KARTE の接客(In-App Messaging)ポップアップが表示されている状態で、
view イベントを送るタブボタンを素早く連続タップすると、Flutter 側の UI が
タッチに反応しなくなります(ボタンを押してもログが進まない)。

- ポップアップは view イベントごとに再表示される(タブ切替のたびに閉じて開く)。
- 事象発生後、しばらく待つか別の場所を 1 回タップすると復帰することがあります。
- Flutter 側にはカスタムのジェスチャー処理は一切ありません。
  サンプルは `Tracker.view` を送るボタン 5 つとログ表示のみです。

## 構成

| 項目 | 値 |
|---|---|
| Flutter | 3.38.x |
| karte_core / karte_in_app_messaging (Flutter plugin) | 2.2.0 |
| io.karte.android:inappmessaging | 2.27.0 |
| Edge-to-edge | Android 11 以上で有効(`InAppMessagingConfig.isEdgeToEdgeEnabled`) |

主要ファイル:

- `lib/main.dart` — 画面本体(タブボタン 5 つ + ログ)
- `android/app/src/main/kotlin/.../App.kt` — `KarteApp.setup`
- `android/app/src/main/kotlin/.../MainActivity.kt` — システムバー裏への描画設定(本番アプリと同じ)

## 事前準備

1. `android/local.properties` に APP KEY を追記する(このファイルは git 管理外)。

   ```properties
   karte.appKey=YOUR_APP_KEY
   ```

2. 対象プロジェクトで、以下の view 名をトリガーにポップアップを表示する
   接客キャンペーンを 1 件作成・公開する(画面中央のダイアログ型を推奨。
   配信頻度は「毎回」にし、view イベントごとに再表示されるようにする)。

   - `order:new_normal:input`
   - `order:new_ifd:input`
   - `order:new_oco:input`
   - `order:new_ifdoco:input`
   - `order:new_trail:input`

## 再現手順

1. `flutter pub get` → `flutter run`(実機推奨)。
2. 画面上部のタブボタン(通常 / IFD / OCO / IFDOCO / トレール)を 1 つタップし、
   ポップアップが表示されることを確認する。
3. ポップアップを閉じずに、タブボタンを左右に素早く連続でタップする
   (ポップアップが閉じる→開くを繰り返す状態)。
4. 数回〜十数回で、ボタンをタップしてもログが増えなくなり UI が反応しなくなる。

## 期待する動作

ポップアップの再表示中でも、Flutter 側の UI が継続してタッチに反応すること。
