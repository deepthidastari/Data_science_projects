CREATE TABLE tobacco.smokefree_restrictions (id INT NOT NULL AUTO_INCREMENT, primary key (id))
SELECT year, LocationAbbr, max(bars) as bars, max(dayCares) as dayCares, max(housing) as housing, max(worksites) as worksites, 
	max(hotels) as hotels, max(vehicles) as vehicles, max(restaurants) as restaurants
FROM (

	SELECT t1.*, 
		if(MeasureDesc = 'Bars', lawType, 0) AS bars,
		if(MeasureDesc = 'Commercial Day Care Centers' AND MeasureDesc = 'Home-based Day Care Centers', lawType, 0) AS dayCares,
		if(MeasureDesc = 'Government Multi-Unit Housing' AND MeasureDesc = 'Private Multi-Unit Housing', lawType, 0) AS housing,
		if(MeasureDesc = 'Government Worksites' AND MeasureDesc = 'Private Worksites', lawType, 0) AS worksites,
		if(MeasureDesc = 'Hotels and Motels', lawType, 0) AS hotels,
		if(MeasureDesc = 'Personal Vehicles', lawType, 0) AS vehicles,
		if(MeasureDesc = 'Restaurants', lawType, 0) AS restaurants
	FROM (
		SELECT year, quarter, LocationAbbr, MeasureDesc, ProvisionDesc, ProvisionValue, ProvisionAltValue, 
		 case when ProvisionAltValue = 4 then 2 when ProvisionAltValue = 3 then 1 when ProvisionAltValue = 2 then 1 when ProvisionAltValue = 1 then 0 else 0 end AS lawType 
		FROM tobacco.smokefree_leg_noDates
		WHERE ProvisionGroupDesc = 'Restrictions' AND ProvisionDesc LIKE 'Type of Restriction in%'
	) t1
) t2
GROUP BY year, LocationAbbr
;

