#
# .csファイルがbom付きutf8でない場合、
# 日本語が文字化けするため、
# .csファイルをbom付きutf8で保存するbashスクリプト.
# 変換にはnkfコマンドを使用する.
# 第一引数には、サーチディレクトリを指定する.
# ディレクトリ以外を指定した場合は、何もしない.
# 引数が無い場合はカレントディレクトリを設定する.
#
# ファイル名にスペースが含まれているファイルは変換時にエラーが起きる問題がある.
# 
# author: ishibashi@shed
# 

# error: illegal byte sequence 対策
LANG=C

# if nkf command not installed. 
if ! type nkf > /dev/null 2>&1; then
	echo 'Not found nkf command .ex) brew install nkf'
	exit 255
fi

dir=${1:-'.'}
if [ ! -d "$dir" ]; then
	echo "Not directory $dir."
	exit 1
fi
files=$(find $dir -name "*.cs" -type f -size +0)
for f in $files
do
	# is file?
	if [ -f "$f" ]; then
		# is bom file?
		echo $(file "$f") | grep "BOM" > /dev/null 2>&1
		bom=$?
		if [ $bom != 0 ]; then
			# convert utf8 bom and save.
			echo "Convert ${f}...."
			nkf -w8 --overwrite "$f"
			# dump result.
			file "$f"
		fi
	fi
done
