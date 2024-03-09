SELECT*
FROM dailyActivity_merged as act
INNER JOIN dailySteps_merged as st
ON act.Id = st.Id

SELECT *
FROM dailyActivity_merged as act
INNER JOIN dailyCalories_merged as cal
ON act.Id = cal.Id

SELECT *
FROM dailyActivity_merged as act
INNER JOIN dailyIntensities_merged as inte
on act.Id = inte.Id

SELECT *
FROM dailyActivity_merged act
INNER JOIN hourlyCalories_merged hrcal
ON act.Id = hrcal.Id

SELECT COUNT (DISTINCT id) as unique_id
FROM daily_activity_merged

SELECT COUNT (DISTINCT id) as unique_id
FROM weight_logInfo_merged