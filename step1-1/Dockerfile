# ベースイメージ
FROM mycat 

# entrypoint.shをコンテナにコピー
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# 実行可能にする
RUN chmod +x /usr/local/bin/entrypoint.sh

# ENTRYPOINTとしてスクリプトを指定
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# CMDで実行するアプリケーションを引数として指定
CMD ["catalina.sh", "run"]
