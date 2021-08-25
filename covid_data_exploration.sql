-- run initial inspection of the dataset

SELECT *
FROM covid_deaths;

SELECT *
FROM covid_deaths
WHERE continent IS NULL;

SELECT *
FROM covid_vaccinations;

SELECT *
FROM covid_vaccinations
WHERE continent IS NULL;


-- inspect the total deaths by continent

SELECT location, SUM(new_deaths) AS 'total_deaths'
FROM covid_deaths
WHERE continent IS NULL AND ([location] != 'World' and [location] != 'International')
GROUP BY [location]
ORDER BY 2 desc;

-- inspect total world deaths over time

SELECT location, date, total_deaths
FROM covid_deaths
WHERE continent IS null and [location] = 'World'
ORDER by date;


-- check to see how the sum of new deaths compares to the maximum total deaths

SELECT location, sum(new_deaths) AS 'total_deaths'
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY [location]
ORDER BY 2 desc;

SELECT location, MAX(total_deaths) AS 'total_deaths'
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY MAX(total_deaths) desc;

SELECT *
FROM covid_deaths
WHERE location LIKE '%states%' AND continent IS NOT NULL;

-- look at the percentage of US population that was ICU patients

SELECT location, date, icu_patients, population, (icu_patients / population)*100 AS ICU_percentage
FROM covid_deaths
WHERE location LIKE '%states%' AND continent IS NOT NULL;

-- compare average percentage of population that was in ICU by country

SELECT location, AVG((icu_patients / population)*100) AS 'average_icu_percentage'
FROM covid_deaths
WHERE location IS NOT NULL
GROUP BY location
ORDER by AVG((icu_patients / population)*100) desc;

-- now compare max percentage of population that was in ICU by country

SELECT location, MAX((icu_patients / population)*100) AS 'average_icu_percentage'
FROM covid_deaths
WHERE location IS NOT NULL
GROUP BY location
ORDER by MAX((icu_patients / population)*100) desc;

-- look at max death percentage of population by country

SELECT location, MAX((total_deaths / population)*100) AS 'max_death_percentage'
FROM covid_deaths
WHERE location IS NOT NULL
GROUP by location
ORDER BY 2 desc;

-- join covid_deaths table with covid_vaccinations table for later calculations

SELECT cd.continent, cd.location, cd.date, population, total_cases, new_cases, total_deaths, new_deaths, total_vaccinations, new_vaccinations
INTO #deaths_vaccinations
FROM covid_deaths cd
  JOIN covid_vaccinations cv
  ON cd.continent = cv.continent AND cd.location = cv.location AND cd.date = cv.date;

-- check to make sure the temp table was created correctly

SELECT *
FROM #deaths_vaccinations;

-- explore the rolling average for new deaths and new vaccinations in the United States

WITH
  daily_covid_aggregates
  AS
  (
    SELECT continent,
      location,
      date,
      new_deaths,
      new_vaccinations,
      (new_deaths/population)*100 AS 'new_death_percentage',
      (new_vaccinations/population)*100 AS 'new_vaccination_percentage'
    FROM #deaths_vaccinations
  )
SELECT date,
  new_deaths,
  new_vaccinations,
  AVG(new_deaths) OVER (ORDER BY date ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS 'moving_new_deaths_average',
  AVG(new_vaccinations) OVER (ORDER BY date ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS 'moving_new_vaccinations_average'
FROM #deaths_vaccinations
WHERE [location] LIKE '%states%';