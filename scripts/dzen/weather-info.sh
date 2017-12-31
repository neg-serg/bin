#/bin/zsh

function load_forecast_info(){
    forecast_data_path=$(readlink -f "${HOME}/tmp/forecast.json")
    curl -X GET --silent "https://api.forecast.io/forecast/26611d19995c5fec79ad67e88cba6b6b/55.75,37.616667" > ${forecast_data_path}
}

function init_settings(){
    local font="Iosevka Term Medium"
    local weather_font="Weather Icons"

    FG="$(xrq 'foreground')"
    BG="$(xrq 'background')"
    DGR="#0c1014"
    SKY="#87d7ff"

    fn1="${font}:size=11"      
    fnT="${font}:bold:size=11"  
    fn_14="${font}:bold:size=14"
    wic_13="${weather_font}:size=13"  
    wic_16="${weather_font}:size=16"   
    wic_45="${weather_font}:size=45"

    ico2="Typicons:size=16"
    ico3="Ionicons:size=16"
    ico4="Typicons:size=13"
}

function init_weather_icon_list(){
    declare -A weather_icon_list
    weather_icon_list=(
        ["clear-day"]="" ["clear-night"]="" ["rain"]="" ["snow"]=""
        ["sleet"]="" ["wind"]="" ["fog"]="" ["cloudy"]=""
        ["partly-cloudy-day"]="" ["partly-cloudy-night"]=""
        ["hail"]="" ["thunderstorm"]="" ["tornado"]=""

        ["N"]=""  ["E"]=""
        ["S"]=""  ["W"]=""
        ["NE"]="" ["NW"]=""
        ["SE"]="" ["SW"]=""
    )
}

function d1maxmin_info(){
    d1sum=$(jshon -e daily < ${forecast_data_path} | \
                jq '.data[0].summary' | \
                tr -d '"'
    )
    d1icon=$(grep $(jshon -e daily < ${forecast_data_path} | \
                        jq '.data[0].icon' | \
                        grep -o '[^\"]*') \
                weather_icon_list | \
                awk 'NR==1' | \
                grep -o "\"[^\"]*\"" | \
                grep -o "[^\"]*"
    )

    # Temperature max/min levels
    d1Tmax=$(printf "%0.0f\n" \
        $(jshon -e daily < ${forecast_data_path} | \
        jq '.data[0].temperatureMax'
        )
    )
    d1Tmin=$(printf "%0.0f\n" \
        $(jshon -e daily < ${forecast_data_path} | \
        jq '.data[0].temperatureMin')
    )
}

function d1sun_info(){
    local sunriseTimeStamp=$(jshon -e daily < ${forecast_data_path} | jq '.data[0].sunriseTime')
    local sunsetTimeStamp=$(jshon -e daily < ${forecast_data_path} | jq '.data[0].sunsetTime')

    local sunriseTime=$(date -ud @${sunriseTimeStamp})
    local sunsetTime=$(date -ud @${sunsetTimeStamp})

    d1sunrise=$(date -d "${sunriseTime}" +'%H:%M')
    d1sunset=$(date -d "${sunsetTime}" +'%H:%M')
}

function d1moon_info(){
    lunationNumber=$(jshon -e daily < ${forecast_data_path} | jq '.data[0].moonPhase')
}

function d1wind_info(){
    windSpeed=$(jshon -e currently < ${forecast_data_path} | jq '.windSpeed')

    # Getting today's wind Speed and wind Bearing
    if (( $(bc -l <<<  "${windSpeed} != 0" ) )); then
        wind_bearing=$(jshon -e currently < ${forecast_data_path} | jq '.wind_bearing')
    else
        wind_bearing="n/a"
    fi
}

