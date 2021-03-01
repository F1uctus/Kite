function Initialize()
    mSunrise = SKIN:GetMeasure('MeasureSunriseUnix')
    mSunset = SKIN:GetMeasure('MeasureSunsetUnix')
end

function Update()
    sunrise = os.date('%H:%M', mSunrise:GetValue())
    sunset = os.date('%H:%M', mSunset:GetValue())
    SKIN:Bang("!SetVariable", "sunrise-time", sunrise)
    SKIN:Bang("!SetVariable", "sunset-time", sunset)

    sunrise = hmToSeconds(sunrise)
    sunset = hmToSeconds(sunset)
    percents = timeToPercents(sunrise, sunset)
    SKIN:Bang("!SetVariable", "elapsed-daytime-percents", percents)
end

function hmToSeconds(hm)
    hour, min = hm:match("(%d+)%p(%d%d)")
    return hour * 3600 + min * 60
end

function nowSeconds()
    datetime = os.date("*t", os.time())
    return datetime.hour * 3600 + datetime.min * 60 + datetime.sec
end

function timeToPercents(start_sec, end_sec)
    now_sec = nowSeconds()
    if now_sec < start_sec then
        return 0
    end
    return now_sec / end_sec
end