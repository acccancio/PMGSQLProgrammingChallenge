#1
SELECT date, SUM(impressions) AS total_impressions
FROM marketing_performance
GROUP BY date;

#2
SELECT state, SUM(revenue) AS total_revenue
FROM website_revenue
GROUP BY state
ORDER BY SUM(revenue) DESC
LIMIT 3;

#3
SELECT campaign_info.name AS campaign_name, 
      SUM(marketing_performance.cost) AS total_cost, 
      SUM(marketing_performance.impressions) AS total_impressions, 
      SUM(marketing_performance.clicks) AS total_clicks, 
      SUM(website_revenue.revenue) AS total_revenue
FROM ((marketing_performance 
      INNER JOIN campaign_info ON campaign_info.id = marketing_performance.campaign_id) 
      INNER JOIN website_revenue ON marketing_performance.campaign_id = website_revenue.campaign_id)
GROUP BY campaign_info.name;

#4
SELECT REPLACE(geo,'United States-'," ") AS state, SUM(conversions) AS total_conversions
FROM marketing_performance INNER JOIN campaign_info ON campaign_info.id = marketing_performance.campaign_id
WHERE campaign_info.name = 'Campaign5'
GROUP BY geo
ORDER BY SUM(conversions) DESC;

'Answer: Georgia generated the highest conversions for Campaign 5 with a total of 672 conversions'

#5
SELECT campaign_info.name AS campaign_name, 
      SUM(marketing_performance.cost) AS total_cost, 
      SUM(marketing_performance.impressions) AS total_impressions, 
      SUM(marketing_performance.clicks) AS total_clicks, 
      SUM(marketing_performance.clicks)/SUM(marketing_performance.impressions) AS clickthough_rate, 
      SUM(marketing_performance.cost)/SUM(marketing_performance.clicks) AS cost_per_click, 
      SUM(marketing_performance.conversions) AS total_conversions, 
      SUM(marketing_performance.conversions)/SUM(marketing_performance.clicks)*100 AS conversion_rate, 
      SUM(marketing_performance.cost)/SUM(marketing_performance.conversions) AS cost_per_acquisition,   
      SUM(website_revenue.revenue) AS total_revenue, 
      SUM(website_revenue.revenue)/SUM(marketing_performance.cost)*100 AS ROAS
FROM ((marketing_performance 
      INNER JOIN campaign_info ON campaign_info.id = marketing_performance.campaign_id) 
      INNER JOIN website_revenue ON marketing_performance.campaign_id = website_revenue.campaign_id)
GROUP BY campaign_info.name;

'Answer: In terms of efficiency in generating revenue while maintaining low cost, Campaign 2 would be most efficient. Despite a relatively high CPC, the campaign succeeds in generating a high conversation rate of 30.67% and a low CPA of $0.44. It could be given that Campaign 3 may be arguably better in performance, but this could be mainly due to a high investment during its whole campaign duration, with a much lower ROAS.'

#BONUS

SELECT
    day_of_week,
    AVG(total_impressions) AS total_impressions,
    AVG(total_clicks) AS total_clicks,
    AVG(total_clicks) / AVG(total_impressions) AS clickthrough_rate
FROM (
    SELECT
        CASE
            WHEN WEEKDAY(date) = 0 THEN 'Sunday'
            WHEN WEEKDAY(date) = 1 THEN 'Monday'
            WHEN WEEKDAY(date) = 2 THEN 'Tuesday'
            WHEN WEEKDAY(date) = 3 THEN 'Wednesday'
            WHEN WEEKDAY(date) = 4 THEN 'Thursday'
            WHEN WEEKDAY(date) = 5 THEN 'Friday'
            WHEN WEEKDAY(date) = 6 THEN 'Saturday'
        END AS day_of_week,
        AVG(impressions) AS total_impressions,
        AVG(clicks) AS total_clicks
    FROM
        marketing_performance
    GROUP BY
        day_of_week
) AS subquery
GROUP BY
    day_of_week
ORDER BY
    day_of_week;

'Answer: If the objective is to drive awareness and engagement in running ads, Friday would be the most appropriate day of the week for this execution. Additionally, impressions and clicks are second highest on Saturdays compared to other days, with a relatively high CTR of 83%.'
