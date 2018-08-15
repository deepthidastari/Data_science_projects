# Current Smoker Rates

#DROP TABLE current_smokers;
#CREATE TABLE current_smokers
SELECT Year, LocationAbbr, Data_Value AS pct_Smoke, Age, Education
FROM behavior_risk_factor
WHERE MeasureDesc = 'Current Smoking'
	AND Gender = 'Overall'
    AND Race = 'All Races'
    AND Age NOT IN ('Age 20 and Older', 'Age 25 and Older','All Ages' , '18 to 44 Years')
    AND Education != 'All Grades'
; #query empty 

# Current Smokers By Age
CREATE TABLE current_smokers_age
SELECT Year, LocationAbbr, Data_Value AS pct_Smoke, Age
FROM behavior_risk_factor
WHERE MeasureDesc = 'Current Smoking'
	AND Gender = 'Overall'
    AND Race = 'All Races'
    AND Age NOT IN ('Age 20 and Older', 'Age 25 and Older','All Ages' , '18 to 44 Years')
    AND Education = 'All Grades'
;

# Current Smokers by Grade
CREATE TABLE current_smokers_edu
SELECT Year, LocationAbbr, Data_Value AS pct_Smoke, Education
FROM behavior_risk_factor
WHERE MeasureDesc = 'Current Smoking'
	AND Gender = 'Overall'
    AND Race = 'All Races'
    AND Age = 'Age 20 and Older'
    AND Education != 'All Grades'
;