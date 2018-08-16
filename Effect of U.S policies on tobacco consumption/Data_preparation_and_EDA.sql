Use tobacco;
select distinct(Age) from behavior_risk_factor;
select * from behavior_risk_factor LIMIT 5000;

select count(*) from behavior_risk_factor where YEAR = '2013' and LocationAbbr = 'AL';
select * from behavior_risk_factor where YEAR = '2013' and LocationAbbr = 'AL' and Age = "All Ages";

select YEAR, LocationAbbr, TopicDesc,MeasureDesc, Data_Value, Gender, Race , Age, Education from 
behavior_risk_factor where YEAR = '2013' and LocationAbbr = 'AL';
select distinct TopicDesc  from behavior_risk_factor ;
select distinct MeasureDesc from behavior_risk_factor;

select Age , Gender from behavior_risk_factor 
where YEAR = '2013' and LocationDesc = 'Alabama' GROUP BY LocationDesc, YEAR;

Select Age, Gender, Year, LocationDesc from behavior_risk_factor 
where YEAR = '2013' and LocationDesc = 'Alabama' GROUP BY LocationDesc, YEAR;
select distinct TopicDesc from behavior_risk_factor;
select distinct MeasureDesc from behavior_risk_factor;

select avg(Data_Value), Age, Year, LocationAbbr from behavior_risk_factor 
where Age NOT IN ('Age 20 and Older', 'Age 25 and Older','All Ages' , '18 to 44 Years') GROUP by Age ;

#Number of Current Cigarette smokers by year, by state

select avg(Data_Value), Year, LocationAbbr, MeasureDesc from behavior_risk_factor
where MeasureDesc = 'Current Smoking' and Gender = 'Overall' and 
Age = 'All Ages' and Education = 'All Grades' and Race = 'All Races'
GROUP BY Year, LocationAbbr, MeasureDesc 
ORDER BY LocationAbbr, Year DESC;

#Percentages of people smoking cigarettes everyday/somedays by year, by state
select avg(Data_Value), Year, LocationAbbr, MeasureDesc , Response from 
behavior_risk_factor 
where MeasureDesc = 'Smoking Frequency' and Gender = 'Overall' and 
Age = 'All Ages' and Education = 'All Grades'
GROUP BY Response , Year, LocationAbbr, MeasureDesc 
Order by LocationAbbr, Year DESC;

#Create Dummy Variables for Every Day somking and Some Days Smoking

Select * , if (Response = 'Every Day',1,0) as EveryDay, if(Response = 'Some Days',1,0) as SomeDays from 
(select avg(Data_Value), Year, LocationAbbr, MeasureDesc , Response from 
behavior_risk_factor 
where MeasureDesc = 'Smoking Frequency' and Gender = 'Overall' and 
Age = 'All Ages' and Education = 'All Grades'
GROUP BY Response , Year, LocationAbbr, MeasureDesc 
Order by LocationAbbr, Year DESC) T1;

# Aggregating the dummy variable values
Select Year, LocationAbbr, Max(EveryDay), Max(SomeDays) from
	(
		Select * , if (Response = 'Every Day',PercentSmokers,0) as EveryDay,if(Response = 'Some Days',PercentSmokers,0) as SomeDays from 
			(
            select avg(Data_Value) as PercentSmokers, Year, LocationAbbr, MeasureDesc , Response from 
			behavior_risk_factor 
			where MeasureDesc = 'Smoking Frequency' and Gender = 'Overall' and 
			Age = 'All Ages' and Education = 'All Grades'
            GROUP BY Response , Year, LocationAbbr, MeasureDesc 
			Order by LocationAbbr, Year DESC
			) T1
      ) T2
      GROUP BY Year, LocationAbbr 
      
	  Order by LocationAbbr, Year DESC;
	  
 # creating a new table to stor SmokingFrequency results     
 Create table SmokingFrequency(
  Year int,
  LocationAbbr varchar(255),
  PercentPeopleSmokingEveryDay varchar(255),
  PercentPeopleSmokingSomeDays varchar(255)
 );    

# Inserting results of smoking frequency into newly created table      
 Insert into SmokingFrequency 
 Select Year, LocationAbbr, Max(EveryDay), Max(SomeDays) from
	(
		Select * , if (Response = 'Every Day',PercentSmokers,0) as EveryDay,if(Response = 'Some Days',PercentSmokers,0) as SomeDays from 
			(
            select avg(Data_Value) as PercentSmokers, Year, LocationAbbr, MeasureDesc , Response from 
			behavior_risk_factor 
			where MeasureDesc = 'Smoking Frequency' and Gender = 'Overall' and 
			Age = 'All Ages' and Education = 'All Grades'
            GROUP BY Response , Year, LocationAbbr, MeasureDesc 
			Order by LocationAbbr, Year DESC
			) T1
      ) T2
      GROUP BY Year, LocationAbbr 
	  Order by LocationAbbr, Year DESC;  
      
Select * from SmokingFrequency;

Describe SmokingFrequency;

# Percentage of population in each level of use per(>25 cigrattes, <15 cigarattes and 15 to 25 Cigarattes)
# day by state by year

