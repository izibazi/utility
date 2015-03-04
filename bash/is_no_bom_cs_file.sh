#
# bomがついていないcsファイルを出力する.
# 第一引数には、サーチディレクトリを指定する.
# ディレクトリ以外を指定した場合は、何もしない.
# 引数が無い場合はカレントディレクトリを設定する.
#
# author: ishibashi@shed
# 

# error: illegal byte sequence 対策
LANG=C

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
			file "$f"
		fi
	fi
done
