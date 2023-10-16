
-- CTE that identifies if there's a decline in life expectancy by comparing current year's LE from prior available year's LTE  

	with current_previous_metrics as (
       	select
			country,
        	year as current_year,
        	life_expectancy as current_expectancy,
        	case 
	        	when life_expectancy < lag(life_expectancy) over (partition by country order by year) 
	        		then 1 else 0 
	    	end as decline
        from life_expectancy
    ),
        
    
 -- CTE that filters the rows where a decline occurred (decline=1) and assigns a number (grp) to consecutive rows with a decline within each country.
 -- Note: The decline in this CTE does not account for continuity of decline 
        
   	t_decline as (
        select
        	country,
        	current_year,
        	current_expectancy,
        	row_number() over (partition by country, decline order by current_year) as grp
        from current_previous_metrics
        where decline = 1
   ),
        
        
        
  -- CTE that assigns a number (rnumber) to consecutive years within each country to identify lengthiest continuous period YoY    
    continuous_decline as (
        select 
        	country,
        	current_year,
        	current_expectancy,
        	row_number() over (partition by country, current_year - grp order by current_year) as rnumber
        from t_decline
        order by country, current_year
  )
        
  
  -- Final SELECT statement to determine the start and end year of the country with longest continuous decline

        select 
        	country,
        	current_year - max(rnumber) +1 as start_year,
        	current_year as end_year
        from continuous_decline
        where rnumber=(select max(rnumber) from continuous_decline)
       
        