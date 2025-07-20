book=$(ls ~/Documents/Books | dmenu)
[ -z "$book" ] && exit

zathura $(fd "$book" ~/Documents/Books)
