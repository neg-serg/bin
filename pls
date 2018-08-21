#!/bin/zsh

if [[ ${DISPLAY} ]]; then
    local font='PragmataPro for Powerline 17'

    _v=(-lines 1 -columns 11 -location 6 -font "${font}" -o 90 -yoffset -22 -dmenu)
    _s=(-location 6 -font "${font}" -o 90 -yoffset -22 -dmenu)

    client_runner=(rofi ${_s} -dmenu -p "Clients:")
    volume_runner=(rofi ${_v} -p "Volume: ")
    sink_runner=(rofi ${_s} -p "Sink: ")
else
    client_runner=(fzf --prompt "Clients:")
    volume_runner=(fzf --prompt "Volume: ")
    sink_runner=(fzf --prompt "Sink: ")
fi

if [[ ${SCRIPT_OUTPUT} ]]; then
    client_runner=(cat)
    volume_runner=(cat)
    sink_runner=(cat)
fi

get_index() {
    sink=$(pacmd list-sinks | \
        grep name:          | \
        awk 'gsub(">$","")' | \
        cut -c 9-           | \
        sed 's/[<>]/ /g'    | \
        ${sink_runner[@]}     \
        )

    index=$(pacmd list-sinks  | \
        grep ${sink} -B1      | \
        head -1               | \
        awk -F : '{print $2}' | \
        tr -d '[:blank:]'       \
        )
}

client=
client_data=

case $1 in
    -switch)
        local sinks=(
            $(pacmd list-sinks | grep index | \
            awk '{ if ($1 == "*") print "1",$3; else print "0",$2 }')
        )
        local sinks_count=${#sinks[*]}
        local active_sink_index=$[$(xargs <<< $(pacmd list-sinks | sed -n -e 's/\*[[:space:]]index:[[:space:]]\([[:digit:]]\)/\1/p'))+1]
        local next_sink_index=${sinks[1]}

        #find the next sink (not always the next index number)
        local ord=1
        while [[ $ord -lt $((sinks_count + 1)) ]]; do
            if [[ ${sinks[$ord]} -gt $((active_sink_index)) ]]; then
                next_sink_index=$((sinks[$ord]))
                break
            fi
            let ord++
        done

        inputs=($(pacmd list-sink-inputs | grep index | awk '{print $2}'))

        #change the default sink
        pacmd "set-default-sink ${next_sink_index}"

        #move all inputs to the new sink
        for app in ${inputs[*]}; do pacmd move-sink-input ${app} ${next_sink_index} &> /dev/null; done

        #display notification
        active_sink_index=$[$(xargs <<< $(pacmd list-sinks | sed -n -e 's/\*[[:space:]]index:[[:space:]]\([[:digit:]]\)/\1/p'))+1]
        local sinks_info=$(pacmd list-sinks | sed -ne 's/device.description[[:space:]]=[[:space:]]"\(.*\)"/\1/p')
        local sinks_len=$(wc -l <<< ${sinks_info})
        local info
        if [[ $active_sink_index > $sinks_len ]]; then
            info=$(sed ${sinks_len}"!d" <<< ${sinks_info} )
        else
            info=$(sed $((active_sink_index))"!d" <<< ${sinks_info} )
        fi
        notify-send -u normal -i audio-volume-medium-symbolic "Sound output switched to" "${info}"
        exit
    ;;
    -unmute) shift; get_index; pactl set-sink-mute ${index} 0 ;;
    -mute) shift; get_index; pactl set-sink-mute ${index} 1 ;;
    *)  client_data=$(pacmd list-sink-inputs                         | \
                grep -E 'client:|index:'                             | \
                awk 'NR % 2 == 1 { o=$0 ; next } { print o " " $0 }' | \
                awk '{print $2" "substr($0, index($0,$5))}'          | \
                sed 's/[<>]/#/g')
        if [[ "${client_data}" != "" ]]; then
            client="$(echo "${client_data}" | ${client_runner[@]})"
        fi
        case $1 in
            -vol)
                shift
                levels="0\n10\n20\n30\n40\n50\n60\n70\n80\n90\n100"
                volume=$(echo "${levels}"  | \
                         sed 's/[<>]/ /g'  | \
                         ${volume_runner[@]} \
                        )
                set_vol=$(bc <<< "scale=1; ${volume} / 100 * 65536")
                pacmd set-sink-input-volume "$(awk '{print $1}' <<< "${client}" 2>/dev/null )" "${set_vol%.*}"
            ;;
            -sink)
                shift
                if [[ "${client}" != "" ]]; then
                    sink=$(pacmd list-sinks | \
                        grep name:          | \
                        awk 'gsub(">$","")' | \
                        cut -c 9-           | \
                        sed 's/[<>]/ /g'    | \
                        ${sink_runner[@]})
                    [[ ${SCRIPT_OUTPUT} ]] && echo "${sink}"
                    pacmd move-sink-input $(awk '{print $1}' <<< "${client}") $(echo ${sink})
                fi
            ;;
            *)
        esac
esac
