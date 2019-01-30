#!/bin/zsh

pl(){
    [[ -e "$1" ]] && arg_="$1"
    [[ -z "${arg_}" ]] && arg_="${XDG_VIDEOS_DIR}/"
    pushd ${arg_}
    rg_cmd=(
        rg -g \"'!{.git,node_modules}/*'\" -g \"'!*.srt'\"
        --files --hidden --follow
    )
    run_command=(sk-tmux -c \'${rg_cmd[@]}\' -d 40% -- ${SKIM_DEFAULT_OPTIONS})
    find_result="$(eval ${run_command[@]})"
    xsel <<< "${find_result}"
    if [[ ! -z ${find_result} ]]; then
        vid_fancy_print "${find_result}"
        mpv "${find_result}"
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
        find_result=$(rofi -p '[>>]' -dmenu <<< ${rg_cmd_result})
    else
        find_result=rg_cmd_result
    fi
    xsel <<< "${find_result}"
    if [[ ! -z ${find_result} ]]; then
        vid_fancy_print "${find_result}"
        mpv "${find_result}"
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
else
    shift;
    if [[ $1 == "1st_level" ]]; then
        set_maxdepth=true
        shift
    fi
    pl_rofi "$@"
fi