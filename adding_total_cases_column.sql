UPDATE `portfolioproject-449608.CovidDeaths.CovidDeaths`
SET total_cases = CAST(total_cases_per_million * population/1000000 AS INT64)
WHERE total_cases IS NULL;
