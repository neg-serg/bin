#!/bin/zsh

. ${XDG_CONFIG_HOME}/wl/wall_list
. ~/.zsh/03-helpers.zsh

local wall_dir="${HOME}/pic/wl"
local prev_list="${HOME}/tmp/current_walls"
local settings="${HOME}/tmp/wl_settings"
local trash="${HOME}/tmp/trash"

local last_count=40
local last_count_digits=${#last_count}

save_current_wall(){ print "${1}" > ${HOME}/tmp/current_wallpaper }
print_wall(){ print $(zpref) $(zfwrap "${1}") }

function main(){
    current=$(< ${HOME}/tmp/current_wallpaper|head -1)
    [[ ! -f "${settings}"  ]] && print "full" > "${settings}"
    [[ ${mode} = "" ]] && mode="full"
    case ${1} in
        # Toggle mode (fill/full)
        -t)
            mode=$(xargs <<< $(< "${settings}")|head -1)
            if [[ "${mode}" == "full" ]]; then
                print "fill" > "${settings}"
            else
                print "full" > "${settings}"
            fi
            print $(zwrap "wl") $(zwrap "Set mode -> ${mode}")
            ;;
        # Open in image viewer
        -o) if [[ $# == 1 ]]; then
                sxiv -Zftoa -sd $(tac "${prev_list}")
            elif [[ $# == 2 ]]; then
                case ${2#[-+]} in
                    *[!0-9]* | '') exit -1 ;;
                    *) sxiv -Zftoa -sd $(tac <<< "$(tail -"$2" "${prev_list}")")
                esac
            fi
            ;;
        # Set wallpaper
        -s)
            if [[ $# == 1 ]]; then
                local -a filtered_wall=()
                for i in ${wall_[@]}; [[ -f $(readlink -f "${i}") ]] && { filtered_wall+=(${i}) }
                current="${filtered_wall[$[RANDOM % $#filtered_wall]+1]}"
                hsetroot -"${mode}" "${current}" && save_current_wall "${current}" &!
            elif [[ $# == 2 ]]; then
                case ${2#[-+]} in
                    *[!0-9]* | '') exit -1 ;;
                    *)
                        num="$2"
                        [[ ${num} < 0 ]] && esc_num=$[last_count+num]
                        line=$(sed -- "${esc_num}q;d" "${prev_list}")
                        hsetroot -"${mode}" "${line}" && save_current_wall "${line}" &!
                    ;;
                esac
            fi
            ;;
        # Set random wallpaper from list
        -r)
            local -a walls=(${wall_dir}/*.{jpg,png})
            local current="${walls[$[RANDOM % $#walls]+1]}"
            {
                print "${current}" >> "${prev_list}" && \
                local buf=$(tail -${last_count} "${prev_list}")
                echo "${buf}" > "${prev_list}"
            } &!
            hsetroot -"${mode}" "${current}" && save_current_wall "${current}" &!
            ;;
        # Delete wallpaper
        -d)
            [[ ! -d ${trash} ]] && mkdir "${trash}"
            mv -iv "$(tail -1 ${prev_list})" "${trash}"
            ;;
        # List wallpapers
        -l)
            local format="%0${last_count_digits}d"
            while IFS='' read -r line; do
                let c=c+1
                print $(zwrap $(printf "${format}" "${c}"))$(zfwrap "${line}")
            done < "${prev_list}"
            ;;
        # Print wallpaper name and copy it to clipboard
        -c)
            print_wall "${current}"
            xclip <<< "${current}"
            ;;
        -v) print_wall "${current}"
            pkill xwinwrap
            local -a walls_vids=(${wall_dir}/wl*.gif)
            local current="${walls_vids[$[RANDOM % $#walls_vids]+1]}"
            {
                print "${current}" >> "${prev_list}" && \
                local buf=$(tail -${last_count} "${prev_list}")
                echo "${buf}" > "${prev_list}"
            } &!
            xwinwrap -ov -ni -fs -- mpv -wid WID --keepaspect=no --loop "${current}" &!
            ;;
        --raw|-R)
            < ${prev_list[@]}
            ;;
        --show|-S)
            sort -u ${prev_list[@]}|xargs sx
            ;;
        # Print help
        --help|-h|*) 
            echo "Wallpaper set script.\n" \
                 "\n" \
                 "  -t          toggle mode\n"  \
                 "  -o          open in image viewer\n"  \
                 "  -s          set wallpaper\n" \
                 "  -r          set wallpaper from prepared list\n" \
                 "  -v          set random video wallpaper\n" \
                 "  -d          delete wallpaper with given number\n" \
                 "  -l          list wallpapers\n" \
                 "  -R, --raw   list wallpapers in the raw mode\n" \
                 "  -S, --show  show wallpapers list in sxiv wrapper\n" \
                 "  -c          print wallpaper name and copy it to clipboard"
        ;;
    esac
}

main "$@"
