#!/bin/bash

# rsyncコマンドで、
# 開発サーバーの公開ディレクトリにファイルを同期する.
#
#
# rsyncのオプション
# -a:グループなど保持したまま同期
# -z:データ圧縮
# -v:処理中の経過ファイル名を表示
# -c:チェックサム有効
# --force:空でないディレクトリも削除
# --delete:コピー元にないファイルをコピー先から削除
# --existing: 更新されたファイルだけをコピーし、追加ファイルは無視 
# --dry-run: 実行時の動作だけを表示。テスト時に使用
# -n: --dry-runと同じ
# -u: 追加されたファイルだけをコピー
# --exclude=PATTERN: パターンに一致するファイルを除外
# --exclude-from=FILE: ファイルに記述されたパターンを除外
# --include=PATTERN: パターンに一致するファイルを除外しない
# --include-from=FILE: ファイルに記述されたパターンと一致するファイルは除外しない
# --stats: rsyncアルゴリズムの転送効率を表示
# -e:ssh用設定
#

RSYNC_OPTIONS='-azv -c --force --delete'
# ポート指定
export RSYNC_RSH="ssh -p1980"
# デプロイ先 
HOSTS='xx.xxx.xxx.xxx'
# デプロイユーザー
DEPLOY_USER='ishibashi'
# コピー元のディレクトリ
# 末尾の/ 有: ディレクトリ内のツリーをコピー
# 末尾に/ 無: ディレクトリも含めてコピー
SRC_DIR='/src/dev/'
# デプロイ先のディレクトリ
DST_DIR='/dst/dev'
# デプロイ除外ファイル
EXCLUDES='tmp .DS_Store .git logs/* .svn *.un~ .sass-cache .sass sass compass grunt *.sass *.bk index.php'
EXCLUDE_OPTION=""
for EXCLUDE in $EXCLUDES; do
	EXCLUDE_OPTION=$EXCLUDE_OPTION" --exclude="$EXCLUDE
done;

cmd=$1
for HOST in $HOSTS; do
	case $cmd in
		exec)
			# 同期を実行し、結果をファイルに出力.
			rsync $RSYNC_OPTIONS --progress $EXCLUDE_OPTION $SRC_DIR $DEPLOY_USER@$HOST:$DST_DIR > _dev.apps.exec.txt
		;;
		*)
			# テスト用: 結果をファイルに出力.
			rsync $RSYNC_OPTIONS --dry-run $EXCLUDE_OPTION $SRC_DIR $DEPLOY_USER@$HOST:$DST_DIR > _dev.apps.check.txt
			# テスト用: 結果をコンソールに出力.
			rsync $RSYNC_OPTIONS --dry-run $EXCLUDE_OPTION $SRC_DIR $DEPLOY_USER@$HOST:$DST_DIR
		;;
	esac
done;

