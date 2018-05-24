#!/bin/zsh

function tput_test(){
    for fg_ in {0..7}; do
        sf=$(tput setaf $fg_)
        for bg_ in {0..7}; do
            sb=$(tput setab $bg_)
            echo -n $sb$sf
            printf ' F:%s B:%s ' $fg_ $bg_
        done
        echo $(tput sgr0)
    done
}

function 256colors(){
    for code in {0..255}; do echo -e "\e[38;05;${code}m $code: Test"; done
}

function color8_init(){
    for i in {0..8}; do 
        printf -v f$i %b "\e[38;05;${i}m"
    done
    bld=$'\e[1m'
    rst=$'\e[0m'
    inv=$'\e[7m'
    w=$'\e[37m'
}

function init_ansi() {
    esc=""

    Bf="${esc}[30m";   rf="${esc}[31m";   gf="${esc}[32m"
    yf="${esc}[33m";   bf="${esc}[34m";   pf="${esc}[35m"
    cf="${esc}[36m";   wf="${esc}[37m";

    Bb="${esc}[40m";  rb="${esc}[41m";  gb="${esc}[42m"
    yb="${esc}[43m"   bb="${esc}[44m";   pb="${esc}[45m"
    cb="${esc}[46m";  wb="${esc}[47m"

    ON="${esc}[1m";        OFF="${esc}[22m"
    italicson="${esc}[3m"; italicsoff="${esc}[23m"
    ulon="${esc}[4m";      uloff="${esc}[24m"
    invon="${esc}[7m";     invoff="${esc}[27m"

    reset="${esc}[0m"
}

function init_ansi2(){
  esc=""

  blackf="${esc}[30m";   redf="${esc}[31m";    greenf="${esc}[32m"
  yellowf="${esc}[33m"   bluef="${esc}[34m";   purplef="${esc}[35m"
  cyanf="${esc}[36m";    whitef="${esc}[37m"
  
  blackb="${esc}[40m";   redb="${esc}[41m";    greenb="${esc}[42m"
  yellowb="${esc}[43m"   blueb="${esc}[44m";   purpleb="${esc}[45m"
  cyanb="${esc}[46m";    whiteb="${esc}[47m"

  boldon="${esc}[1m";    boldoff="${esc}[22m"
  italicson="${esc}[3m"; italicsoff="${esc}[23m"
  ulon="${esc}[4m";      uloff="${esc}[24m"
  invon="${esc}[7m";     invoff="${esc}[27m"

  reset="${esc}[0m"
}


function crunchbang_mini(){
init_ansi2

cat << EOF

 ${reset}${redf}▄█▄█▄ ${reset}${boldon}${redf}█ ${reset}${greenf}▄█▄█▄ ${reset}${boldon}${greenf}█ ${reset}${yellowf}▄█▄█▄ ${reset}${boldon}${yellowf}█ ${reset}${bluef}▄█▄█▄ ${reset}${boldon}${bluef}█ ${reset}${purplef}▄█▄█▄ ${reset}${boldon}${purplef}█ ${reset}${cyanf}▄█▄█▄ ${reset}${boldon}${cyanf}█${reset} 
 ${reset}${redf}▄█▄█▄ ${reset}${boldon}${redf}▀ ${reset}${greenf}▄█▄█▄ ${reset}${boldon}${greenf}▀ ${reset}${yellowf}▄█▄█▄ ${reset}${boldon}${yellowf}▀ ${reset}${bluef}▄█▄█▄ ${reset}${boldon}${bluef}▀ ${reset}${purplef}▄█▄█▄ ${reset}${boldon}${purplef}▀ ${reset}${cyanf}▄█▄█▄ ${reset}${boldon}${cyanf}▀${reset}
 ${reset}${redf} ▀ ▀  ${reset}${boldon}${redf}▀ ${reset}${greenf} ▀ ▀  ${reset}${boldon}${greenf}▀ ${reset}${yellowf} ▀ ▀  ${reset}${boldon}${yellowf}▀ ${reset}${bluef} ▀ ▀  ${reset}${boldon}${bluef}▀ ${reset}${purplef} ▀ ▀  ${reset}${boldon}${purplef}▀ ${reset}${cyanf} ▀ ▀  ${reset}${boldon}${cyanf}▀${reset}
EOF
}