function d1wind_direction(){
    if [[ "${wind_bearing}" = "n/a" ]]; then
        wind_dir="n/a"
    else
        if (( "${wind_bearing}" >= 0 )) && (( "${wind_bearing}" <= 11 )); then
            wind_dir="N"
        elif (( "${wind_bearing}" > 11 )) && (( "${wind_bearing}" <= 79 )); then
            wind_dir="NE"
        elif (( "${wind_bearing}" > 79 )) && (( "${wind_bearing}" <= 101 )); then
            wind_dir="E"
        elif (( "${wind_bearing}" > 101 )) && (( "${wind_bearing}" <= 169 )); then
            wind_dir="SE"
        elif (( "${wind_bearing}" > 169 )) && (( "${wind_bearing}" <= 191 )); then
            wind_dir="S"
        elif (( "${wind_bearing}" > 191 )) && (( "${wind_bearing}" <= 259 )); then
            wind_dir="SW"
        elif (( "${wind_bearing}" > 259 )) && (( "${wind_bearing}" <= 281 )); then
            wind_dir="W"
        elif (( "${wind_bearing}" > 281 )) && (( "${wind_bearing}" <= 349 )); then
            wind_dir="NW"
        else
            wind_dir="N"
        fi
    fi

    wind_icon=$(grep $(grep -o '[^\"]*' <<<  ${wind_dir}) weather_icon_list | \
        awk 'NR==1' | \
        grep -o "\"[^\"]*\"" | \
        grep -o "[^\"]*")

}

function d1temp_sum(){
    d1sum=$(jshon -e currently < ${forecast_data_path} | jq '.summary' | tr -d '"')
    d1icon=$(grep $(jshon -e currently < ${forecast_data_path} | jq '.icon' | \
        grep -o '[^\"]*') weather_icon_list | \
        awk 'NR==1' | \
        grep -o "\"[^\"]*\"" | \
        grep -o "[^\"]*")
    d1temp=$(printf "%0.0f\n" \
        $(jshon -e currently < ${forecast_data_path} | \
        jq '.temperature'))
}

function d1cloudiness(){
    cloudiness=$(jshon -e currently < ${forecast_data_path} | jq '.cloudCover')
    if (( $(bc -l <<< "${cloudiness} != 0") )); then
        if [[ "${cloudiness}" = "1" ]]; then
            cloudiness=$(bc -l <<< "${cloudiness} * 100")
        else
            cloudiness=$(bc -l <<<  "${cloudiness} * 100"| tr -d '.00')
        fi
    fi
}

function d1humidity(){
    humidity=$(jshon -e currently < ${forecast_data_path} | jq '.humidity')
    if (( $(bc -l <<<  "${humidity} != 0") )); then
        if [[ "${humidity}" = "1" ]]; then
            humidity=$(bc -l <<<  "${humidity} * 100")
        else
            humidity=$(bc -l <<< "${humidity} * 100"| tr -d '.00')
        fi
    fi
}

function d2name(){
    d2name=$(date --date='+1 day' +'%a' | tr '[:lower:]' '[:upper:]')
}

function d2sum(){
    d2sum=$(jshon -e daily < ${forecast_data_path} | \
        jq '.data[1].summary' | \
        tr -d '"')
}

function d2icon(){
    d2icon=$(grep $(jshon -e daily < ${forecast_data_path} | \
        jq '.data[1].icon' | \
        grep -o '[^\"]*') \
        weather_icon_list | \
        awk 'NR==1' | \
        grep -o "\"[^\"]*\"" | \
        grep -o "[^\"]*")
}

function d2minmax(){
    d2Tmax=$(printf "%0.0f\n" $(jshon -e daily < ${forecast_data_path} | jq '.data[1].temperatureMax'))
    d2Tmin=$(printf "%0.0f\n" $(jshon -e daily < ${forecast_data_path} | jq '.data[1].temperatureMin'))
}

function d2sun_info(){
    d2sunriseTimeStamp=$(jshon -e daily < ${forecast_data_path} | jq '.data[1].sunriseTime')
    d2sunsetTimeStamp=$(jshon -e daily < ${forecast_data_path} | jq '.data[1].sunsetTime')

    d2sunriseTime=$(date -ud @${d2sunriseTimeStamp})
    d2sunsetTime=$(date -ud @${d2sunsetTimeStamp})

    d2sunrise=$(date -d "${d2sunriseTime}" +'%H:%M')
    d2sunset=$(date -d "${d2sunsetTime}" +'%H:%M')
}

