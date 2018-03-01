find . -name "*.sh" -print0 | while read -d $'\0' var; do
	echo $var
done