function pukeskull(){
    #
    #  ┳━┓┳━┓0┏┓┓┳━┓┏━┓┓ ┳
    #  ┃┳┛┃━┫┃┃┃┃┃━┃┃ ┃┃┃┃
    #  ┃┗┛┛ ┃┃┃┗┛┻━┛┛━┛┗┻┛
    #     ┳━┓┳ ┓┳┏ ┳━┓
    #     ┃━┛┃ ┃┣┻┓┣━ 
    #     ┇  ┗━┛┃ ┛┻━┛
    #    ┓━┓┳┏ ┳ ┓┳  ┳
    #    ┗━┓┣┻┓┃ ┃┃  ┃
    #    ━━┛┇ ┛┗━┛┗━┛┗━┛
    #
    # the worst color script
    # by xero <http://0w.nz>

    cat << 'EOF'
    [1;37m                  .................
    [1;37m             .syhhso++++++++/++osyyhys+.
    [1;37m          -oddyo+o+++++++++++++++o+oo+osdms:
    [1;37m        :dmyo++oosssssssssssssssooooooo+/+ymm+`
    [1;37m       hmyo++ossyyhhddddddddddddhyyyssss+//+ymd-
    [1;37m     -mho+oosyhhhddmmmmmmmmmmmmmmddhhyyyso+//+hN+
    [1;37m     my+++syhhhhdmmNNNNNNNNNNNNmmmmmdhhyyyyo//+sd:
    [1;37m    hs//+oyhhhhdmNNNNNNNNNNNNNNNNNNmmdhyhhhyo//++y
    [1;37m    s+++shddhhdmmNNNNNNNNNNNNNNNNNNNNmdhhhdhyo/++/
    [1;37m    'hs+shmmmddmNNNNNNNNNNNNNNNNNNNNNmddddddhs+oh/
    [1;37m     shsshdmmmmmNNMMMMMMMMMMMNNNNNNNNmmmmmmdhssdh-
    [1;37m      +ssohdmmmmNNNNNMMMMMMMMNNNNNNmmmmmNNmdhhhs:`
    [1;37m  -+oo++////++sydmNNNNNNNNNNNNNNNNNNNdyyys/--://+//:
    [1;37m  d/+hmNNNmmdddhhhdmNNNNNNNNNNNNNNNmdhyyyhhhddmmNmdyd-
    [1;37m  ++--+ymNMMNNNNNNmmmmNNNNNNNNNNNmdhddmNNMMMMMMNmhyss
    [1;37m   /d+` -+ydmNMMMMMMNNmNMMMMMMMmmmmNNMMMMMNNmh- :sdo
    [1;37m    sNo   ` /ohdmNNMMMMNNMMMMMNNNMMMMMNmdyo/ `  hNh
    [1;37m     M+'     ``-/oyhmNNMNhNMNhNMMMMNmho/ `     'MN/
    [1;37m     d+'         `-+osydh0w.nzmNNmho:          'mN:
    [1;37m    +o/             ` :oo+:s :+o/-`            -dds
    [1;37m   :hdo       [0;31mx[1;37m    `-/ooss:':+ooo: `    [0;31m0[1;37m      :sdm+
    [1;37m  +dNNNh+         :ydmNNm'   `sddmyo          +hmNmds
    [1;37m dhNMMNNNNmddhsyhdmmNNNM:      NNmNmhyo+oyyyhmNMMNmysd
    [1;37m ydNNNNNh+/++ohmMMMMNMNh       oNNNNNNNmho++++yddhyssy
    [1;37m              `:sNMMMMN'       `mNMNNNd/`
        [1;31mXXXX[0;31mXXXX[1;33mX[1;37m y/hMMNm/  .dXb.  -hdmdy: ` [0;34mXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;37m `o+hNNds. -ymNNy-  .yhys+/`` [0;34mXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;37m +-+//o/+odMNMMMNdmh++////-/s [0;34mXX[1;37mXXXX
        [1;31mXXXX[0;31mXXX[1;37m mhNd -+d/+myo++ysy/hs -mNsdh/ [0;34mXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;37m mhMN+ dMm-/-smy-::dMN/sMMmdo [0;34mXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXX[1;37m NMy+NMMh oMMMs yMMMyNMMs+ [0;34mXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXX[1;37m dy-hMMm+dMMMdoNMMh ydo [1;34mX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mX [1;37m smm 'NMMy dms  sm  [1;34mXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXX                   [1;34mXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXXXX
        [1;31mXXXX[0;31mXXXX[1;33mXXXX[0;33mXXXX[1;35mXXXX[0;35mXXXX[1;32mXXXX[0;32mXXXX[1;34mXXXX[0;34mXXXX[1;37mXER0
EOF
}

function reference() {
    echo -en "\n   +  "
    for i in {0..35}; do
        printf "%2b " $i
    done
    printf "\n\n %3b  " 0
    for i in {0..15}; do
        echo -en "\033[48;5;${i}m  \033[m "
    done
    #for i in 16 52 88 124 160 196 232; do
    for i in {0..6}; do
        let "i = i*36 +16"
        printf "\n\n %3b  " $i
        for j in {0..35}; do
            let "val = i+j"
            echo -en "\033[48;5;${val}m  \033[m "
        done
    done
    echo -e "\n"
}

function pacman() {
    init_ansi
    cat << EOF

    ${yf}  ▄███████▄${reset}   ${rf}  ▄██████▄${reset}    ${gf}  ▄██████▄${reset}    ${bf}  ▄██████▄${reset}    ${pf}  ▄██████▄${reset}    ${cf}  ▄██████▄${reset}
    ${yf}▄█████████▀▀${reset}  ${rf}▄${wf}█▀█${rf}██${wf}█▀█${rf}██▄${reset}  ${gf}▄${wf}█▀█${gf}██${wf}█▀█${gf}██▄${reset}  ${bf}▄${wf}█▀█${bf}██${wf}█▀█${bf}██▄${reset}  ${pf}▄${wf}█▀█${pf}██${wf}█▀█${pf}██▄${reset}  ${cf}▄${wf}█▀█${cf}██${wf}█▀█${cf}██▄${reset}
    ${yf}███████▀${reset}      ${rf}█${wf}▄▄█${rf}██${wf}▄▄█${rf}███${reset}  ${gf}█${wf}▄▄█${gf}██${wf}▄▄█${gf}███${reset}  ${bf}█${wf}▄▄█${bf}██${wf}▄▄█${bf}███${reset}  ${pf}█${wf}▄▄█${pf}██${wf}▄▄█${pf}███${reset}  ${cf}█${wf}▄▄█${cf}██${wf}▄▄█${cf}███${reset}
    ${yf}███████▄${reset}      ${rf}████████████${reset}  ${gf}████████████${reset}  ${bf}████████████${reset}  ${pf}████████████${reset}  ${cf}████████████${reset}
    ${yf}▀█████████▄▄${reset}  ${rf}██▀██▀▀██▀██${reset}  ${gf}██▀██▀▀██▀██${reset}  ${bf}██▀██▀▀██▀██${reset}  ${pf}██▀██▀▀██▀██${reset}  ${cf}██▀██▀▀██▀██${reset}
    ${yf}  ▀███████▀${reset}   ${rf}▀   ▀  ▀   ▀${reset}  ${gf}▀   ▀  ▀   ▀${reset}  ${bf}▀   ▀  ▀   ▀${reset}  ${pf}▀   ▀  ▀   ▀${reset}  ${cf}▀   ▀  ▀   ▀${reset}

    ${ON}${yf}  ▄███████▄   ${rf}  ▄██████▄    ${gf}  ▄██████▄    ${bf}  ▄██████▄    ${pf}  ▄██████▄    ${cf}  ▄██████▄${reset}
    ${ON}${yf}▄█████████▀▀  ${rf}▄${wf}█▀█${rf}██${wf}█▀█${rf}██▄  ${gf}▄${wf}█▀█${gf}██${wf}█▀█${gf}██▄  ${bf}▄${wf}█▀█${bf}██${wf}█▀█${bf}██▄  ${pf}▄${wf}█▀█${pf}██${wf}█▀█${pf}██▄  ${cf}▄${wf}█▀█${cf}██${wf}█▀█${cf}██▄${reset}
    ${ON}${yf}███████▀      ${rf}█${wf}▄▄█${rf}██${wf}▄▄█${rf}███  ${gf}█${wf}▄▄█${gf}██${wf}▄▄█${gf}███  ${bf}█${wf}▄▄█${bf}██${wf}▄▄█${bf}███  ${pf}█${wf}▄▄█${pf}██${wf}▄▄█${pf}███  ${cf}█${wf}▄▄█${cf}██${wf}▄▄█${cf}███${reset}
    ${ON}${yf}███████▄      ${rf}████████████  ${gf}████████████  ${bf}████████████  ${pf}████████████  ${cf}████████████${reset}
    ${ON}${yf}▀█████████▄▄  ${rf}██▀██▀▀██▀██  ${gf}██▀██▀▀██▀██  ${bf}██▀██▀▀██▀██  ${pf}██▀██▀▀██▀██  ${cf}██▀██▀▀██▀██${reset}
    ${ON}${yf}  ▀███████▀   ${rf}▀   ▀  ▀   ▀  ${gf}▀   ▀  ▀   ▀  ${bf}▀   ▀  ▀   ▀  ${pf}▀   ▀  ▀   ▀  ${cf}▀   ▀  ▀   ▀${reset}

EOF
}

function colorvalues() {
    local xdef="${XDG_CONFIG_HOME}/xres/colors/current_colors"
    local colors=( $( sed -re '/^!/d; /^$/d; /^#/d; s/(\*color)([0-9]):/\10\2:/g;' ${xdef} | grep 'color[01][0-9]:' | sort | sed  's/^.*: *//g' ) )
    echo -e "\e[1;37m
    Black    Red      Green    Yellow   Blue     Magenta   Cyan    White
    ──────────────────────────────────────────────────────────────────────\e[0m"
    for i in {0..7}; do echo -en "\e[$((30+$i))m ${colors[i]} \e[0m"; done
    echo
    for i in {8..15}; do echo -en "\e[1;$((22+$i))m ${colors[i]} \e[0m"; done
    echo -e "\n"
}


# note in this first use that switching colors doesn't require a reset
# first - the new color overrides the old one.

function invader() {
    color8_init
    cat << EOF

    $f0  ▄██▄     $f1  ▀▄   ▄▀     $f2 ▄▄▄████▄▄▄    $f3  ▄██▄     $f4  ▀▄   ▄▀     $f5 ▄▄▄████▄▄▄    $f6  ▄██▄   $rst
    $f0▄█▀██▀█▄   $f1 ▄█▀███▀█▄    $f2███▀▀██▀▀███   $f3▄█▀██▀█▄   $f4 ▄█▀███▀█▄    $f5███▀▀██▀▀███   $f6▄█▀██▀█▄ $rst       
    $f0▀▀█▀▀█▀▀   $f1█▀███████▀█   $f2▀▀▀██▀▀██▀▀▀   $f3▀▀█▀▀█▀▀   $f4█▀███████▀█   $f5▀▀▀██▀▀██▀▀▀   $f6▀▀█▀▀█▀▀ $rst        
    $f0▄▀▄▀▀▄▀▄   $f1▀ ▀▄▄ ▄▄▀ ▀   $f2▄▄▀▀ ▀▀ ▀▀▄▄   $f3▄▀▄▀▀▄▀▄   $f4▀ ▀▄▄ ▄▄▀ ▀   $f5▄▄▀▀ ▀▀ ▀▀▄▄   $f6▄▀▄▀▀▄▀▄ $rst        

    $bld $f0  ▄██▄     $f1  ▀▄   ▄▀     $f2 ▄▄▄████▄▄▄    $f3  ▄██▄     $f4  ▀▄   ▄▀     $f5 ▄▄▄████▄▄▄    $f6  ▄██▄  $rst
    $bld $f0▄█▀██▀█▄   $f1 ▄█▀███▀█▄    $f2███▀▀██▀▀███   $f3▄█▀██▀█▄   $f4 ▄█▀███▀█▄    $f5███▀▀██▀▀███   $f6▄█▀██▀█▄$rst
    $bld $f0▀▀█▀▀█▀▀   $f1█▀███████▀█   $f2▀▀▀██▀▀██▀▀▀   $f3▀▀█▀▀█▀▀   $f4█▀███████▀█   $f5▀▀▀██▀▀██▀▀▀   $f6▀▀█▀▀█▀▀$rst
    $bld $f0▄▀▄▀▀▄▀▄   $f1▀ ▀▄▄ ▄▄▀ ▀   $f2▄▄▀▀ ▀▀ ▀▀▄▄   $f3▄▀▄▀▀▄▀▄   $f4▀ ▀▄▄ ▄▄▀ ▀   $f5▄▄▀▀ ▀▀ ▀▀▄▄   $f6▄▀▄▀▀▄▀▄$rst


                                                $f7▌$rst

                                                $f7▌$rst

                                            $f7    ▄█▄    $rst
                                            $f7▄█████████▄$rst
                                            $f7▀▀▀▀▀▀▀▀▀▀▀$rst

EOF
}


function full_ansi(){
    fmt="%3d \e[%dmSGR \e[31mSGR \e[44mSGR\e[49m \e[39m\e[44mSGR\e[0m"
    echo
    echo "SGR ($fmt)"
    echo
    for i in {1..25} ; do
        a=()
        for j in {0..75..25}; do
            a=("${a[@]}" "$((i+j))" "$((i+j))")
        done
        printf "$fmt $fmt $fmt $fmt\n" "${a[@]}"
    done
    echo
    for i in {100..110..4} ; do
        a=()
        for j in {0..3}; do
            a=("${a[@]}" "$((i+j))" "$((i+j))")
        done
        printf "$fmt $fmt $fmt $fmt\n" "${a[@]}"
    done

    fmt="\e[48;5;%dm   \e[0m"
    echo
    echo "256 Colors ($fmt)"
    echo
    for i in {0..7} ; do printf "%3d " "$i" ; done
    for i in {232..243} ; do printf "%3d " "$i" ; done ; echo
    for i in {0..7} ; do printf "$fmt " "$i" ; done
    for i in {232..243} ; do printf "$fmt " "$i" ; done ; echo

    for i in {8..15} ; do printf  "%3d " "$i" ; done ;
    for i in {244..255} ; do printf "%3d " "$i" ; done ; echo
    for i in {8..15} ; do printf "$fmt " "$i" ; done ;
    for i in {244..255} ; do printf "$fmt " "$i" ; done ; echo
    echo

    fmt="%3d \e[38;5;0m\e[48;5;%dm___\e[0m"
    for i in {16..51} ; do
        a=()
        for j in {0..196..36}; do
            a=("${a[@]}" "$((i+j))" "$((i+j))")
        done
        printf "$fmt $fmt $fmt $fmt $fmt $fmt\n" "${a[@]}"
    done

}

function blocks (){
    init_ansi
    cat << EOF

    ${rf}▒▒▒▒${reset} ${ON}${rf}▒▒${reset}   ${gf}▒▒▒▒${reset} ${ON}${gf}▒▒${reset}   ${yf}▒▒▒▒${reset} ${ON}${yf}▒▒${reset}   ${bf}▒▒▒▒${reset} ${ON}${bf}▒▒${reset}   ${pf}▒▒▒▒${reset} ${ON}${pf}▒▒${reset}   ${cf}▒▒▒▒${reset} ${ON}${cf}▒▒${reset} 
    ${rf}▒▒ ■${reset} ${ON}${rf}▒▒${reset}   ${gf}▒▒ ■${reset} ${ON}${gf}▒▒${reset}   ${yf}▒▒ ■${reset} ${ON}${yf}▒▒${reset}   ${bf}▒▒ ■${reset} ${ON}${bf}▒▒${reset}   ${pf}▒▒ ■${reset} ${ON}${pf}▒▒${reset}   ${cf}▒▒ ■${reset} ${ON}${cf}▒▒${reset}  
    ${rf}▒▒ ${reset}${ON}${rf}▒▒▒▒${reset}   ${gf}▒▒ ${reset}${ON}${gf}▒▒▒▒${reset}   ${yf}▒▒ ${reset}${ON}${yf}▒▒▒▒${reset}   ${bf}▒▒ ${reset}${ON}${bf}▒▒▒▒${reset}   ${pf}▒▒ ${reset}${ON}${pf}▒▒▒▒${reset}   ${cf}▒▒ ${reset}${ON}${cf}▒▒▒▒${reset}  

EOF
    cat << EOF
    ${Bf}████${reset}${Bb}████${reset} ${rf}████${reset}${rb}████${reset} ${gf}████${reset}${gb}████${reset} ${yf}████${reset}${yb}████${reset} ${bf}████${reset}${bb}████${reset} ${pf}████${reset}${pb}████${reset} ${cf}████${reset}${cb}████${reset} ${wf}████${reset}${wb}████${reset}
    ${Bf}████${reset}${Bb}████${reset} ${rf}████${reset}${rb}████${reset} ${gf}████${reset}${gb}████${reset} ${yf}████${reset}${yb}████${reset} ${bf}████${reset}${bb}████${reset} ${pf}████${reset}${pb}████${reset} ${cf}████${reset}${cb}████${reset} ${wf}████${reset}${wb}████${reset}
    ${Bf}████${reset}${Bb}████${reset} ${rf}████${reset}${rb}████${reset} ${gf}████${reset}${gb}████${reset} ${yf}████${reset}${yb}████${reset} ${bf}████${reset}${bb}████${reset} ${pf}████${reset}${pb}████${reset} ${cf}████${reset}${cb}████${reset} ${wf}████${reset}${wb}████${reset}

EOF

}

function colorformatting(){
    for clbg in {40..47} {100..107} 49 ; do  #Foreground
        for clfg in {30..37} {90..97} 39 ; do #Formatting
            for attr in 0 1 2 4 5 7 ; do #Print the result
                echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
            done
            echo #Newline
        done
    done
}

function list() {
    local arg
    local mode

    if [[ -z ${1} ]]; then
        arg="gYw"
    else
        arg="$1"
    fi

    cmd_slim=$'echo -en "$EINS \033[$FG\033[$BG $T \033[0m"'
    cmd_default=$'echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m"'

    local delimiter_default=" \t"
    local delimiter_slim=" "

    T="${arg}"

    if [[ ! -z "$2" ]]; then
        mode="slim"
        dl_=${delimiter_slim}
        pre_dl_="\t     "
    else
        mode="default"
        dl_=${delimiter_default}
        pre_dl_="\t\t "
    fi

    echo -e "\n${pre_dl_}40m${dl_}41m${dl_}42m${dl_}43m${dl_}44m${dl_}45m${dl_}46m${dl_}47m";
    for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
        '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
        '  36m' '1;36m' '  37m' '1;37m';
    do FG=${FGs// /}
        echo -en " $FGs \033[$FG  $T  "
        for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do 
            eval "$(eval echo -ne \$cmd_${mode})"
        done
        echo;
    done
    echo
}

function all() {
    local START_COLOR=0
    local END_COLOR=255
    local LINE_LENGTH=16
    local i=$START_COLOR
    local only_block=0
    [[ $# -gt 0 ]] && [[ $@ = '-b' ]] && only_block=1
    printf '\n'
    while [[ $i -le $END_COLOR ]]; do
        if [[ $only_block -eq 1 ]]; then printf "\033[38;5;${i}m%s" '█'; else printf "\033[38;5;${i}m%s%03u" '■' $i;fi
        [ $(((i - START_COLOR + 1) % LINE_LENGTH)) -eq 0 -a $i -gt $START_COLOR ] && printf '\n'
        i=$((i + 1))
    done
    printf '\033[0m\n\n'
}

function bars() {
    init_ansi
    cat << EOF

    ${rf}▆▆▆▆▆▆▆▆▆▆${reset} ${gf}▆▆▆▆▆▆▆▆▆▆${reset} ${yf}▆▆▆▆▆▆▆▆▆▆${reset} ${bf}▆▆▆▆▆▆▆▆▆▆${reset} ${pf}▆▆▆▆▆▆▆▆▆▆${reset} ${cf}▆▆▆▆▆▆▆▆▆▆${reset} ${wf}▆▆▆▆▆▆▆▆▆▆${reset}
    ${ON}${Bf} ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::${reset}
    ${ON}${rf}▆▆▆▆▆▆▆▆▆▆${reset} ${ON}${gf}▆▆▆▆▆▆▆▆▆▆${reset} ${ON}${yf}▆▆▆▆▆▆▆▆▆▆${reset} ${ON}${bf}▆▆▆▆▆▆▆▆▆▆${reset} ${ON}${pf}▆▆▆▆▆▆▆▆▆▆${reset} ${ON}${cf}▆▆▆▆▆▆▆▆▆▆${reset} ${ON}${wf}▆▆▆▆▆▆▆▆▆▆${reset}

EOF
}

function minicolors() {
    init_ansi
    cat << EOF

    ${rf}■■■■${reset}${ON}${rf}■■${reset}   ${gf}■■■■${reset}${ON}${gf}■■${reset}   ${yf}■■■■${reset}${ON}${yf}■■${reset}   ${bf}■■■■${reset}${ON}${pf}■■${reset}   ${pf}■■■■${reset}${ON}${bf}■■${reset}   ${cf}■■■■${reset}${ON}${cf}■■${reset} 
    ${rf}■■${reset}${ON}${gf}■■${reset}${ON}${rf}■■${reset}   ${gf}■■${reset}${ON}${yf}■■${reset}${ON}${gf}■■${reset}   ${yf}■■${reset}${ON}${bf}■■${reset}${ON}${yf}■■${reset}   ${bf}■■${reset}${pf}■■${reset}${ON}${pf}■■${reset}   ${pf}■■${reset}${ON}${cf}■■${reset}${ON}${bf}■■${reset}   ${cf}■■${reset}${ON}${pf}■■${reset}${ON}${cf}■■${reset} 
    ${gf}■■${reset}${ON}${gf}■■${reset}${ON}${rf}■■${reset}   ${yf}■■${reset}${ON}${yf}■■${reset}${ON}${gf}■■${reset}   ${bf}■■${reset}${ON}${bf}■■${reset}${ON}${yf}■■${reset}   ${ON}${cf}■■${reset}${pf}■■${reset}${ON}${pf}■■${reset}   ${ON}${pf}■■${reset}${ON}${cf}■■${reset}${ON}${bf}■■${reset}   ${bf}■■${reset}${ON}${pf}■■${reset}${ON}${cf}■■${reset} 
    ${gf}■■${reset}${ON}${gf}■■${reset}${ON}${rf}■■${reset}   ${yf}■■${reset}${ON}${yf}■■${reset}${ON}${gf}■■${reset}   ${bf}■■${reset}${ON}${bf}■■${reset}${ON}${yf}■■${reset}   ${ON}${cf}■■${reset}${pf}■■${reset}${ON}${pf}■■${reset}   ${ON}${pf}■■${reset}${ON}${cf}■■${reset}${ON}${bf}■■${reset}   ${bf}■■${reset}${ON}${pf}■■${reset}${ON}${cf}■■${reset} 
    ${rf}■■■■${reset}${ON}${rf}■■${reset}   ${gf}■■■■${reset}${ON}${gf}■■${reset}   ${yf}■■■■${reset}${ON}${yf}■■${reset}   ${bf}■■■■${reset}${ON}${pf}■■${reset}   ${pf}■■■■${reset}${ON}${bf}■■${reset}   ${cf}■■■■${reset}${ON}${cf}■■${reset} 
    ${rf}■■${reset}${ON}${gf}■■${reset}${ON}${rf}■■${reset}   ${gf}■■${reset}${ON}${yf}■■${reset}${ON}${gf}■■${reset}   ${yf}■■${reset}${ON}${bf}■■${reset}${ON}${yf}■■${reset}   ${bf}■■${reset}${pf}■■${reset}${ON}${pf}■■${reset}   ${pf}■■${reset}${ON}${cf}■■${reset}${ON}${bf}■■${reset}   ${cf}■■${reset}${ON}${pf}■■${reset}${ON}${cf}■■${reset} 
    ${gf}■■${reset}${ON}${gf}■■${reset}${ON}${rf}■■${reset}   ${yf}■■${reset}${ON}${yf}■■${reset}${ON}${gf}■■${reset}   ${bf}■■${reset}${ON}${bf}■■${reset}${ON}${yf}■■${reset}   ${ON}${cf}■■${reset}${pf}■■${reset}${ON}${pf}■■${reset}   ${ON}${pf}■■${reset}${ON}${cf}■■${reset}${ON}${bf}■■${reset}   ${bf}■■${reset}${ON}${pf}■■${reset}${ON}${cf}■■${reset} 
    ${gf}■■${reset}${ON}${gf}■■${reset}${ON}${rf}■■${reset}   ${yf}■■${reset}${ON}${yf}■■${reset}${ON}${gf}■■${reset}   ${bf}■■${reset}${ON}${bf}■■${reset}${ON}${yf}■■${reset}   ${ON}${cf}■■${reset}${pf}■■${reset}${ON}${pf}■■${reset}   ${ON}${pf}■■${reset}${ON}${cf}■■${reset}${ON}${bf}■■${reset}   ${bf}■■${reset}${ON}${pf}■■${reset}${ON}${cf}■■${reset} 
    ${rf}■■■■${reset}${ON}${rf}■■${reset}   ${gf}■■■■${reset}${ON}${gf}■■${reset}   ${yf}■■■■${reset}${ON}${yf}■■${reset}   ${bf}■■■■${reset}${ON}${pf}■■${reset}   ${pf}■■■■${reset}${ON}${bf}■■${reset}   ${cf}■■■■${reset}${ON}${cf}■■${reset} 
    ${rf}■■${reset}${ON}${gf}■■${reset}${ON}${rf}■■${reset}   ${gf}■■${reset}${ON}${yf}■■${reset}${ON}${gf}■■${reset}   ${yf}■■${reset}${ON}${bf}■■${reset}${ON}${yf}■■${reset}   ${bf}■■${reset}${pf}■■${reset}${ON}${pf}■■${reset}   ${pf}■■${reset}${ON}${cf}■■${reset}${ON}${bf}■■${reset}   ${cf}■■${reset}${ON}${pf}■■${reset}${ON}${cf}■■${reset} 
    ${gf}■■${reset}${ON}${gf}■■${reset}${ON}${rf}■■${reset}   ${yf}■■${reset}${ON}${yf}■■${reset}${ON}${gf}■■${reset}   ${bf}■■${reset}${ON}${bf}■■${reset}${ON}${yf}■■${reset}   ${ON}${cf}■■${reset}${pf}■■${reset}${ON}${pf}■■${reset}   ${ON}${pf}■■${reset}${ON}${cf}■■${reset}${ON}${bf}■■${reset}   ${bf}■■${reset}${ON}${pf}■■${reset}${ON}${cf}■■${reset} 
    ${gf}■■${reset}${ON}${gf}■■${reset}${ON}${rf}■■${reset}   ${yf}■■${reset}${ON}${yf}■■${reset}${ON}${gf}■■${reset}   ${bf}■■${reset}${ON}${bf}■■${reset}${ON}${yf}■■${reset}   ${ON}${cf}■■${reset}${pf}■■${reset}${ON}${pf}■■${reset}   ${ON}${pf}■■${reset}${ON}${cf}■■${reset}${ON}${bf}■■${reset}   ${bf}■■${reset}${ON}${pf}■■${reset}${ON}${cf}■■${reset} 
 
EOF
}

function fancy(){
    FGNAMES=(' black ' '  red  ' ' green ' ' yellow' '  blue ' 'magenta' '  cyan ' ' white ')
    BGNAMES=('DFT' 'BLK' 'RED' 'GRN' 'YEL' 'BLU' 'MAG' 'CYN' 'WHT')
    echo "     ┌──────────────────────────────────────────────────────────────────────────┐"
    for b in $(seq 0 8); do
        if [ "$b" -gt 0 ]; then
        bg=$(($b+39))
        fi

        echo -en "\033[0m ${BGNAMES[$b]} │ "
        for f in $(seq 0 7); do
        echo -en "\033[${bg}m\033[$(($f+30))m ${FGNAMES[$f]} "
        done
        echo -en "\033[0m │"

        echo -en "\033[0m\n\033[0m     │ "
        for f in $(seq 0 7); do
        echo -en "\033[${bg}m\033[1;$(($f+30))m ${FGNAMES[$f]} "
        done
        echo -en "\033[0m │"
            echo -e "\033[0m"
            
    if [ "$b" -lt 8 ]; then
        echo "     ├──────────────────────────────────────────────────────────────────────────┤"
    fi
    done
    echo "     └──────────────────────────────────────────────────────────────────────────┘"
}

function 24bit(){
    awk 'BEGIN{ \
        s="/\\/\\/\\/\\/\\"; s=s s s s s s s s; \
        for (colnum = 0; colnum<77; colnum++) { \
            r = 255-(colnum*255/76); \
            g = (colnum*510/76); \
            b = (colnum*255/76); \
            if (g>255) g = 510-g; \
            printf "\033[48;2;%d;%d;%dm", r,g,b; \
            printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b; \
            printf "%s\033[0m", substr(s,colnum+1,1); \
        } \
        printf "\n"; \
    }'
}

function tmux_pallete(){
    for i in $(seq 0 4 255); do
        for j in $(seq $i $(expr $i + 3)); do
            for k in $(seq 1 $(expr 3 - ${#j})); do
                printf " "
            done
            printf "\x1b[38;5;${j}mcolour${j}"
            [[ $(expr $j % 4) != 3 ]] && printf "    "
        done
        printf "\n"
    done
}

function spectrum(){
    typeset -Ag FG BG

    for color in {0..255}; do
        FG[$color]="%{[38;5;${color}m%}"
        BG[$color]="%{[48;5;${color}m%}"
    done

    for color in {0..255}; do print -P "${FG[$color][3,-3]} $color $[ [##16] $color ]" ; done
}

function tiny_spectrum(){
# Author: crshd
# Source: http://crunchbang.org/forums/viewtopic.php?pid=128584#p128584

echo

for f in {0..6}; do
	echo -en "\033[$((f+41))m\033[$((f+30))m██▓▒░"
done
echo -en "\033[37m██\n"

echo

for f in {0..6}; do
	echo -en "\033[$((f+41))m\033[1;$((f+30))m██▓▒░"
done
echo -en "\033[1;37m██"

echo -e "\033[0m"
echo
}

function ls_colors(){
    typeset -A names
    names[no]="global default"
    names[fi]="normal file"
    names[di]="directory"
    names[ln]="symbolic link"
    names[pi]="named pipe"
    names[so]="socket"
    names[do]="door"
    names[bd]="block device"
    names[cd]="character device"
    names[or]="orphan symlink"
    names[mi]="missing file"
    names[su]="set uid"
    names[sg]="set gid"
    names[tw]="sticky other writable"
    names[ow]="other writable"
    names[st]="sticky"
    names[ex]="executable"
    for i in ${(s.:.)LS_COLORS}; do
        key=${i%\=*}
        color=${i#*\=}
        name=${names[(e)$key]-$key}
        printf '\e[%sm%s\e[m\n' $color $name
    done
}

function skulls(){
color8_init
cat << EOF
$f1  ▄▄▄▄▄▄▄   $f2  ▄▄▄▄▄▄▄   $f3  ▄▄▄▄▄▄▄   $f4  ▄▄▄▄▄▄▄   $f5  ▄▄▄▄▄▄▄   $f6  ▄▄▄▄▄▄▄   
$f1▄█▀     ▀█▄ $f2▄█▀     ▀█▄ $f3▄█▀     ▀█▄ $f4▄█▀     ▀█▄ $f5▄█▀     ▀█▄ $f6▄█▀     ▀█▄ 
$f1█         █ $f2█         █ $f3█         █ $f4█         █ $f5█         █ $f6█         █ 
$f1███ ▄ ██  █ $f2███ ▄ ██  █ $f3███ ▄ ██  █ $f4███ ▄ ██  █ $f5███ ▄ ██  █ $f6███ ▄ ██  █ 
$f1█▄     ▄▄██ $f2█▄     ▄▄██ $f3█▄     ▄▄██ $f4█▄     ▄▄██ $f5█▄     ▄▄██ $f6█▄     ▄▄██ 
$f1 █▄█▄█▄██▀  $f2 █▄█▄█▄██▀  $f3 █▄█▄█▄██▀  $f4 █▄█▄█▄██▀  $f5 █▄█▄█▄██▀  $f6 █▄█▄█▄██▀  $bld
$f1  ▄▄▄▄▄▄▄   $f2  ▄▄▄▄▄▄▄   $f3  ▄▄▄▄▄▄▄   $f4  ▄▄▄▄▄▄▄   $f5  ▄▄▄▄▄▄▄   $f6  ▄▄▄▄▄▄▄   
$f1▄█▀     ▀█▄ $f2▄█▀     ▀█▄ $f3▄█▀     ▀█▄ $f4▄█▀     ▀█▄ $f5▄█▀     ▀█▄ $f6▄█▀     ▀█▄ 
$f1█         █ $f2█         █ $f3█         █ $f4█         █ $f5█         █ $f6█         █ 
$f1███ ▄ ██  █ $f2███ ▄ ██  █ $f3███ ▄ ██  █ $f4███ ▄ ██  █ $f5███ ▄ ██  █ $f6███ ▄ ██  █ 
$f1█▄     ▄▄██ $f2█▄     ▄▄██ $f3█▄     ▄▄██ $f4█▄     ▄▄██ $f5█▄     ▄▄██ $f6█▄     ▄▄██ 
$f1 █▄█▄█▄██▀  $f2 █▄█▄█▄██▀  $f3 █▄█▄█▄██▀  $f4 █▄█▄█▄██▀  $f5 █▄█▄█▄██▀  $f6 █▄█▄█▄██▀  
$rst
EOF
}

initializeANSI()
{
  esc=""

  Bf="${esc}[30m";   rf="${esc}[31m";   gf="${esc}[32m"
  yf="${esc}[33m";   bf="${esc}[34m";   pf="${esc}[35m"
  cf="${esc}[36m";   wf="${esc}[37m";
  
  Bb="${esc}[40m";  rb="${esc}[41m";  gb="${esc}[42m"
  yb="${esc}[43m"   bb="${esc}[44m";   pb="${esc}[45m"
  cb="${esc}[46m";  wb="${esc}[47m"

  ON="${esc}[1m";        OFF="${esc}[22m"
  italicson="${esc}[3m"; italicsoff="${esc}[23m"
  ulon="${esc}[4m";      uloff="${esc}[24m"
  invon="${esc}[7m";     invoff="${esc}[27m"

  reset="${esc}[0m"
}

function illuminate(){
    cat << EOF
    [1;33m._________________________________. [0;0;37m
    [1;33m|[34;7;1m  [0;0;0m[0;0;46m        [36;7;1m       [0;0;45m       [35;7;1m       [0;0;0m[0;0;45m [0;0;0m[0;0;41m [0;0;0m[1;33m| [0;0;37m
    [1;33m|[36;7;1m [0;0;0m[0;0;44m [0;0;0m               [0;34m_             [31;7;1m [0;0;0m[35;7;1m [0;0;0m[1;33m| [0;0;37m
    [1;33m|[34;7;1m [0;0;0m               [0;34m//\             [0;0;41m [0;0;0m[1;33m| [0;0;37m
    [1;33m|[34;7;1m [0;0;0m         [0;32m/[1;32m/-- [0;34m/[1;34m/  [0;36m\  [0;32m========, [0;0;41m [0;0;0m[1;33m| [0;0;37m
    [1;33m|[0;0;44m [0;0;0m        [0;32m/[1;32m/   [0;34m/[1;34m/    [0;36m\        [0;32m/  [31;7;1m [0;0;0m[1;33m| [0;0;37m
    [1;33m|[0;0;44m [0;0;0m       [0;32m/[1;32m/   [0;34m/[1;34m/      [0;36m\      [0;32m/   [31;7;1m [0;0;0m[1;33m| [0;0;37m
    [1;33m|[0;0;44m [0;0;0m [1;31m__________  ___[0;0;41m [0;37;7;1m [0;0;0m[0;31m__  _________[31;7;1m [0;0;0m[1;33m| [0;0;37m
    [1;33m|[0;0;42m [0;0;0m      [0;32m/     [0;34m\   [0;0;47m [31;7;1m [0;0;0m   [1;34m/[0;34m/  [1;32m/[0;32m/    [0;0;43m [0;0;0m[1;33m| [0;0;37m
    [1;33m|[0;0;42m [0;0;0m     [0;32m/       [0;34m\      [1;34m/[0;34m/  [1;32m/[0;32m/     [0;0;43m [0;0;0m[1;33m| [0;0;37m
    [1;33m|[0;0;42m [0;0;0m    [0;32m/__________________[1;32m/[0;32m/      [0;0;43m [0;0;0m[1;33m| [0;0;37m
    [1;33m|[32;7;1m [0;0;0m               [0;34m\  [1;34m/[0;34m/           [33;7;1m [0;0;0m[1;33m| [0;0;37m
    [1;33m|[32;7;1m [0;0;0m                [0;34m\[1;34m/[0;34m/            [33;7;1m [0;0;0m[1;33m| [0;0;37m
    [1;33m|[0;0;40m [0;0;0m[0;0;42m [0;0;0m                [1;34m"            [0;0;43m [0;0;0m[37;7;1m [0;0;0m[1;33m| [0;0;37m
    [1;33m|[32;7;1m [0;0;0m[30;7;1m [0;0;0m[0;0;40m        [0;0;0m[30;7;1m       [0;0;0m[0;0;47m       [0;0;0m[37;7;1m       [0;0;0m[0;0;47m [0;0;0m[33;7;1m [0;0;0m[1;33m| [0;0;37m
    [1;33m'---------------------------------' [0;0;37m
EOF
}

function blocks2(){
    init_ansi2
    cat << EOF
    ${redf}■■■■${reset}${boldon}${redf}■■${reset}   ${greenf}■■■■${reset}${boldon}${greenf}■■${reset}   ${yellowf}■■■■${reset}${boldon}${yellowf}■■${reset}   ${bluef}■■■■${reset}${boldon}${purplef}■■${reset}   ${purplef}■■■■${reset}${boldon}${bluef}■■${reset}   ${cyanf}■■■■${reset}${boldon}${cyanf}■■${reset} 
    ${redf}■■${reset}${boldon}${greenf}■■${reset}${boldon}${redf}■■${reset}   ${greenf}■■${reset}${boldon}${yellowf}■■${reset}${boldon}${greenf}■■${reset}   ${yellowf}■■${reset}${boldon}${bluef}■■${reset}${boldon}${yellowf}■■${reset}   ${bluef}■■${reset}${purplef}■■${reset}${boldon}${purplef}■■${reset}   ${purplef}■■${reset}${boldon}${cyanf}■■${reset}${boldon}${bluef}■■${reset}   ${cyanf}■■${reset}${boldon}${purplef}■■${reset}${boldon}${cyanf}■■${reset} 
    ${greenf}■■${reset}${boldon}${greenf}■■${reset}${boldon}${redf}■■${reset}   ${yellowf}■■${reset}${boldon}${yellowf}■■${reset}${boldon}${greenf}■■${reset}   ${bluef}■■${reset}${boldon}${bluef}■■${reset}${boldon}${yellowf}■■${reset}   ${boldon}${cyanf}■■${reset}${purplef}■■${reset}${boldon}${purplef}■■${reset}   ${boldon}${purplef}■■${reset}${boldon}${cyanf}■■${reset}${boldon}${bluef}■■${reset}   ${bluef}■■${reset}${boldon}${purplef}■■${reset}${boldon}${cyanf}■■${reset} 
    ${greenf}■■${reset}${boldon}${greenf}■■${reset}${boldon}${redf}■■${reset}   ${yellowf}■■${reset}${boldon}${yellowf}■■${reset}${boldon}${greenf}■■${reset}   ${bluef}■■${reset}${boldon}${bluef}■■${reset}${boldon}${yellowf}■■${reset}   ${boldon}${cyanf}■■${reset}${purplef}■■${reset}${boldon}${purplef}■■${reset}   ${boldon}${purplef}■■${reset}${boldon}${cyanf}■■${reset}${boldon}${bluef}■■${reset}   ${bluef}■■${reset}${boldon}${purplef}■■${reset}${boldon}${cyanf}■■${reset} 
    ${redf}■■■■${reset}${boldon}${redf}■■${reset}   ${greenf}■■■■${reset}${boldon}${greenf}■■${reset}   ${yellowf}■■■■${reset}${boldon}${yellowf}■■${reset}   ${bluef}■■■■${reset}${boldon}${purplef}■■${reset}   ${purplef}■■■■${reset}${boldon}${bluef}■■${reset}   ${cyanf}■■■■${reset}${boldon}${cyanf}■■${reset} 
    ${redf}■■${reset}${boldon}${greenf}■■${reset}${boldon}${redf}■■${reset}   ${greenf}■■${reset}${boldon}${yellowf}■■${reset}${boldon}${greenf}■■${reset}   ${yellowf}■■${reset}${boldon}${bluef}■■${reset}${boldon}${yellowf}■■${reset}   ${bluef}■■${reset}${purplef}■■${reset}${boldon}${purplef}■■${reset}   ${purplef}■■${reset}${boldon}${cyanf}■■${reset}${boldon}${bluef}■■${reset}   ${cyanf}■■${reset}${boldon}${purplef}■■${reset}${boldon}${cyanf}■■${reset} 
    ${greenf}■■${reset}${boldon}${greenf}■■${reset}${boldon}${redf}■■${reset}   ${yellowf}■■${reset}${boldon}${yellowf}■■${reset}${boldon}${greenf}■■${reset}   ${bluef}■■${reset}${boldon}${bluef}■■${reset}${boldon}${yellowf}■■${reset}   ${boldon}${cyanf}■■${reset}${purplef}■■${reset}${boldon}${purplef}■■${reset}   ${boldon}${purplef}■■${reset}${boldon}${cyanf}■■${reset}${boldon}${bluef}■■${reset}   ${bluef}■■${reset}${boldon}${purplef}■■${reset}${boldon}${cyanf}■■${reset} 
    ${greenf}■■${reset}${boldon}${greenf}■■${reset}${boldon}${redf}■■${reset}   ${yellowf}■■${reset}${boldon}${yellowf}■■${reset}${boldon}${greenf}■■${reset}   ${bluef}■■${reset}${boldon}${bluef}■■${reset}${boldon}${yellowf}■■${reset}   ${boldon}${cyanf}■■${reset}${purplef}■■${reset}${boldon}${purplef}■■${reset}   ${boldon}${purplef}■■${reset}${boldon}${cyanf}■■${reset}${boldon}${bluef}■■${reset}   ${bluef}■■${reset}${boldon}${purplef}■■${reset}${boldon}${cyanf}■■${reset} 
    ${redf}■■■■${reset}${boldon}${redf}■■${reset}   ${greenf}■■■■${reset}${boldon}${greenf}■■${reset}   ${yellowf}■■■■${reset}${boldon}${yellowf}■■${reset}   ${bluef}■■■■${reset}${boldon}${purplef}■■${reset}   ${purplef}■■■■${reset}${boldon}${bluef}■■${reset}   ${cyanf}■■■■${reset}${boldon}${cyanf}■■${reset} 
    ${redf}■■${reset}${boldon}${greenf}■■${reset}${boldon}${redf}■■${reset}   ${greenf}■■${reset}${boldon}${yellowf}■■${reset}${boldon}${greenf}■■${reset}   ${yellowf}■■${reset}${boldon}${bluef}■■${reset}${boldon}${yellowf}■■${reset}   ${bluef}■■${reset}${purplef}■■${reset}${boldon}${purplef}■■${reset}   ${purplef}■■${reset}${boldon}${cyanf}■■${reset}${boldon}${bluef}■■${reset}   ${cyanf}■■${reset}${boldon}${purplef}■■${reset}${boldon}${cyanf}■■${reset} 
    ${greenf}■■${reset}${boldon}${greenf}■■${reset}${boldon}${redf}■■${reset}   ${yellowf}■■${reset}${boldon}${yellowf}■■${reset}${boldon}${greenf}■■${reset}   ${bluef}■■${reset}${boldon}${bluef}■■${reset}${boldon}${yellowf}■■${reset}   ${boldon}${cyanf}■■${reset}${purplef}■■${reset}${boldon}${purplef}■■${reset}   ${boldon}${purplef}■■${reset}${boldon}${cyanf}■■${reset}${boldon}${bluef}■■${reset}   ${bluef}■■${reset}${boldon}${purplef}■■${reset}${boldon}${cyanf}■■${reset} 
    ${greenf}■■${reset}${boldon}${greenf}■■${reset}${boldon}${redf}■■${reset}   ${yellowf}■■${reset}${boldon}${yellowf}■■${reset}${boldon}${greenf}■■${reset}   ${bluef}■■${reset}${boldon}${bluef}■■${reset}${boldon}${yellowf}■■${reset}   ${boldon}${cyanf}■■${reset}${purplef}■■${reset}${boldon}${purplef}■■${reset}   ${boldon}${purplef}■■${reset}${boldon}${cyanf}■■${reset}${boldon}${bluef}■■${reset}   ${bluef}■■${reset}${boldon}${purplef}■■${reset}${boldon}${cyanf}■■${reset} 
EOF
}


function poke(){
init_ansi

cat << EOF
                        ${Bf}██████                    ${Bf}████████                  ██              ${Bf}████████                  ████████
                      ${Bf}██${gf}${ON}██████${OFF}${Bf}██                ${Bf}██${rf}${ON}██████${OFF}██${Bf}██              ██${rf}██${Bf}██          ${Bf}██${bf}${ON}██████${OFF}██${Bf}████            ██${bf}${ON}████████${OFF}${Bf}██
                  ${Bf}██████${gf}${ON}██████${OFF}${Bf}██              ${Bf}██${rf}${ON}██████████${OFF}██${Bf}██            ██${rf}████${Bf}██      ${Bf}██${bf}${ON}████████████${OFF}██${Bf}████      ████${bf}${ON}██████${OFF}████${Bf}██
              ${Bf}████${gf}${ON}████${OFF}██${ON}████${OFF}██${ON}██${OFF}${Bf}████          ${Bf}██${rf}${ON}████████████${OFF}${Bf}██            ██${rf}████${Bf}██      ${Bf}██${bf}${ON}██████████████${OFF}${Bf}██${pf}██${Bf}████  ██${bf}${ON}████${OFF}██${Bf}██${bf}████${Bf}██
      ${Bf}██    ██${gf}${ON}██████${OFF}████${ON}████${OFF}██${ON}██████${OFF}${Bf}██      ${Bf}██${rf}${ON}██████████████${OFF}██${Bf}██        ██${rf}████${yf}██${rf}██${Bf}██  ${Bf}██${bf}${ON}████████████████${OFF}██${pf}██${ON}██${OFF}██${Bf}██${bf}██${ON}██${OFF}██${Bf}██${bf}██████${Bf}██
    ${Bf}██${cf}${ON}██${OFF}${Bf}██████${gf}${ON}████${OFF}██${ON}██${OFF}██${ON}██████${OFF}██${ON}██████${OFF}${Bf}██  ${Bf}██${rf}${ON}████████${wf}██${OFF}${Bf}██${rf}${ON}████${OFF}██${Bf}██        ██${rf}██${yf}██${ON}██${OFF}${rf}██${Bf}██  ${Bf}██${bf}${ON}████████${wf}${ON}██${OFF}${Bf}██${bf}${ON}████${OFF}██${wf}${ON}██${OFF}${pf}${ON}████${OFF}██${Bf}██${bf}████${Bf}██${bf}████${Bf}██
    ${Bf}██${cf}${ON}██████${OFF}${Bf}████${gf}██${ON}██${OFF}██${ON}██████████${OFF}██${ON}████${OFF}${Bf}██  ${Bf}██${rf}${ON}████████${OFF}${Bf}████${rf}${ON}██${OFF}██████${Bf}██      ██${rf}██${yf}${ON}████${OFF}${rf}██${Bf}██  ${Bf}██${bf}██${ON}██████${OFF}${Bf}████${bf}${ON}██${OFF}████${wf}${ON}██${pf}██████${OFF}${Bf}██${bf}██${Bf}████████
    ${Bf}██${cf}${ON}████████${OFF}██${Bf}██${gf}${ON}██${OFF}██${ON}██████████${OFF}██${ON}████${OFF}${Bf}██  ${Bf}██${rf}${ON}████████${OFF}${Bf}████${rf}${ON}██${OFF}██████${Bf}██        ██${yf}${ON}██${OFF}${Bf}████      ${Bf}██${bf}████${ON}██${OFF}${Bf}████${bf}██████${Bf}██${wf}${ON}████${pf}██${OFF}██${Bf}████
  ${Bf}██${cf}${ON}████${OFF}██${ON}██${OFF}████${ON}██${OFF}${Bf}██████${gf}${ON}████████${OFF}██${ON}██${OFF}${Bf}██      ${Bf}██${rf}██${ON}████████${OFF}██████████${Bf}██      ██${rf}${ON}██${OFF}${Bf}██          ${Bf}████${bf}████████${Bf}████${bf}${ON}████${wf}██${OFF}${pf}████${Bf}██
${Bf}████${cf}██${ON}████████████████${OFF}${Bf}██${gf}██████${Bf}████████        ${Bf}████${rf}██████████████████${Bf}██  ██${rf}${ON}████${OFF}${Bf}██          ${Bf}██${bf}${ON}██${OFF}${Bf}████████${bf}${ON}██████${OFF}██${wf}${ON}██${OFF}${pf}████${Bf}██
${Bf}██${cf}████${ON}██████${OFF}██${ON}██████${OFF}${Bf}██${cf}██${Bf}██████${cf}██████${Bf}██            ${Bf}██████${rf}████${Bf}██${rf}██████${Bf}████${rf}██${ON}██${OFF}${Bf}██              ${Bf}████${yf}${ON}████${OFF}${Bf}██${bf}${ON}████${OFF}██${Bf}██${wf}${ON}██${OFF}${pf}████${Bf}██
${Bf}██${cf}${ON}████████${OFF}██${ON}██${OFF}${Bf}████${cf}${ON}██${OFF}██████████${Bf}██${cf}██${wf}${ON}██${OFF}${Bf}██              ${Bf}██${yf}${ON}████${OFF}${Bf}██${rf}${ON}████${OFF}${rf}██████${Bf}██${rf}██${ON}██${OFF}${Bf}██                  ${Bf}██${yf}████${Bf}████████${wf}${ON}██${OFF}${pf}████${Bf}██
${Bf}██${cf}██${ON}████████${OFF}${Bf}██${rf}${ON}██${wf}████${OFF}${cf}████${Bf}██${cf}████${Bf}██████                ${Bf}██${yf}${ON}██████${OFF}${Bf}████${rf}██████${Bf}██${rf}██${Bf}██                  ${Bf}██${bf}██${Bf}██${pf}██${yf}██████${pf}██${Bf}██${wf}${ON}██${OFF}${Bf}██
  ${Bf}██${cf}██${ON}██████${OFF}${Bf}██${rf}${ON}██${wf}██${cf}██${OFF}██${Bf}██${cf}████${Bf}██                    ${Bf}██${wf}${ON}██${OFF}${Bf}██${yf}${ON}██████${OFF}${rf}████████${Bf}████                      ${Bf}████████${pf}████${bf}██${Bf}██${wf}${ON}██${OFF}${Bf}██
    ${Bf}████${cf}████████████${Bf}██${cf}██████${Bf}██                      ${Bf}██████${yf}████${rf}██████${Bf}████                              ${Bf}██████${bf}██${Bf}████
        ${Bf}██████████████${wf}${ON}██${OFF}${cf}██${wf}${ON}██${OFF}${Bf}██                            ${Bf}██████${rf}██${Bf}████                                  ${Bf}██${bf}██████${Bf}██
                      ${Bf}██████                                ${Bf}██${wf}${ON}██${OFF}${rf}██${wf}${ON}██${OFF}${Bf}██                                    ${Bf}██████
                                                              ${Bf}██████                  
${reset}

EOF

}

case "${1}" in
    ""|ref*) reference                ;;
    256) 256colors           ; exit 0 ;;
    24*) 24bit               ; exit 0 ;;
    clrv*) colorvalues       ; exit 0 ;;
    inv*) invader            ; exit 0 ;;
    full*) full_ansi         ; exit 0 ;;
    b1) blocks               ; exit 0 ;;
    b2) blocks2              ; exit 0 ;;
    fmt*) colorformatting    ; exit 0 ;;
    pac*) pacman             ; exit 0 ;;
    l1) list                 ; exit 0 ;;
    l2) list '•••'           ; exit 0 ;;
    lslim) list '•' "s"      ; exit 0 ;;
    all*) all                ; exit 0 ;;
    bar*) bars               ; exit 0 ;;
    fn*) fancy               ; exit 0 ;;
    tmux*) tmux_pallete      ; exit 0 ;;
    spectr*) spectrum        ; exit 0 ;;
    ls*) ls_colors           ; exit 0 ;;
    ira*) ira                ; exit 0 ;;
    skull*) skulls           ; exit 0 ;;
    poke*) poke              ; exit 0 ;;
    ill*) illuminate         ; exit 0 ;;
    puke*) pukeskull         ; exit 0 ;;
    cr*) crunchbang_mini     ; exit 0 ;;
    tspctrm*) tiny_spectrum  ; exit 0 ;;
esac
