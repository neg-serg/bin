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

    DGR="#222222"
    LGR="#666666"

    fn1="${font}:size=11"      
    fnT="${font}:bold:size=11"  
    fn_14="${font}:bold:size=14"
    wic_13="${weather_font}:size=13"  
    wic_16="${weather_font}:size=16"   
    wic_45="${weather_font}:size=45"

    icons2="Typicons:size=16"
    icons3="Ionicons:size=16"
    icons4="Typicons:size=13"
}

function init_weather_icon_list(){
    declare -A weather_icon_list
    weather_icon_list=(
        ["clear-day"]=""
        ["clear-night"]=""
        ["rain"]=""
        ["snow"]=""
        ["sleet"]=""
        ["wind"]=""
        ["fog"]=""
        ["cloudy"]=""
        ["partly-cloudy-day"]=""
        ["partly-cloudy-night"]=""
        ["hail"]=""
        ["thunderstorm"]=""
        ["tornado"]=""
        ["N"]="" ["E"]=""
        ["S"]="" ["W"]=""
        ["NE"]="" ["NW"]=""
        ["SE"]="" ["SW"]=""
    )
}

function today_maxmin_info(){
    today_sum=$(jshon -e daily < ${forecast_data_path} | \
                jq '.data[0].summary' | \
                tr -d '"'
    )
    today_icon=$(grep $(jshon -e daily < ${forecast_data_path} | \
                        jq '.data[0].icon' | \
                        grep -o '[^\"]*') \
                weather_icon_list | \
                awk 'NR==1' | \
                grep -o "\"[^\"]*\"" | \
                grep -o "[^\"]*"
    )

    # Temperature max/min levels
    today_temp_max=$(printf "%0.0f\n" \
        $(jshon -e daily < ${forecast_data_path} | \
        jq '.data[0].temperatureMax'
        )
    )
    today_temp_min=$(printf "%0.0f\n" \
        $(jshon -e daily < ${forecast_data_path} | \
        jq '.data[0].temperatureMin')
    )
}

function today_sun_info(){
    local sunriseTimeStamp=$(jshon -e daily < ${forecast_data_path} | jq '.data[0].sunriseTime')
    local sunsetTimeStamp=$(jshon -e daily < ${forecast_data_path} | jq '.data[0].sunsetTime')

    local sunriseTime=$(date -ud @${sunriseTimeStamp})
    local sunsetTime=$(date -ud @${sunsetTimeStamp})

    today_sunrise=$(date -d "${sunriseTime}" +'%H:%M')
    today_sunset=$(date -d "${sunsetTime}" +'%H:%M')
}

# Moon phase
function today_moon_info(){
    lunationNumber=$(jshon -e daily < ${forecast_data_path} | jq '.data[0].moonPhase')
}

# Wind info
function today_wind_info(){
    windSpeed=$(jshon -e currently < ${forecast_data_path} | jq '.windSpeed')

    # Getting today's wind Speed and wind Bearing
    if (( $(bc -l <<<  "${windSpeed} != 0" ) )); then
        wind_bearing=$(jshon -e currently < ${forecast_data_path} | jq '.wind_bearing')
    else
        wind_bearing="n/a"
    fi
}

