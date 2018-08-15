SELECT year, quarter, LocationAbbr, LocationDesc, ProvisionDesc, ProvisionAltValue, Enacted_date, Effective_date

FROM tobacco.tax_leg
WHERE ProvisionDesc LIKE '%$ per pack%' AND LocationAbbr = 'MI'
ORDER BY year, quarter
;

SELECT year, LocationAbbr, ProvisionDesc, avg(ProvisionAltValue), max(Enacted_date), max(Effective_date)

FROM tobacco.tax_leg
WHERE ProvisionDesc LIKE '%$ per pack%' AND LocationAbbr = 'MI'
GROUP BY year, LocationAbbr, ProvisionDesc
ORDER BY year
;

CREATE TABLE tobacco.tax_leg_C (id INT NOT NULL AUTO_INCREMENT, primary key (id))
SELECT t1.year, t1.LocationAbbr, Cigarette_tax, LittleCigar_tax
FROM
(
SELECT year, LocationAbbr, avg(ProvisionAltValue) as Cigarette_tax

FROM tobacco.tax_leg
WHERE ProvisionDesc LIKE '%$ per pack%' AND measureDesc = 'Cigarette'
GROUP BY year, LocationAbbr, ProvisionDesc
ORDER BY year
) t1
JOIN
(
SELECT year, LocationAbbr, avg(ProvisionAltValue) AS LittleCigar_tax

FROM tobacco.tax_leg
WHERE ProvisionDesc LIKE '%$ per pack%' AND measureDesc = 'Little Cigar' 
GROUP BY year, LocationAbbr, ProvisionDesc
ORDER BY year
) t2 ON (t1.year=t2.year AND t1.LocationAbbr = t2.LocationAbbr)
ORDER by t1.year
;