function Update()
	m_parent = SKIN:GetMeasure('MeasureSunsetUnix')
	content  = m_parent:GetValue()
	return os.date('%H:%M', content)
end