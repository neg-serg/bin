#!/bin/zsh

function zrcautoload() {
    emulate -L zsh
    setopt extended_glob
    local fdir ffile
    local -i ffound

    ffile=$1
    (( ffound = 0 ))
    for fdir in ${fpath} ; do
        [[ -e ${fdir}/${ffile} ]] && (( ffound = 1 ))
    done

    (( ffound == 0 )) && return 1
    autoload -U ${ffile} || return 1
    return 0
}

source "${ZDOTDIR}/03-helpers.zsh"

function mp(){
    vdpau=false
    for i; do vid_fancy_print "${i}"; done
    if lsmod |& rg -i nvidia > /dev/null; then
        if [[ ${vdpau} == false ]]; then
            mpv --input-ipc-server=/tmp/mpvsocket --vo=opengl --vd-lavc-dr=yes "$@" > ${HOME}/tmp/mpv.log
        else
            mpv --input-ipc-server=/tmp/mpvsocket --vo=vdpau --hwdec=vdpau "$@" > ${HOME}/tmp/mpv.log
        fi
    else
        mpv --input-ipc-server=/tmp/mpvsocket --vo=vaapi --hwdec=vaapi "$@" > ${HOME}/tmp/mpv.log
    fi
}

pl(){
    [[ -e "$1" ]] && arg_="$1"
    [[ -z "${arg_}" ]] && arg_="${XDG_VIDEOS_DIR}/"
    pushd ${arg_}
    rg_cmd=(
        rg -g \"'!{.git,node_modules}/*'\" -g \"'!*.srt'\"
        --files --hidden --follow
    )
    run_command=(fzf-tmux)
    find_result="$(eval ${run_command[@]})"
    xsel <<< "${find_result}"
    if [[ ! -z ${find_result} ]]; then
        mp "${find_result}"
    fi
    popd
}

pl_rofi(){
    [[ -e "$1" ]] && arg_="$1"
    [[ -z "${arg_}" ]] && arg_="${XDG_VIDEOS_DIR}/"
    pushd ${arg_}
    rg_cmd=(
        rg -g \"'!{.git,node_modules}/*'\" -g \"'!*.srt'\"
        --files --hidden --follow
    )
    if [[ ${set_maxdepth} == true ]]; then
        rg_cmd+=(--max-depth 1)
    fi
    rg_cmd_result=$(eval ${rg_cmd[@]})
    if [[ $#rg_cmd_result > 1 ]]; then
        find_result=$(rofi -p '[>>]' -i -dmenu <<< ${rg_cmd_result})
    else
        find_result=rg_cmd_result
    fi
    xsel <<< "${find_result}"
    if [[ ! -z ${find_result} ]]; then
        mp "${find_result}"
    fi
    popd
}

set_maxdepth=false
if [[ $1 != "rofi" ]]; then
    if [[ $1 == "1st_level" ]]; then
        set_maxdepth=true
        shift
    fi
    pl "$@"
    exit
else
    shift;
    if [[ $1 == "1st_level" ]]; then
        set_maxdepth=true
        shift
    fi
    pl_rofi "$@"
    exit
fi
