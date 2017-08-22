#!/bin/bash 

THIS_DIR=$(cd $(dirname $0); pwd)
cd $THIS_DIR

luarocks_version=2.4.2

lualibs=(
'oauth'
'lua-cjson'
'ansicolors'
'luasec'
'https://luarocks.org/luasec-0.6-1.rockspec'
'lub'
'luaexpat'
'redis-lua'
'serpent'
)

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

log() {
  echo -e "\033[38;5;105m .               /|\,/ |\,  ,- _~,   /\|,/ \|,   - _,,     ,- _~,  -_ /\,\033[0;00m"
  echo -e "\033[38;5;142m||    _          /| || ||   (' /| /  /| || ||     -/  )   (' /| /   || ,,\033[0;00m"
  echo -e "\033[38;5;099m=||=  / \\        || || ||  ((  ||/=  || || ||    ~||_<   ((  || =  /|| /|.\033[0;00m"
  echo -e "\033[38;5;034m||  || ||        ||=|= ||  ((  ||    ||=|= ||     || |\  (( |||    \||/-\,\033[0;00m"
  echo -e "\033[38;5;406m||  || ||       ~|| || ||   ( / |   ~|| || ||     ,/--||  (   |     ||  \.,\033[0;00m"
  echo -e "\033[38;5;129m||  \|_-|        |, |\,|\,   -____-  |, |\,|\,   _--_-'    -____- _---_-|.\033[0;00m"
         echo -e "\033[38;5;129m||   -_-_\033[0;00m"
            echo -e "\033[38;5;129m,_-_-\.\033[0;00m"
 }

tg() {
echo -e "\e[38;5;099minstall telegram-cli\e"
    rm -rf ../.telegram-cli
    wget https://valtman.name/files/telegram-cli-1222
    mv telegram-cli-1222 telegram-cli
    chmod +x telegram-cli
}

make_progress() {
exe=`lua <<-EOF
    print(tonumber($1)/tonumber($2)*100)
EOF
`
    echo ${exe:0:4}
}

install2() {
echo -e "\e[38;5;034mInstalling more dependencies\e"
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y; sudo apt-get -y upgrade; sudo apt-get -y update
  sudo apt-get install git redis-server libreadline-dev -y libconfig-dev -y lua-socket -y lua-sec -y lua-expat -y libevent-dev -y libconfig8-dev libjansson-dev lua5.2 liblua5.2-dev lua-lgi glib-2.0 libnotify-dev libssl-dev libssl1.0.0 make libstdc++6 g++-4.9 unzip autoconf g++ -y libpython-dev -y expat libexpat1-dev -y libreadline-gplv2-dev libreadline5-dev tmux -y
 sudo apt-get install lua5.1 luarocks lua-socket lua-sec redis-server curl
}

function download_libs_lua() {
    if [[ ! -d ".logs" ]]; then mkdir .logs; fi
    if [[ -f ".logs/logluarocks_${today}.txt" ]]; then rm .logs/logluarocks_${today}.txt; fi
    local i
    for ((i=0;i<${#lualibs[@]};i++)); do
        printf "\r\33[2K"
        printf "\rtgAds: wait... [`make_progress $(($i+1)) ${#lualibs[@]}`%%] [$(($i+1))/${#lualibs[@]}] ${lualibs[$i]}"
        sudo ./.luarocks/bin/luarocks install ${lualibs[$i]} &>> .logs/logluarocks_${today}.txt
    done
    sleep 0.2
    printf "\nLogfile created: $PWD/.logs/logluarocks_${today}.txt\nDone\n"
    rm -rf luarocks-2.2.2*
}

function configure() {
    dir=$PWD
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
    for ((i=0;i<101;i++)); do
        printf "\rConfiguring... [%i%%]" $i
        sleep 0.007
    done
    printf "\nDone\n"
}

install() {
echo -e "\e[38;5;035mUpdating packages\e"
   sudo apt-get update -y
   sudo apt-get upgrade -y

echo -e "\\e[38;5;129mInstalling dependencies\e"
install2
configure
sudo apt -u update && sudo apt -y upgrade && sudo apt -y autoclean && sudo apt -y 
echo -e "\e[38;5;046mInstalling packages successfully\033[0;00m"
}

if [ "$1" = "install" ]; then
install
fi

if [ "$1" = "api" ]; then
while true; do
screen -S nohup lua api.lua
done
fi

if [ "$1" = "bot" ]; then
while true; do
screen -S nohup ./telegram-cli -s tgGuard.lua
done
fi

if [ ! -f telegram-cli ]; then
    echo -e "\033[38;5;208mError! telegram-cli not found, Please reply to this message:\033[1;208m"
    read -p "Do you want to install and config? [y/n] = "
	if [ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]; then
	chmod 777 make.sh
        install
    elif [ "$REPLY" == "n" ] || [ "$REPLY" == "N" ]; then
        exit 1
  fi
fi
