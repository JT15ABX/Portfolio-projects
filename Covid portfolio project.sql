#Portfolio case study #1 Covid 19 data exploration 
CREATE database Portfolio 
USE Portfolio

SELECT * FROM Covid_deaths
AS
WHERE continent is not null 
ORDER BY 3,4

#Select relevent data 
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2

#Looking at Total cases vs Total deaths 
#Shows Liklihood of dying in Europe if you get covid 
SELECT location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 AS Deathpercent
FROM Covid_deaths
WHERE location = 'Europe' 
and continent IS NOT NULL
ORDER BY 1,2

#Looking at Total Cases Vs Population 
#Shows what percent of the population got covid 
SELECT location, date, total_cases, Population, (total_cases/Population)*100 AS PercentPopulationInfected
FROM Covid_deaths
WHERE location = 'Europe'
ORDER BY 1,2

# Looking at the countries with the Highest infection rate compared to population 
SELECT location, MAX( total_cases) AS 'HighestInfectionCount', Population, MAX((total_cases/Population))*100 AS 'PercentPopulationInfected'
FROM Covid_deaths
#WHERE location = 'Europe'
GROUP BY location, Population
ORDER BY PercentPopulationInfected desc

# Showing countries with the highest death count per population 
#Need to change deaths datatype as not varchar

SELECT location, MAX(CAST(total_deaths AS DECIMAL) ) AS 'TotalDeathCount'
FROM Covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount desc;

# Broken down by continent 
# Showing contintents with the highest death count per population

SELECT location,  MAX(CAST(total_deaths AS DECIMAL)) AS 'TotalDeathCount'
FROM covid_deaths
WHERE continent is not null 
GROUP BY continent
ORDER BY TotalDeathCount desc

#Total death count
SELECT SUM(total_deaths)
FROM covid_deaths;


# Global numbers with dates 

SELECT date, 
total_cases, SUM(new_cases) AS Total_cases, SUM(CAST(new_deaths AS DECIMAL)) AS Total_deaths, 
SUM(CAST(new_deaths AS DECIMAL)) /SUM(new_cases)*100 AS Deathpercent
FROM Covid_deaths
WHERE continent is not null
GROUP BY date 
ORDER BY 1,2

#Global numbers without dates 
SELECT 
 SUM(new_cases) AS Total_cases, SUM(CAST(new_deaths AS DECIMAL)) AS Total_deaths, 
SUM(CAST(new_deaths AS DECIMAL)) /SUM(new_cases)*100 AS Deathpercent
FROM Covid_deaths
WHERE continent is not null
ORDER BY 1,2

#Join both tables [deaths and vaccines]  
SELECT *
FROM covid_deaths dea
LEFT JOIN covid_vaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
;

# CREATE VIEWS TO STORE DATA FOR VISUALISATIONS 

CREATE VIEW PercentPopulationVaccinated as

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS decimal)) 
OVER (partition by dea.location ORDER BY dea.location, dea.date) 
AS Rolling_people_vaccinated
#(Rolling_people_vaccinated/population)*100
FROM covid_deaths dea
 JOIN covid_vaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
#ORDER BY 2,3percentpopulationvaccinatedpercentpopulationvaccinated

SELECT *
FROM percentpopulationvaccinated;