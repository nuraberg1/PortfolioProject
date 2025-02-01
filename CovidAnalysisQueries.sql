SELECT *
FROM `portfolioproject-449608.CovidDeaths.CovidDeaths` 
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM `portfolioproject-449608.CovidDeaths.CovidVaccinations`
--ORDER BY 3,4


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM `portfolioproject-449608.CovidDeaths.CovidDeaths` 
ORDER BY 1,2

--Looking at total cases vs total deaths
--Shows the likelihood of dying if you contract Covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM `portfolioproject-449608.CovidDeaths.CovidDeaths` 
WHERE Location like '%Kazakhstan%'
ORDER BY 1,2

--Looking at the total cases vs population
--Shows what percentage of population got covid

SELECT Location, date, total_cases, Population, (total_cases/population)*100 as PercentofPopulationInfected
FROM `portfolioproject-449608.CovidDeaths.CovidDeaths` 
--WHERE Location like '%Kazakhstan%'
ORDER BY 1,2

--Looking at the countries with highest infection rate compared to population

SELECT Location, MAX(total_cases) AS HighestInfectionCount, Population, MAX((total_cases/population))*100 as PercentofPopulationInfected
FROM `portfolioproject-449608.CovidDeaths.CovidDeaths` 
--WHERE Location like '%Kazakhstan%'
GROUP BY Location, Population
ORDER BY PercentofPopulationInfected DESC

--Showing the countries witht the highest death count per population

SELECT Location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM `portfolioproject-449608.CovidDeaths.CovidDeaths` 
--WHERE Location like '%Kazakhstan%'
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount DESC

--Showing the continents with the highest death count

SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM `portfolioproject-449608.CovidDeaths.CovidDeaths` 
--WHERE Location like '%Kazakhstan%'
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC

--Global numbers

SELECT date, SUM(new_cases) as total_new_cases, SUM(new_deaths) as total_new_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercent
FROM `portfolioproject-449608.CovidDeaths.CovidDeaths` 
--WHERE Location like '%Kazakhstan%'
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

SELECT SUM(new_cases) as total_new_cases, SUM(new_deaths) as total_new_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercent
FROM `portfolioproject-449608.CovidDeaths.CovidDeaths` 
--WHERE Location like '%Kazakhstan%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2

--Looking at total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated,--, (RollingPeopleVaccinated/population)*100
FROM `portfolioproject-449608.CovidDeaths.CovidDeaths` AS dea
JOIN `portfolioproject-449608.CovidDeaths.CovidVaccinations` AS vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

--USE CTE

WITH PopvsVac AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated,--, (RollingPeopleVaccinated/population)*100
FROM `portfolioproject-449608.CovidDeaths.CovidDeaths` AS dea
JOIN `portfolioproject-449608.CovidDeaths.CovidVaccinations` AS vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *,(RollingPeopleVaccinated/Population)*100
FROM PopvsVac

--TEMP TABLE

CREATE TABLE PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated,--, (RollingPeopleVaccinated/population)*100
FROM `portfolioproject-449608.CovidDeaths.CovidDeaths` AS dea
JOIN `portfolioproject-449608.CovidDeaths.CovidVaccinations` AS vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE dea.continent is not null;
--ORDER BY 2,3

SELECT *,(RollingPeopleVaccinated/Population)*100
FROM PercentPopulationVaccinated

--CREATING VIEW TO STORE DATA FOR VISUALIZATIONS

CREATE VIEW `portfolioproject-449608.CovidDeaths.PercentPopulationVaccinated` AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.date) AS RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100
FROM `portfolioproject-449608.CovidDeaths.CovidDeaths` AS dea
JOIN `portfolioproject-449608.CovidDeaths.CovidVaccinations` AS vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE dea.continent is not null;
--ORDER BY 2,3