function d2cloudiness(){
    d2cloudiness=$(jshon -e daily < ${forecast_data_path} | jq '.data[1].cloudCover')
    if (( $(bc -l <<< "${d2cloudiness} != 0") )); then
        if [[ "${d2cloudiness}" = "1" ]]; then
            d2cloudiness=$(bc -l <<<  "${d2cloudiness} * 100")
        else
            d2cloudiness=$(bc -l <<< "${d2cloudiness} * 100" | tr -d '.00')
        fi
    else
        d2cloudiness="${d2cloudiness}"
    fi
}

function d2humidity(){
    d2humidity=$(jshon -e daily < ${forecast_data_path} | jq '.data[1].humidity')

    if (( $(echo "${d2humidity} != 0" | bc -l) )); then
        if [[ "${d2humidity}" = "1" ]]; then
            d2humidity=$(bc -l <<<  "${d2humidity} * 100")
        else
            d2humidity=$(bc -l <<<  "${d2humidity} * 100"| tr -d '.00')
        fi
    else
        d2humidity="${d2humidity}"
    fi
}

function main(){
    load_forecast_info
    init_settings
    init_weather_icon_list

    #----------------------------------------------------------------
    #----[ Day 1 ]---------------------------------------------------
    #----------------------------------------------------------------
    d1maxmin_info
    d1sun_info
    d1moon_info
    d1temp_sum
    d1humidity
    d1wind_info
    d1wind_direction
    d1cloudiness

    #----------------------------------------------------------------
    #----[ Day 2 ]---------------------------------------------------
    #----------------------------------------------------------------
    d2name
    d2sum
    d2icon
    d2minmax
    d2sun_info
    d2cloudiness
    d2humidity

    #----------------------------------------------------------------
    #----[ Day 3 ]---------------------------------------------------
    #----------------------------------------------------------------
    d3name=$(date --date='+2 day' +'%a' | tr '[:lower:]' '[:upper:]')
    d3sum=$(jshon -e daily < ${forecast_data_path} | jq '.data[2].summary' | tr -d '"')
    d3icon=$(grep $(jshon -e daily < ${forecast_data_path} | \
                    jq '.data[2].icon' | \
                    grep -o '[^\"]*') \
                weather_icon_list | \
                awk 'NR==1' | \
                grep -o "\"[^\"]*\"" | \
                grep -o "[^\"]*")
    d3Tmax=$(printf "%0.0f\n" $(jshon -e daily < ${forecast_data_path} | jq '.data[2].temperatureMax'))
    d3Tmin=$(printf "%0.0f\n" $(jshon -e daily < ${forecast_data_path} | jq '.data[2].temperatureMin'))
    #----------------------------------------------------------------
    #----[ Day 4 ]---------------------------------------------------
    #----------------------------------------------------------------
    d4name=$(date --date='+3 day' +'%a' | tr '[:lower:]' '[:upper:]')
    d4sum=$(jshon -e daily < ${forecast_data_path} | jq '.data[3].summary' | tr -d '"')
    d4icon=$(grep $(jshon -e daily < ${forecast_data_path} | \
                    jq '.data[3].icon' | \
                    grep -o '[^\"]*') \
                weather_icon_list | \
                awk 'NR==1' | \
                grep -o "\"[^\"]*\"" | \
                grep -o "[^\"]*")
    d4Tmax=$(printf "%0.0f\n" $(jshon -e daily < ${forecast_data_path} | jq '.data[3].temperatureMax'))
    d4Tmin=$(printf "%0.0f\n" $(jshon -e daily < ${forecast_data_path} | jq '.data[3].temperatureMin'))

    #----------------------------------------------------------------
    #----[ Day 5 ]---------------------------------------------------
    #----------------------------------------------------------------
    d5name=$(date --date='+4 day' +'%a' | tr '[:lower:]' '[:upper:]')
    d5sum=$(jshon -e daily < ${forecast_data_path} | jq '.data[4].summary' | tr -d '"')
    d5icon=$(grep $(jshon -e daily < ${forecast_data_path} | \
                    jq '.data[4].icon' | \
                    grep -o '[^\"]*') \
                weather_icon_list | \
                awk 'NR==1' | \
                grep -o "\"[^\"]*\"" | \
                grep -o "[^\"]*" \
    )
    d5Tmax=$(printf "%0.0f\n" $(jshon -e daily < ${forecast_data_path} | jq '.data[4].temperatureMax'))
    d5Tmin=$(printf "%0.0f\n" $(jshon -e daily < ${forecast_data_path} | jq '.data[4].temperatureMin'))

    (
        echo "    ^fn(${fn_14})${d1temp}°, ${d1sum}  ^fn(${fn1})"
        echo -ne "    ^p(+50;-9)^fn(${wic_45})${d1icon}^fn(${fn1})^p() ^p(+75)^fg(${SKY})${d1Tmin}°^fg()^fn(${ico2})^fn($fn1)^p(+2)^fg(#ff8b8b)${d1Tmax}°^fg()^p()  ${wind_dir} ^fn(${wic_16})${wind_icon}^fn(${fn1}) ${windSpeed} m/s\n" \
        "   ^p(+50;-36)^fn(${wic_45})${d1icon}^fn(${fn1})^p() ^p(+75)^fn(${wic_16})^fn(${fn1}) ${humidity}%  ^fn(${ico3})^fn($fn1) ${cloudiness}%\n" \
        "   ^p(+50;-63)^fn(${wic_45})${d1icon}^fn(${fn1})^p()^p(+82)^fg(#ffd7af)^fn(${wic_13})^fn(${fn1})^fg() ${d1sunrise}  ^fg(#ffafaf)^fn(${wic_13})^fn(${fn1})^fg() ${d1sunset}\n" \
        "   ${d1sum}\n" \
        "   ^fg(${FG})-----------------------------------------------------\n" \
        "   ^bg(${DGR})^fn(${fn_14}) ${d2name} ^fn(${fn1})^bg()  ^fn(${wic_16})${d2icon}^fn(${fn1}) ^p(;+2)^fg(${SKY})${d2Tmin}°^fg()^fn(${ico4})^fn(${fn1})^p(+3)^fg(#ff8b8b)${d2Tmax}°^fg()^p()   ^fg(#ffd7af)^fn(${wic_13})^fn(${fn1})^fg() ${d2sunrise} ^fg(#ffafaf)^fn(${wic_13})^fn(${fn1})^fg() ${d2sunset}  ^fn(${wic_16})^fn(${fn1}) ${d2humidity}%\n" \
        "   ${d2sum}\n" \
        "   ^bg(${DGR})^fn(${fn_14}) ${d3name} ^fn(${fn1})^bg()  ^fn(${wic_16})${d3icon}^fn(${fn1}) ^p(;+2)^fg(${SKY})${d3Tmin}°^fg()^fn(${ico4})^fn(${fn1})^p(+3)^fg(#ff8b8b)${d3Tmax}°^fg()\n" \
        "   ${d3sum}\n" \
        "   ^bg(${DGR})^fn(${fn_14}) ${d4name} ^fn(${fn1})^bg()  ^fn(${wic_16})${d4icon}^fn(${fn1}) ^p(;+2)^fg(${SKY})${d4Tmin}°^fg()^fn(${ico4})^fn(${fn1})^p(+3)^fg(#ff8b8b)${d4Tmax}°^fg()\n" \
        "   ${d4sum}\n" \
        "   ^bg(${DGR})^fn(${fn_14}) ${d5name} ^fn(${fn1})^bg()  ^fn(${wic_16})${d5icon}^fn(${fn1}) ^p(;+2)^fg(${SKY})${d5Tmin}°^fg()^fn(${ico4})^fn(${fn1})^p(+3)^fg(#ff8b8b)${d5Tmax}°^fg()\n" \
        "   ${d5sum}\n" \
        "^bg(${FG})^fg(${BG})   Powered by forecast.io   \n" \
    ) | dzen2 -p 10 -x 582 -y 28 -w 420 \
        -bg ${BG} -fg ${FG} \
        -h 27 -l 14 -sa l -ta l \
        -e 'onstart=uncollapse;button1=exit;button3=exit' \
        -fn "${fn1}"
}

main "$@"