DROP TABLE tobacco.smokefree_penalties;
CREATE TABLE tobacco.smokefree_penalties (id INT NOT NULL AUTO_INCREMENT, primary key (id))
SELECT year, LocationAbbr, 
max(bars_business) as bars_business, max(dayCares_business) as dayCares_business, max(housing_business) as housing_business, max(worksites_business) as worksites_business, 
max(hotels_business) as hotels_business, max(vehicles_business) as vehicles_business, max(restaurants_business) as restaurants_business,
#max(bars_Driver) as bars_Driver, max(dayCares_Driver) as dayCares_Driver, max(housing_Driver) as housing_Driver, max(worksites_Driver) as worksites_Driver, 
#max(hotels_Driver) as hotels_Driver, max(restaurants_Driver) as restaurants_Driver,
max(vehicles_Driver) as vehicles_Driver,
max(bars_Smoker) as bars_Smoker, max(dayCares_Smoker) as dayCares_Smoker, max(housing_Smoker) as housing_Smoker, max(worksites_Smoker) as worksites_Smoker, 
max(hotels_Smoker) as hotels_Smoker, max(vehicles_Smoker) as vehicles_Smoker, max(restaurants_Smoker) as restaurants_Smoker
FROM (

	SELECT t1.*, 
		if(MeasureDesc = 'Bars' AND ProvisionDesc = 'Penalty to Business', lawType, 0) AS bars_business,
		if(MeasureDesc = 'Commercial Day Care Centers' AND MeasureDesc = 'Home-based Day Care Centers' AND ProvisionDesc = 'Penalty to Business', lawType, 0) AS dayCares_business,
		if(MeasureDesc = 'Government Multi-Unit Housing' AND MeasureDesc = 'Private Multi-Unit Housing' AND ProvisionDesc = 'Penalty to Business', lawType, 0) AS housing_business,
		if(MeasureDesc = 'Government Worksites' AND MeasureDesc = 'Private Worksites' AND ProvisionDesc = 'Penalty to Business', lawType, 0) AS worksites_business,
		if(MeasureDesc = 'Hotels and Motels' AND ProvisionDesc = 'Penalty to Business', lawType, 0) AS hotels_business,
		if(MeasureDesc = 'Personal Vehicles' AND ProvisionDesc = 'Penalty to Business', lawType, 0) AS vehicles_business,
		if(MeasureDesc = 'Restaurants' AND ProvisionDesc = 'Penalty to Business', lawType, 0) AS restaurants_business,
        
		#if(MeasureDesc = 'Bars' AND ProvisionDesc = 'Penalty to Driver', lawType, 0) AS bars_Driver,
		#if(MeasureDesc = 'Commercial Day Care Centers' AND MeasureDesc = 'Home-based Day Care Centers' AND ProvisionDesc = 'Penalty to Driver', lawType, 0) AS dayCares_Driver,
		#if(MeasureDesc = 'Government Multi-Unit Housing' AND MeasureDesc = 'Private Multi-Unit Housing' AND ProvisionDesc = 'Penalty to Driver', lawType, 0) AS housing_Driver,
		#if(MeasureDesc = 'Government Worksites' AND MeasureDesc = 'Private Worksites' AND ProvisionDesc = 'Penalty to Driver', lawType, 0) AS worksites_Driver,
		#if(MeasureDesc = 'Hotels and Motels' AND ProvisionDesc = 'Penalty to Driver', lawType, 0) AS hotels_Driver,
		if(MeasureDesc = 'Personal Vehicles' AND ProvisionDesc = 'Penalty to Driver', lawType, 0) AS vehicles_Driver,
		#if(MeasureDesc = 'Restaurants' AND ProvisionDesc = 'Penalty to Driver', lawType, 0) AS restaurants_Driver,
        
        if(MeasureDesc = 'Bars' AND ProvisionDesc = 'Penalty to Smoker', lawType, 0) AS bars_Smoker,
		if(MeasureDesc = 'Commercial Day Care Centers' AND MeasureDesc = 'Home-based Day Care Centers' AND ProvisionDesc = 'Penalty to Smoker', lawType, 0) AS dayCares_Smoker,
		if(MeasureDesc = 'Government Multi-Unit Housing' AND MeasureDesc = 'Private Multi-Unit Housing' AND ProvisionDesc = 'Penalty to Smoker', lawType, 0) AS housing_Smoker,
		if(MeasureDesc = 'Government Worksites' AND MeasureDesc = 'Private Worksites' AND ProvisionDesc = 'Penalty to Smoker', lawType, 0) AS worksites_Smoker,
		if(MeasureDesc = 'Hotels and Motels' AND ProvisionDesc = 'Penalty to Smoker', lawType, 0) AS hotels_Smoker,
		if(MeasureDesc = 'Personal Vehicles' AND ProvisionDesc = 'Penalty to Smoker', lawType, 0) AS vehicles_Smoker,
		if(MeasureDesc = 'Restaurants' AND ProvisionDesc = 'Penalty to Smoker', lawType, 0) AS restaurants_Smoker
	FROM (
		SELECT year, quarter, LocationAbbr, MeasureDesc, ProvisionDesc, ProvisionValue, ProvisionAltValue, 
		 		 case when ProvisionAltValue = 2 then 1 when ProvisionAltValue = 1 then 0 else 0 end AS lawType 
		FROM tobacco.smokefree_leg_noDates
		WHERE ProvisionGroupDesc = 'Penalties' AND (ProvisionDesc = 'Penalty to Business' OR ProvisionDesc = 'Penalty to Smoker' OR ProvisionDesc = 'Penalty to Driver')
	) t1
) t2
GROUP BY year, LocationAbbr
;


SELECT DISTINCT MeasureDesc
FROM tobacco.smokefree_leg_noDates
WHERE ProvisionGroupDesc = 'Restrictions' AND ProvisionDesc LIKE 'Type of Restriction in%'

;