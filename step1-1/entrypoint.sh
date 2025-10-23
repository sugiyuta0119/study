#!/bin/bash
set -e

# メインプロセスを管理するためのPID変数
APP_PID=0

# クリーンアップ処理を定義する関数
function cleanup {
  echo "SIGTERMを受信しました。クリーンアップを実行します..."
  
  # メインプロセスにシグナルを転送
  if [ "$APP_PID" -ne 0 ]; then
    echo "メインプロセスの終了処理に入ります"
    kill -SIGTERM "$APP_PID"
    echo "メインプロセスの終了待ちです"
    wait $APP_PID || true
    echo "メインプロセスが終了しました"
  fi
  
  # その他のクリーンアップ処理（一時ファイルの削除など）
  echo "クリーンアップが完了しました。"
  /bin/sync
  exit 0
}

# SIGTERMシグナルを捕捉するように設定
trap cleanup SIGTERM

# --- 起動前処理 ---
echo "起動前処理を実行..."
# ここに必要な起動前処理を記述
# 例: データベースのマイグレーション、設定ファイルの生成
# migrate_db.sh
# generate_config.sh

# --- メインプロセスの起動 ---
echo "メインプロセスを起動します: $@"
# CMDで指定されたコマンドをバックグラウンドで実行
"$@" &
APP_PID=$!

# --- メインプロセスの終了を待機 ---
# waitコマンドでメインプロセスが終了するまで待機
wait $APP_PID || true
echo "何らかの理由でメインプロセスが終了しました"
/bin/sync

# スクリプトのクリーンアップ関数が呼ばれなかった場合に、
# メインプロセスの終了コードで終了
exit $?