select avg(Data_Value), Year, LocationAbbr, MeasureDesc, Response from behavior_risk_factor
where MeasureDesc = 'Daily Cigarette Consumption Among Every Day Smokers - Frequency Categories' 
and Gender = 'Overall' and Age = 'All Ages' and Education = 'All Grades' and Race = 'All Races'
GROUP BY Response , Year, LocationAbbr, MeasureDesc 
ORDER BY Year, LocationAbbr DESC;

# Creating Dummy Variables 
Select * , if (Response = '> 25 Cigarettes',1,0) as GreaterThan25, if(Response = '< 15 Cigarettes',1,0) as LessThan15,
if(Response = '15 to 25 Cigarettes',1,0) as Between15And25 from 
(
	select avg(Data_Value), Year, LocationAbbr, MeasureDesc, Response from behavior_risk_factor
	where MeasureDesc = 'Daily Cigarette Consumption Among Every Day Smokers - Frequency Categories' 
	and Gender = 'Overall' and Age = 'All Ages' and Education = 'All Grades' and Race = 'All Races'
	GROUP BY Response , Year, LocationAbbr, MeasureDesc 
	ORDER BY Year, LocationAbbr DESC
) T3;

# Aggregating Dummy Variables

Select Year, LocationAbbr, Max(LessThan15), Max(Between15And25), Max(GreaterThan25) from
	(
		Select * , if (Response = '> 25 Cigarettes',NumberOfCigarettes,0) as GreaterThan25, if(Response = '< 15 Cigarettes',NumberOfCigarettes,0) as LessThan15,
		if(Response = '15 to 25 Cigarettes',NumberOfCigarettes,0) as Between15And25 from 
		(
			select avg(Data_Value) as NumberOfCigarettes, Year, LocationAbbr, MeasureDesc, Response from behavior_risk_factor
			where MeasureDesc = 'Daily Cigarette Consumption Among Every Day Smokers - Frequency Categories' 
			and Gender = 'Overall' and Age = 'All Ages' and Education = 'All Grades' and Race = 'All Races'
			GROUP BY Response , Year, LocationAbbr, MeasureDesc 
			ORDER BY Year, LocationAbbr DESC
		) T3
	) T4
      GROUP BY Year, LocationAbbr 
	  Order by LocationAbbr, Year DESC;
      
# Creating a new table for avg Number of Cigarettes  smoked
Use tobacco;

 Create table tobacco.NumberOfCigarattesSmoked(
  Year int,
  LocationAbbr varchar(255),
  LessThan15 int,
  Between15And25 int,
  GreaterThan25 int
  );   
  
Insert into NumberOfCigarattesSmoked
   Select Year, LocationAbbr, Max(LessThan15), Max(Between15And25), Max(GreaterThan25) from
	(
		Select * , if (Response = '> 25 Cigarettes',NumberOfCigarettes,0) as GreaterThan25, if(Response = '< 15 Cigarettes',NumberOfCigarettes,0) as LessThan15,
		if(Response = '15 to 25 Cigarettes',NumberOfCigarettes,0) as Between15And25 from 
		(
			select avg(Data_Value) as NumberOfCigarettes, Year, LocationAbbr, MeasureDesc, Response from behavior_risk_factor
			where MeasureDesc = 'Daily Cigarette Consumption Among Every Day Smokers - Frequency Categories' 
			and Gender = 'Overall' and Age = 'All Ages' and Education = 'All Grades' and Race = 'All Races'
			GROUP BY Response , Year, LocationAbbr, MeasureDesc 
			ORDER BY Year, LocationAbbr DESC
		) T3
	) T4
      GROUP BY Year, LocationAbbr 
	  Order by LocationAbbr, Year DESC;

select * from NumberOfCigarattesSmoked;

Describe NumberOfCigarattesSmoked;

Describe health_policy_funding;

select * from  PolicyFunding_Capita;

select * from behavior_risk_factor 
where MeasureDesc = 'Daily Cigarette Consumption Among Every Day Smokers - Frequency Categories' 
			and Gender = 'Overall' and Age = 'All Ages' and Education = 'All Grades' and Race = 'All Races'
			
            group by year, LocationAbbr
            order by year, LocationAbbr ASC;

Select Year, LocationAbbr, Max(LessThan15), Max(Between15And25), Max(GreaterThan25) from
	(
		Select * , if (Response = '> 25 Cigarettes',NumberOfCigarettes,0) as GreaterThan25, if(Response = '< 15 Cigarettes',NumberOfCigarettes,0) as LessThan15,
		if(Response = '15 to 25 Cigarettes',NumberOfCigarettes,0) as Between15And25 from 
		(
			select avg(Data_Value) as NumberOfCigarettes, Year, LocationAbbr, MeasureDesc, Response from behavior_risk_factor
			where MeasureDesc = 'Daily Cigarette Consumption Among Every Day Smokers - Frequency Categories' 
			and Gender = 'Overall' and Age = 'All Ages' and Education = 'All Grades' and Race = 'All Races'
			GROUP BY Response , Year, LocationAbbr, MeasureDesc 
			ORDER BY Year, LocationAbbr DESC
		) T3
	) T4
      GROUP BY Year, LocationAbbr 
	  Order by LocationAbbr, Year DESC;
