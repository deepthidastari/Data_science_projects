use tobacco;

#DROP TABLE combined_table;
CREATE TABLE tax_funding (id INT NOT NULL AUTO_INCREMENT, primary key (id))
SELECT `tax_leg_C`.`id`,
    `tax_leg_C`.`year`,
    `tax_leg_C`.`LocationAbbr`,
    `tax_leg_C`.`Cigarette_tax`,
    `tax_leg_C`.`LittleCigar_tax`,
    `PolicyFunding_Capita`.`funding_per_capita`
FROM tax_leg_C 
# LEFT JOIN NumberOfCigarattesSmoked t2 ON (t1.year=t2.year AND t1.LocationAbbr=t2.LocationAbbr)
#LEFT JOIN SmokingFrequency  ON (`tax_leg_C`.year=`SmokingFrequency`.year AND `tax_leg_C`.LocationAbbr=`SmokingFrequency`.LocationAbbr)
#LEFT JOIN 
#LEFT JOIN smokefree_penalties  ON (`tax_leg_C`.year=`smokefree_penalties`.year AND `tax_leg_C`.LocationAbbr=`smokefree_penalties`.LocationAbbr)
#LEFT JOIN smokefree_restrictions  ON (`tax_leg_C`.year=`smokefree_restrictions`.year AND `tax_leg_C`.LocationAbbr=`smokefree_restrictions`.LocationAbbr)
JOIN PolicyFunding_Capita  ON (`tax_leg_C`.year=`PolicyFunding_Capita`.year AND `tax_leg_C`.LocationAbbr=`PolicyFunding_Capita`.LocationAbbr)
WHERE tax_leg_C.year >=1996 AND tax_leg_C.year <=2013
;


CREATE TABLE smokefree_Rest_Pen
SELECT
	`tax_leg_C`.`id`,
    `tax_leg_C`.`year`,
    `smokefree_restrictions`.`bars`,
    `smokefree_restrictions`.`dayCares`,
    `smokefree_restrictions`.`housing`,
    `smokefree_restrictions`.`worksites`,
    `smokefree_restrictions`.`hotels`,
    `smokefree_restrictions`.`vehicles`,
    `smokefree_restrictions`.`restaurants`,
	`smokefree_penalties`.`bars_business`,
    `smokefree_penalties`.`dayCares_business`,
    `smokefree_penalties`.`housing_business`,
    `smokefree_penalties`.`worksites_business`,
    `smokefree_penalties`.`hotels_business`,
    `smokefree_penalties`.`vehicles_business`,
    `smokefree_penalties`.`restaurants_business`,
    `smokefree_penalties`.`vehicles_Driver`,
    `smokefree_penalties`.`bars_Smoker`,
    `smokefree_penalties`.`dayCares_Smoker`,
    `smokefree_penalties`.`housing_Smoker`,
    `smokefree_penalties`.`worksites_Smoker`,
    `smokefree_penalties`.`hotels_Smoker`,
    `smokefree_penalties`.`vehicles_Smoker`,
    `smokefree_penalties`.`restaurants_Smoker`
FROM tax_leg_C 
LEFT JOIN smokefree_penalties  ON (`tax_leg_C`.year=`smokefree_penalties`.year AND `tax_leg_C`.LocationAbbr=`smokefree_penalties`.LocationAbbr)
LEFT JOIN smokefree_restrictions  ON (`tax_leg_C`.year=`smokefree_restrictions`.year AND `tax_leg_C`.LocationAbbr=`smokefree_restrictions`.LocationAbbr)
WHERE tax_leg_C.year >=1996 AND tax_leg_C.year <=2013