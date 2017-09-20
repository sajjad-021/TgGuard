#!/usr/bin/env bash

THIS_DIR=$(cd "$(dirname "$0")"; pwd)
cd "$THIS_DIR"

function logo() {
    declare -A logo
    seconds="0.002"
logo[0]="  .          '||    ||' '||'''|  '||    ||' '||'|.  '||'''|  '||''|."
logo[1]=".||.   ... .  |||  |||   || .     |||  |||   ||  ||  || .     ||   ||"
logo[2]=" ||   || ||   |'|..'||   ||'|     |'|..'||   ||''|.  ||'|     ||''|'"
logo[3]=" ||    |''    | '|' ||   ||       | '|' ||   ||   || ||       ||   |."
logo[4]=" '|.' '|||.  .|. | .||. .||....| .|. | .||. .||..|' .||....| .||.  '|'"
logo[5]="    .|...'"
logo[6]=""
logo[7]="Channel : @tgMember"
logo[8]="Develop by @sajjad_021"
printf "\e[38;5;213m\t"
    for i in ${!logo[@]}; do
        for x in `seq 0 ${#logo[$i]}`; do
            printf "${logo[$i]:$x:1}"
            sleep $seconds
        done
        printf "\n\t"
    done
printf "\n"
}

function update() {
  sudo git pull
  sudo git fetch --all
  sudo git reset --hard origin/master
  sudo git pull origin master
  sudo chmod +x TG
}

tgcli_version=1214

lualibs=(
'luasec'
'socket'
'luarepl'
'lbase64 20120807-3'
'luafilesystem'
'lub'
'auth'
'lua-term'
'Lua-cURL'
'multipart-post'
'lanes'
'multipart-post'
'luaexpat'
'redis-lua'
'lua-cjson'
'fakeredis'
'xml'
'dkjson'
'feedparser'
'serpent'
)

pkg=(
'git'
'wget'
'openssl'
'coreutils'
'make'
'gcc'
'libreadline-dev'
'libssl-dev'
'redis-server'
'libssl-dev'
'unzip'
'libexpat1-dev'
'libconfig-dev'
'tmux'
'lua5.2'
'liblua5.2-dev'
'lua-socket'
'lua-sec'
'lua-expat'
'libevent-dev'
'autoconf'
'g++'
'libjansson-dev'
'expat'
'luarocksv'
)

today=`date +%F`

function download_libs_lua() {
    if [[ ! -d "logs" ]]; then mkdir logs; fi
    if [[ -f "logs/logluarocks_${today}.txt" ]]; then rm logs/logluarocks_${today}.txt; fi
    local i
    for ((i=0;i<${#lualibs[@]};i++)); do
        printf "\r\33[2K"
        printf "\rtgAds: Please Wait ... [$(($i+1))/${#lualibs[@]}] ${lualibs[$i]}"
        "$THIS_DIR"/.luarocks/bin/luarocks install ${lualibs[$i]} &>> logs/logluarocks_${today}.txt
    done
    sleep 0.2
    printf "\nLogfile created: $PWD/logs/logluarocks_${today}.txt\nDone\n"
}

function configure() {
    if [[ -f "/usr/bin/lua5.3" ]] || [[ -f "/usr/bin/lua5.1" ]] || [[ -f "/usr/local/bin/lua5.3" ]]; then
    	sudo apt remove -y lua5.3 &>/dev/null
	    sudo apt -y autoremove &>/dev/null
	    sudo apt install -y lua5.2 &>/dev/null
      echo -e "\n\033[0;31m TeleGram Advertising Download Libs ... \033[0m\n"
     fi
  	git clone https://github.com/keplerproject/luarocks.git &>/dev/null
  	cd luarocks
	
  	PREFIX="$THIS_DIR/.luarocks"

  	./configure --prefix="$PREFIX" --sysconfdir="$PREFIX"/luarocks --force-config &>/dev/null
  	make build &>/dev/null
	sudo make install &>/dev/null
	make bootstrap &>/dev/null
		cd ..
		rm -rf luarocks
    if [[ ${1} != "--no-download" ]]; then
        download_libs_lua
    fi
    for ((i=0;i<101;i++)); do
        printf "\rConfiguring... [%i%%]" $i
        sleep 0.007
    done
    printf "\nDone\n"
}

function installation() {
for i in $(seq 1 100); do  
    sleep 0.1
    sudo apt-get -y install $pkg &>/dev/null
    if [ $i -eq 100 ]; then
        echo -e "XXX\n100\nDone!\nXXX"
    elif [ $(($i % 4)) -eq 0 ]; then
        let "is = $i / 4"
        echo -e "XXX\n$i\n${pkg[is]}\nXXX"
    else
        echo $i
    fi 
done | whiptail --title 'TeleGram Guard Robot Install and Configuration' --gauge "${pkg[0]}" 6 60 0
}

api() {
	 echo -e "\n\033[38;5;27mPut your Token\n\033[38;5;208m\n\033[6;48m\n"
read -rp '' TKN
 echo "#!/bin/bash
	while true; do
       		sudo tmux kill-session -t tgGuard
			sudo tmux new-session -s tgGuard './telegram-cli --disable-link-preview -R -C -v -s tgGuard.lua -I -l 1 -E -p tgGuard --bot=$TKN -L Log-api.txt &>/dev/null'
        	sudo tmux detach -s tgGuard
	done" >> start
	chmod +x start
}

cli() {
    echo "#!/bin/bash
     while true; do
       sudo tmux kill-session -t tgGuard
		sudo tmux new-session -s tgGuard ./telegram-cli --disable-link-preview -R -C -v -s tgGuard.lua -I -l 1 -E -p tgGuard -L log.txt &>/dev/null'
        sudo tmux detach -s tgGuard
	done" >> start
	chmod +x start
}

conf() {
AP="$THIS_DIR"/start
if [ ! -f $AP ]; then
 echo -e "\n\033[1;32mA\033[0;00m for config api \033[1;34m<=API & CLI=>\033[0;00m for config cli bot \033[1;32mC\033[0;00m\n"
read -p "[A/C] = "
if [ "$REPLY" == "a" ] || [ "$REPLY" == "A" ]; then
	api
    elif [ "$REPLY" == "c" ] || [ "$REPLY" == "C" ]; then
	cli
fi
fi
}

if [ "$1" = "upgrade" ]; then
update
fi

start() {
while true; do
	screen -S nohup ./start
done
}

if [ ! -f "telegram-cli" ]; then
  	chmod 777 config.bash
	logo
	installation
	rm -rf README.md
 	configure
	wget "https://valtman.name/files/telegram-cli-1222" &>/dev/null
	rm -rd logs
	mv telegram-cli-1222 telegram-cli; chmod +x telegram-cli
else
 	conf
	start
fi
