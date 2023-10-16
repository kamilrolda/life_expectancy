---
title: Life Expectancy
---

_Life expectancy can be used to evaluate the health status of a population_

The following visualizations is derived from the data in [this site.](https://ourworldindata.org/life-expectancy)

## Top 10 Countries with the Highest Life Expectancy (All Time)

```sql top10_max
select 
  distinct entity as "Country Name", 
  max(life_expectancy) as "Highest Life Expectancy",
  --year
  from 'sources/life-expectancy.csv'
group by entity
order by max(life_expectancy) desc
limit 10
```

<DataTable data={top10_max} >
    
</DataTable>

```sql income_groups
select 
  entity as income_groups, 
  life_expectancy,
  year as Year
  from 'sources/life-expectancy.csv'
where entity in ('High-income countries','Low-income countries','Lower-middle-income countries', 'Middle-income countries','Upper-middle-income countries')
```

## Life Expectancy by Income Groups

<LineChart 
    data={income_groups} 
    x=Year 
    y=Life_Expectancy 
    series=income_groups
    yAxisTitle="Life Expectancy" 
    xAxisTitle="Year"
/>

A strong positive correlation exists between income levels and life expectancy, with individuals in higher income groups tending to experience longer and healthier lives. This correlation underscores the significant impact of socioeconomic disparities on health outcomes, highlighting the need for policies aimed at reducing income inequality to improve overall public health.


## Life Expectancy: Less Developed Regions vs More Developed Regions

```sql developed_regions
select 
  entity as category, 
  life_expectancy,
  year as Year
  from 'sources/life-expectancy.csv'
where entity in ('Less developed regions','More developed regions')
```

<LineChart 
    data={developed_regions} 
    x=Year 
    y=Life_Expectancy 
    series=category
    yAxisTitle="Life Expectancy" 
    xAxisTitle="Year"
/>

More developed countries generally exhibit a positive correlation with higher life expectancy, attributed to better healthcare systems, improved living conditions, and access to education. These factors contribute to longer life spans and emphasize the importance of development and healthcare infrastructure in enhancing overall population health.


## United States & Zambia Life Expectancy in comparison to the Average Life Expectancy 

```sql life_expectancy_US
select
    year,
    AVG(life_expectancy) AS average_life_expectancy,
    SUM(CASE WHEN entity = 'United States' THEN life_expectancy ELSE NULL END) AS united_states_life_expectancy,
    SUM(CASE WHEN entity = 'Zambia' THEN life_expectancy ELSE NULL END) AS zambia_life_expectancy
from 'sources/life-expectancy.csv'
where year >= 1950
group by year
order by year
```

<LineChart 
    data={life_expectancy_US} 
    x=Year
    y={["average_life_expectancy", "united_states_life_expectancy","zambia_life_expectancy"]}
    yAxisTitle="Life Expectancy" 
    xAxisTitle="Year"
/>

The United States has a higher life expectancy than the global average, while Zambia's life expectancy is below the global average. Here are some insights from this data:

<b>United States:</b> The United States consistently maintains a life expectancy above the global average. This could be attributed to factors such as access to quality healthcare, a strong economy, and an advanced healthcare system.
<br>
<b>Zambia:</b> Zambia, on the other hand, experiences a life expectancy below the global average. This might indicate various challenges, including limited access to healthcare, lower socioeconomic conditions, and higher disease burdens in the country.



