#!/bin/bash

THIS_DIR=$(cd $(dirname $0); pwd)
cd $THIS_DIR

logo() {
    declare -A logo
    seconds="0.004"
logo[0]="  .          '||    ||' '||'''|  '||    ||' '||'|.  '||'''|  '||''|."
logo[1]=".||.   ... .  |||  |||   || .     |||  |||   ||  ||  || .     ||   ||"
logo[2]=" ||   || ||   |'|..'||   ||'|     |'|..'||   ||''|.  ||'|     ||''|'"
logo[3]=" ||    |''    | '|' ||   ||       | '|' ||   ||   || ||       ||   |."
logo[4]=" '|.' '|||.  .|. | .||. .||....| .|. | .||. .||..|' .||....| .||.  '|'"
logo[5]="    .|...'"
logo[6]="➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖"
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

tgcli_version=1222
luarocks_version=2.4.2

lualibs=(
'oauth'
'lua-cjson'
'ansicolors'
'luasec'
'https://luarocks.org/luasec-0.6-1.rockspec'
'lub'
'dkjson'
'luaexpat'
'redis-lua'
'serpent'
)

today=`date +%F`

get_sub() {
    local flag=false c count cr=$'\r' nl=$'\n'
    while IFS='' read -d '' -rn 1 c; do
        if $flag; then
            printf '%c' "$c"
        else
            if [[ $c != $cr && $c != $nl ]]; then
                count=0
            else
                ((count++))
                if ((count > 1)); then
                    flag=true
                fi
            fi
        fi
    done
}

make_progress() {
exe=`lua <<-EOF
    print(tonumber($1)/tonumber($2)*100)
EOF
`
    echo ${exe:0:4}
}

function download_libs_lua() {
    if [[ ! -d "logs" ]]; then mkdir logs; fi
    if [[ -f "logs/logluarocks_${today}.txt" ]]; then rm logs/logluarocks_${today}.txt; fi
    local i
    for ((i=0;i<${#lualibs[@]};i++)); do
        printf "\r\33[2K"
        printf "\rtgAds: wait... [`make_progress $(($i+1)) ${#lualibs[@]}`%%] [$(($i+1))/${#lualibs[@]}] ${lualibs[$i]}"
        ./.luarocks/bin/luarocks install ${lualibs[$i]} &>> logs/logluarocks_${today}.txt
    done
    sleep 0.2
    printf "\nLogfile created: $PWD/logs/logluarocks_${today}.txt\nDone\n"
    rm -rf luarocks-2.2.2*
}

function update() {
  sudo git pull
  sudo git fetch --all
  sudo git reset --hard origin/master
  sudo git pull origin master
  sudo chmod +x TG
}

tg() {
 wget --progress=bar:force https://valtman.name/files/telegram-cli-${tgcli_version} 2>&1 | get_sub
        mv telegram-cli-${tgcli_version} telegram-cli; chmod +x telegram-cli
}

function configure() {
    if [[ -f "/usr/bin/lua5.3" ]] || [[ -f "/usr/bin/lua5.1" ]] || [[ -f "/usr/local/bin/lua5.3" ]]; then
    	sudo apt remove -y lua5.3
        echo -e "\033[0;31mplease wait...\033[0m\n"
     fi
    dir=$HOME
    wget http://luarocks.org/releases/luarocks-${luarocks_version}.tar.gz &>/dev/null
    tar zxpf luarocks-${luarocks_version}.tar.gz &>/dev/null
    cd luarocks-${luarocks_version}
    if [[ ${1} == "--no-null" ]]; then
        ./configure --prefix=$dir/.luarocks --sysconfdir=$dir/.luarocks/luarocks --force-config
        make bootstrap
    else
        ./configure --prefix=$dir/.luarocks --sysconfdir=$dir/.luarocks/luarocks --force-config &>/dev/null
        make bootstrap &>/dev/null
    fi
    cd ..; rm -rf luarocks*
    if [[ ${1} != "--no-download" ]]; then
        download_libs_lua
    fi
    for ((i=0;i<101;i++)); do
        printf "\rConfiguring... [%i%%]" $i
        sleep 0.007
    done
    printf "\nDone\n"
}

install() {
    sudo chmod +x config.bash
 sudo apt update -y && apt upgrade -y
  sudo apt-get install -f
	sudo dpkg -a --configure
	sudo apt-get dist-upgrade
	sudo sudo apt-get dist-upgrade
 echo -e "\e\n[38;5;035mUpdating packages\e\n\n"
		     sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
  sudo apt-get install c++ -y libreadline-dev -y libstdc++6 -y libnotify-dev -y libconfig-dev -y lua-lgi -y luarocks -y libssl-dev -y lua5.2 -y liblua5.2-dev -y libevent-dev -y libjansson-dev -y libpython-dev -y lua-socket -y lua-sec -y lua-expat -y make unzip git redis-server autoconf g++ -y expat libexpat1-dev -y
  echo -e "\\e[38;5;129mInstalling dependencies\e"
rm -rf README.md
    configure ${2}    
   rm -rf logs
tg
  sudo apt -y autoremove
  sudo service redis-server restart
  sudo service redis-server start
}

conf() {
AP="$THIS_DIR"/start.sh
if [ ! -f $AP ]; then
    echo "#!/usr/bin/env
     while true; do
       sudo tmux kill-session -t tgGuard
		sudo tmux new-session -s tgGuard "./telegram-cli --disable-link-preview -R -C -v -s tgGuard.lua -I -l 1 -E -p tgGuard -L log.txt"
        sudo tmux detach -s tgGuard
	done" >> start.sh
	chmod 777 start.sh
fi
}


start() {
while true; do
	sudo screen -S nohup ./start.sh
done
}

if [ ! -f "telegram-cli" ]; then
    install
    conf
else
   start
fi
