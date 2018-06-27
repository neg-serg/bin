#!/bin/zsh

. ${XDG_CONFIG_HOME}/wl/wall_list
. ~/.zsh/03-helpers.zsh

local wall_dir="${HOME}/pic/wl"
local prev_list="${HOME}/tmp/current_walls"
local settings="${HOME}/tmp/wl_settings"
local trash_dir="${HOME}/tmp/trash"

local last_count=40
local last_count_digits=${#last_count}

save_current_wall(){ print "$1" > ${HOME}/tmp/current_wallpaper }
print_wall(){ print $(zpref) $(zfwrap "${1}") }

function main(){
    current=$(< ${HOME}/tmp/current_wallpaper|head -1)
    [[ ! -f "${settings}"  ]] && print "full" > "${settings}"
    [[ $mode = "" ]] && mode="full"
    case ${1} in
        # toggle mode (fill/full)
        -t)
            mode=$(xargs <<< $(< "${settings}")|head -1)
            if [[ "${mode}" == "full" ]]; then
                builtin print "fill" > "${settings}"
            else
                builtin print "full" > "${settings}"
            fi
            print $(zwrap "wl") $(zwrap "Set mode -> ${mode}")
            ;;
        # open in image viewer
        -o) if [[ $# == 1 ]]; then
                sxiv -Zftoa -sd $(tac "${prev_list}")
            elif [[ $# == 2 ]]; then
                case ${2#[-+]} in
                    *[!0-9]* | '') exit -1 ;;
                    *) sxiv -Zftoa -sd $(tac <<< "$(tail -"$2" "${prev_list}")")
                esac
            fi
            ;;
        # set wallpaper
        -s)
            if [[ $# == 1 ]]; then
                local -a filtered_wall_=()
                for i in ${wall_[@]}; [[ -f $(readlink -f "${i}") ]] && { filtered_wall_+=(${i}) }
                current="${filtered_wall_[$[RANDOM % $#filtered_wall_]+1]}"
                hsetroot -"${mode}" "${current}" && save_current_wall "${current}" &!
            elif [[ $# == 2 ]]; then
                case ${2#[-+]} in
                    *[!0-9]* | '') exit -1 ;;
                    *)
                        num_="$2"
                        [[ ${num_} < 0 ]] && esc_num=$[last_count+num_]
                        line=$(sed -- "${esc_num}q;d" "${prev_list}")
                        hsetroot -"${mode}" "${line}" && save_current_wall "${line}" &!
                    ;;
                esac
            fi
            ;;
        # set random wallpaper from list
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
        # delete wallpaper
        -d)
            [[ ! -d ${trash_dir} ]] && mkdir "${trash_dir}"
            mv -iv "$(tail -1 ${prev_list})" "${trash_dir}"
            ;;
        # list wallpapers
        -l)
            local print_format_="%0${last_count_digits}d"
            while IFS='' read -r line; do
                let counter=counter+1
                print $(zwrap $(builtin printf "${print_format_}" "${counter}"))$(zfwrap "${line}")
            done < "${prev_list}"
            ;;
        # print wallpaper name and copy it to clipboard
        -c)
            print_wall "${current}"
            xclip <<< "${current}"
            ;;
        # print help
        --help|-h|*) 
            echo "Wallpaper set script.\n" \
                 "\n" \
                 "  -t      toggle mode\n"  \
                 "  -o      open in image viewer\n"  \
                 "  -s      set wallpaper\n" \
                 "  -r      set wallpaper from prepared list\n" \
                 "  -d      delete wallpaper with given number\n" \
                 "  -l      list wallpapers\n" \
                 "  -c      print wallpaper name and copy it to clipboard"
        ;;
    esac
}

main "$@"