# Getting today's wind direction name
function today_wind_direction(){
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

function today_temp_sum(){
    today_sum=$(jshon -e currently < ${forecast_data_path} | jq '.summary' | tr -d '"')
    today_icon=$(grep $(jshon -e currently < ${forecast_data_path} | jq '.icon' | \
        grep -o '[^\"]*') weather_icon_list | \
        awk 'NR==1' | \
        grep -o "\"[^\"]*\"" | \
        grep -o "[^\"]*")
    today_temp=$(printf "%0.0f\n" \
        $(jshon -e currently < ${forecast_data_path} | \
        jq '.temperature'))
}

function today_cloudiness(){
    cloudiness=$(jshon -e currently < ${forecast_data_path} | jq '.cloudCover')
    if (( $(bc -l <<< "${cloudiness} != 0") )); then
        if [[ "${cloudiness}" = "1" ]]; then
            cloudiness=$(bc -l <<< "${cloudiness} * 100")
        else
            cloudiness=$(bc -l <<<  "${cloudiness} * 100"| tr -d '.00')
        fi
    else
        cloudiness="${cloudiness}"
    fi
}

# Humidity
function today_humidity(){
    humidity=$(jshon -e currently < ${forecast_data_path} | jq '.humidity')
    if (( $(bc -l <<<  "${humidity} != 0") )); then
        if [[ "${humidity}" = "1" ]]; then
            humidity=$(bc -l <<<  "${humidity} * 100")
        else
            humidity=$(bc -l <<< "${humidity} * 100"| tr -d '.00')
        fi
    else
        humidity="${humidity}"
    fi
}

function tomorrow_name(){
    next_name=$(date --date='+1 day' +'%a' | tr '[:lower:]' '[:upper:]')
}

function tomorrow_sum(){
    next_sum=$(jshon -e daily < ${forecast_data_path} | \
        jq '.data[1].summary' | \
        tr -d '"')
}

function tomorrow_icon(){
    next_icon=$(grep $(jshon -e daily < ${forecast_data_path} | \
        jq '.data[1].icon' | \
        grep -o '[^\"]*') \
        weather_icon_list | \
        awk 'NR==1' | \
        grep -o "\"[^\"]*\"" | \
        grep -o "[^\"]*")
}

function tomorrow_minmax(){
    next_temp_max=$(printf "%0.0f\n" $(jshon -e daily < ${forecast_data_path} | jq '.data[1].temperatureMax'))
    next_temp_min=$(printf "%0.0f\n" $(jshon -e daily < ${forecast_data_path} | jq '.data[1].temperatureMin'))
}

function tomorrow_sun_info(){
    next_sunriseTimeStamp=$(jshon -e daily < ${forecast_data_path} | jq '.data[1].sunriseTime')
    next_sunsetTimeStamp=$(jshon -e daily < ${forecast_data_path} | jq '.data[1].sunsetTime')

    next_sunriseTime=$(date -ud @${next_sunriseTimeStamp})
    next_sunsetTime=$(date -ud @${next_sunsetTimeStamp})

    next_sunrise=$(date -d "${next_sunriseTime}" +'%H:%M')
    next_sunset=$(date -d "${next_sunsetTime}" +'%H:%M')
}

function tomorrow_cloudiness(){
    tomorrow_cloudiness=$(jshon -e daily < ${forecast_data_path} | jq '.data[1].cloudCover')
    if (( $(bc -l <<< "${tomorrow_cloudiness} != 0") )); then
        if [[ "${tomorrow_cloudiness}" = "1" ]]; then
            tomorrow_cloudiness=$(bc -l <<<  "${tomorrow_cloudiness} * 100")
        else
            tomorrow_cloudiness=$(bc -l <<< "${tomorrow_cloudiness} * 100" | tr -d '.00')
        fi
    else
        tomorrow_cloudiness="${tomorrow_cloudiness}"
    fi
}

function tomorrow_humidity(){
    tomorrow_humidity=$(jshon -e daily < ${forecast_data_path} | jq '.data[1].humidity')

    if (( $(echo "${tomorrow_humidity} != 0" | bc -l) )); then
        if [[ "${tomorrow_humidity}" = "1" ]]; then
            tomorrow_humidity=$(bc -l <<<  "${tomorrow_humidity} * 100")
        else
            tomorrow_humidity=$(bc -l <<<  "${tomorrow_humidity} * 100"| tr -d '.00')
        fi
    else
        tomorrow_humidity="${tomorrow_humidity}"
    fi
}

function main(){
    load_forecast_info
    init_settings
    init_weather_icon_list

    today_maxmin_info
    today_sun_info
    today_moon_info
    today_temp_sum

    today_humidity
    today_wind_info
    today_wind_direction
    today_cloudiness

    tomorrow_name
    tomorrow_sum
    tomorrow_icon
    tomorrow_minmax
    tomorrow_sun_info
    tomorrow_cloudiness
    tomorrow_humidity

    d3name=$(date --date='+2 day' +'%a' | tr '[:lower:]' '[:upper:]')
    d3sum=$(jshon -e daily < ${forecast_data_path} | jq '.data[2].summary' | tr -d '"')
    d3icon=$(grep $(jshon -e daily < ${forecast_data_path} | \
                    jq '.data[2].icon' | \
                    grep -o '[^\"]*') \
                weather_icon_list | \
                awk 'NR==1' | \
                grep -o "\"[^\"]*\"" | \
                grep -o "[^\"]*" \
    )

    d3tempmax=$(printf "%0.0f\n" \
        $(jshon -e daily < ${forecast_data_path} | \
        jq '.data[2].temperatureMax') \
    )
    d3tempmin=$(printf "%0.0f\n" \
        $(jshon -e daily < ${forecast_data_path} | \
        jq '.data[2].temperatureMin') \
    )

    d4name=$(date --date='+3 day' +'%a' | \
                tr '[:lower:]' '[:upper:]' \
            )
    d4sum=$(jshon -e daily < ${forecast_data_path} | \
            jq '.data[3].summary' | \
            tr -d '"' \
            )
    d4icon=$(grep $(jshon -e daily < ${forecast_data_path} | \
                    jq '.data[3].icon' | \
                    grep -o '[^\"]*') \
                weather_icon_list | \
                awk 'NR==1' | \
                grep -o "\"[^\"]*\"" | \
                grep -o "[^\"]*" \
    )
    d4tempmax=$(printf "%0.0f\n" \
                    $(jshon -e daily < ${forecast_data_path} | \
                    jq '.data[3].temperatureMax') \
                )
    d4tempmin=$(printf "%0.0f\n" \
                    $(jshon -e daily < ${forecast_data_path} | \
                    jq '.data[3].temperatureMin') \
                )

    d5name=$(date --date='+4 day' +'%a' | tr '[:lower:]' '[:upper:]')
    d5sum=$(jshon -e daily < ${forecast_data_path} | \
            jq '.data[4].summary' | \
            tr -d '"' \
    )
    d5icon=$(grep $(jshon -e daily < ${forecast_data_path} | \
                    jq '.data[4].icon' | \
                    grep -o '[^\"]*') \
                weather_icon_list | \
                awk 'NR==1' | \
                grep -o "\"[^\"]*\"" | \
                grep -o "[^\"]*" \
    )
    d5tempmax=$(printf "%0.0f\n" \
        $(jshon -e daily < ${forecast_data_path} | \
        jq '.data[4].temperatureMax') \
    )
    d5tempmin=$(printf "%0.0f\n" \
        $(jshon -e daily < ${forecast_data_path} | \
        jq '.data[4].temperatureMin') \
    )

    (
        echo "    ^fn(${fn_14})${today_temp}°, ${today_sum}  ^fn(${fn1})"
        echo -ne "    ^p(+50;-9)^fn(${wic_45})${today_icon}^fn(${fn1})^p() ^p(+75)^fg(#87d7ff)${today_temp_min}°^fg()^fn(${icons2})^fn($fn1)^p(+2)^fg(#ff8b8b)${today_temp_max}°^fg()^p()  ${wind_dir} ^fn(${wic_16})${wind_icon}^fn(${fn1}) ${windSpeed} m/s\n" \
        "   ^p(+50;-36)^fn(${wic_45})${today_icon}^fn(${fn1})^p() ^p(+75)^fn(${wic_16})^fn(${fn1}) ${humidity}%  ^fn(${icons3})^fn($fn1) ${cloudiness}%\n" \
        "   ^p(+50;-63)^fn(${wic_45})${today_icon}^fn(${fn1})^p()^p(+82)^fg(#ffd7af)^fn(${wic_13})^fn(${fn1})^fg() ${today_sunrise}  ^fg(#ffafaf)^fn(${wic_13})^fn(${fn1})^fg() ${today_sunset}\n" \
        "   ${today_sum}\n" \
        "   ^fg(${FG})-----------------------------------------------------\n" \
        "   ^bg(${DGR})^fn(${fn_14}) ${next_name} ^fn(${fn1})^bg()  ^fn(${wic_16})${next_icon}^fn(${fn1}) ^p(;+2)^fg(#87d7ff)${next_temp_min}°^fg()^fn(${icons4})^fn(${fn1})^p(+3)^fg(#ff8b8b)${next_temp_max}°^fg()^p()   ^fg(#ffd7af)^fn(${wic_13})^fn(${fn1})^fg() ${next_sunrise} ^fg(#ffafaf)^fn(${wic_13})^fn(${fn1})^fg() ${next_sunset}  ^fn(${wic_16})^fn(${fn1}) ${tomorrow_humidity}%\n" \
        "   ${next_sum}\n" \
        "   ^bg(${DGR})^fn(${fn_14}) ${d3name} ^fn(${fn1})^bg()  ^fn(${wic_16})${d3icon}^fn(${fn1}) ^p(;+2)^fg(#87d7ff)${d3tempmin}°^fg()^fn(${icons4})^fn(${fn1})^p(+3)^fg(#ff8b8b)${d3tempmax}°^fg()\n" \
        "   ${d3sum}\n" \
        "   ^bg(${DGR})^fn(${fn_14}) ${d4name} ^fn(${fn1})^bg()  ^fn(${wic_16})${d4icon}^fn(${fn1}) ^p(;+2)^fg(#87d7ff)${d4tempmin}°^fg()^fn(${icons4})^fn(${fn1})^p(+3)^fg(#ff8b8b)${d4tempmax}°^fg()\n" \
        "   ${d4sum}\n" \
        "   ^bg(${DGR})^fn(${fn_14}) ${d5name} ^fn(${fn1})^bg()  ^fn(${wic_16})${d5icon}^fn(${fn1}) ^p(;+2)^fg(#87d7ff)${d5tempmin}°^fg()^fn(${icons4})^fn(${fn1})^p(+3)^fg(#ff8b8b)${d5tempmax}°^fg()\n" \
        "   ${d5sum}\n" \
        "^bg(${LGR})^fg(${DGR})   Powered by forecast.io   \n" \
    ) | dzen2 -p -x 582 -y 28 -w 420 \
        -bg ${BG} -fg ${FG} \
        -h 27 -l 14 -sa l -ta l \
        -e 'onstart=uncollapse;button1=exit;button3=exit' \
        -fn "${fn1}"
}

main "$@"
