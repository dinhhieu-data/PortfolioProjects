select count(*)
from RoadAccident

select SUM(number_of_casualties) CY_Casualties
from RoadAccident
where YEAR(accident_date) = '2022'
  --and road_surface_conditions = 'Dry'



select Count(distinct accident_index) CY_Accidents
from RoadAccident
where YEAR(accident_date) = '2022'


select SUM(number_of_casualties) CY_Fatal_Casualties
from RoadAccident
where YEAR(accident_date) = '2022'
  and accident_severity = 'Fatal'


select SUM(number_of_casualties) CY_Serious_Casualties
from RoadAccident
where YEAR(accident_date) = '2022'
  and accident_severity = 'Serious'


select SUM(number_of_casualties) CY_Slight_Casualties
from RoadAccident
where YEAR(accident_date) = '2022'
  and accident_severity = 'Slight'



select CAST(SUM(number_of_casualties) AS decimal(10,2))*100 / (SELECT CAST(SUM(number_of_casualties) as decimal(10,2)) FROM RoadAccident) SlightPercent
from RoadAccident
where accident_severity = 'Slight'


select CAST(SUM(number_of_casualties) AS decimal(10,2))*100 / (SELECT CAST(SUM(number_of_casualties) as decimal(10,2)) FROM RoadAccident) SeriousPercent
from RoadAccident
where accident_severity = 'Serious'

select CAST(SUM(number_of_casualties) AS decimal(10,2))*100 / (SELECT CAST(SUM(number_of_casualties) as decimal(10,2)) FROM RoadAccident) FatalPercent
from RoadAccident
where accident_severity = 'Fatal'


--------------------------------------------------------------------------------------------------------

select * from RoadAccident


select
	case
		when vehicle_type IN ('agricultural vehicle') THEN 'Agricultural'
		when vehicle_type IN ('Car', 'Taxi/Private hire car') THEN 'Cars'
		when vehicle_type IN ('Motorcycle 125cc and under',
							  'Motorcycle 50cc and under',
							  'Motorcycle over 500cc',
							  'Motorcycle over 125cc and up to 500cc',
							  'Pedal cycle') THEN 'Bike'
		when vehicle_type IN ('Bus or coach (17 or more pass seats)', 'Minibus (8 - 16 passenger seats)') THEN 'Bus'
		when vehicle_type IN ('Goods 7.5 tonnes mgw and over',
		                      'Goods over 3.5t. and under 7.5t',
							  'Van / Goods 3.5 tonnes mgw or under') THEN 'Van' 
		else 'other'
	end as vehicle_group,
	SUM(number_of_casualties) CY_Casualties
from RoadAccident
--where year(accident_date) = '2022'
GROUP BY
	case
		when vehicle_type IN ('agricultural vehicle') THEN 'Agricultural'
		when vehicle_type IN ('Car', 'Taxi/Private hire car') THEN 'Cars'
		when vehicle_type IN ('Motorcycle 125cc and under',
							  'Motorcycle 50cc and under',
							  'Motorcycle over 500cc',
							  'Motorcycle over 125cc and up to 500cc',
							  'Pedal cycle') THEN 'Bike'
		when vehicle_type IN ('Bus or coach (17 or more pass seats)', 'Minibus (8 - 16 passenger seats)') THEN 'Bus'
		when vehicle_type IN ('Goods 7.5 tonnes mgw and over',
		                      'Goods over 3.5t. and under 7.5t',
							  'Van / Goods 3.5 tonnes mgw or under') THEN 'Van' 
		else 'other'
	end





select distinct(vehicle_type)
from RoadAccident



select DATENAME(MONTH, accident_date) as Month_Name, sum(number_of_casualties) CY_Casualties
from RoadAccident
where year(accident_date) = '2022'
GROUP BY DATENAME(MONTH, accident_date)

select DATENAME(MONTH, accident_date) as Month_Name, sum(number_of_casualties) PY_Casualties
from RoadAccident
where year(accident_date) = '2021'
GROUP BY DATENAME(MONTH, accident_date)



select road_type, sum(number_of_casualties) CY_Casualties
from RoadAccident
where year(accident_date) = '2022'
group by road_type



select urban_or_rural_area, 
	   cast(sum(number_of_casualties) as decimal(10,2)) *100/
      (select cast(sum(number_of_casualties) as decimal(10,2))
	   from RoadAccident
	   where year(accident_date) = '2022') Casualties_urban_rural
from RoadAccident
where year(accident_date) = '2022'
group by urban_or_rural_area



select urban_or_rural_area, 
	   sum(number_of_casualties) Total_Casualties,
	   cast(sum(number_of_casualties) as decimal(10,2)) *100/
      (select cast(sum(number_of_casualties) as decimal(10,2)) Casualties_urban_rural
	   from RoadAccident)	    
from RoadAccident
--where year(accident_date) = '2022'
group by urban_or_rural_area


----------------------------------------------------------------------------

select distinct(light_conditions)
from RoadAccident

select
	case when light_conditions IN ('Daylight') then 'Light'
	     else 'Dark'
	end Light_condition,
	cast(sum(number_of_casualties) as decimal(10,2)) *100 / 
	(select cast(sum(number_of_casualties) as decimal(10,2))
	from RoadAccident
	where year(accident_date) = '2022')
	as CY_Casualties_PCT
from RoadAccident
where year(accident_date) = '2022'
group by
	case when light_conditions IN ('Daylight') then 'Light'
	     else 'Dark'
	end



----------------------------------------------------------------------------

select TOP 10 local_authority, sum(number_of_casualties) Total_casualties
from RoadAccident
group by local_authority
order by 2 desc
