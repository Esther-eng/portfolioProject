-----This query shows the industries with the highest carbon foot print in the most recent year
SELECT industry_group,
	COUNT(DISTINCT company) AS num_companies,
	SUM(carbon_footprint_pcf) AS total_industry_footprint, 
	year
FROM carbonEmissionIndustry
WHERE year IN (
	SELECT MAX(year)
	FROM carbonEmissionIndustry)
	GROUP BY industry_group, year
	ORDER BY total_industry_footprint DESC;


----This query is to determine which industries or companies contribute most to emissions.
SELECT industry_group, 
    company, 
    SUM(carbon_footprint_pcf) AS total_pcf
FROM carbonEmissionIndustry
GROUP BY industry_group, company
ORDER BY total_pcf DESC;


---To evaluate emissions at upstream, operations, and downstream stages to determine where mitigation efforts should focus
SELECT 
    product_name,
    AVG(upstream_percent_total_pcf::NUMERIC) AS avg_upstream,
    AVG(operations_percent_total_pcf::NUMERIC) AS avg_operations,
    AVG(downstream_percent_total_pcf::NUMERIC) AS avg_downstream
FROM carbonEmissionIndustry
GROUP BY product_name
ORDER BY avg_upstream DESC;



---To Identify countries leading in low-carbon products.
SELECT 
   country, 
    AVG(carbon_footprint_pcf) AS avg_pcf
FROM 
   carbonEmissionIndustry
GROUP BY 
    country
ORDER BY avg_pcf ASC;


---To determine the product weight with its carbon footprint to identify if heavier products consistently have higher emissions.
SELECT 
    weight_kg, 
    carbon_footprint_pcf
FROM 
    carbonEmissionIndustry
	Order by carbon_footprint_pcf Desc;

	---Shows the companies with carbon footprint less than the overall average footprint
SELECT DISTINCT product_name,
	company,
	carbon_footprint_pcf
  FROM carbonEmissionIndustry
  WHERE carbon_footprint_pcf < 
  (SELECT 
	AVG(carbon_footprint_pcf) AS avg_carbon_footprint
	FROM carbonEmissionIndustry
	)
	order by carbon_footprint_pcf DESC
