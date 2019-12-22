function HM_to_sec(hm)
	hour, min = hm:match("(%d+)%p(%d%d)")
	return hour * 3600 + min * 60
end

function now_seconds()
	datetime = os.date("*t", os.time())
	return datetime.hour * 3600 + datetime.min * 60 + datetime.sec
end

function time_to_percents(start_sec, end_sec)
	now_sec = now_seconds()
	if now_sec < start_sec then
		return 0
	end
	return now_sec / end_sec
end

function Update()
	m_sunrise = SKIN:GetMeasure('MeasureSunriseTime')
	m_sunset  = SKIN:GetMeasure('MeasureSunsetTime')

	sunrise   = m_sunrise:GetStringValue()
	sunset    = m_sunset:GetStringValue()

	sunr = HM_to_sec(sunrise)
	suns = HM_to_sec(sunset)

	return time_to_percents(sunr, suns)
end