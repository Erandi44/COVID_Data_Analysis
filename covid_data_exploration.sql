/*
Covid 19 Data Exploration 
Skills used: Converting Data Types, Filtering, Sorting, Joins, Temp Tables, Aggregate Functions, Creating Views

*/


#Extract data 
SELECT 
  location, date, total_cases, new_cases, total_deaths, population
FROM alert-condition-351514.covid.covid_deaths
WHERE continent is not NULL
ORDER BY 1,2;


# Total cases vs Total Deaths
# Shows likelihood of dying if you have contracted covid based on the country

SELECT 
  location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM `alert-condition-351514.covid.covid_deaths` 
WHERE continent is not NULL
ORDER BY 1,2;


# Explote Total cases vs Pupulation
# Shows what percentage contracted covid
SELECT 
  location, date, total_cases, population, (total_cases/population)*100 AS percent_population_infected
FROM `alert-condition-351514.covid.covid_deaths` 
WHERE continent is not NULL
ORDER BY 1,2;


# Countries with highest infection rate per population
SELECT 
location, population,MAX(total_cases) AS highest_infection_count, MAX(total_cases/population)*100 AS higest_percent_population_infected
FROM `alert-condition-351514.covid.covid_deaths` 
WHERE continent is not NULL
GROUP BY 1,2
ORDER BY 4 DESC;



# Highest death count by country
SELECT 
  location, MAX(cast(total_deaths as int)) AS total_death_count
FROM alert-condition-351514.covid.covid_deaths
WHERE continent is not NULL
GROUP BY location
ORDER BY 2 DESC;*/


# Highest death count per day by continent
SELECT 
  location, MAX(cast(total_deaths as int)) AS total_death_count
FROM alert-condition-351514.covid.covid_deaths
WHERE continent is NULL 
  AND location !='World' 
  AND location !='International' 
  AND location !='Low income' 
  AND location !='Lower middle income' 
  AND location !='Upper middle income' 
  AND location !='High income' 
GROUP BY location
ORDER BY total_death_count DESC;



# Highest infection cases per day by continenet
SELECT 
  location, MAX(cast(total_cases as int)) AS total_infections
FROM alert-condition-351514.covid.covid_deaths
WHERE continent is NULL 
  AND location !='World' 
  AND location !='International' 
  AND location !='Low income' 
  AND location !='Lower middle income' 
  AND location !='Upper middle income' 
  AND location !='High income'
GROUP BY location
ORDER BY total_infections DESC;



# Global death percentage by date
SELECT 
date,SUM(new_cases) AS TotalCases, SUM(cast(new_deaths as int)) AS TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases) *100 AS DeathPercentage
FROM `alert-condition-351514.covid.covid_deaths` 
WHERE continent is not NULL
GROUP BY date
ORDER BY 1,2 DESC


# Overall global death percentage
SELECT 
SUM(new_cases) AS TotalCases, SUM(cast(new_deaths as int)) AS TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases) *100 AS DeathPercentage
FROM `alert-condition-351514.covid.covid_deaths` 
WHERE continent is not NULL
ORDER BY 1,2 DESC



#Looking at total population vs vaccination
WITH Pop_vs_Vacc AS (
SELECT  
 death.continent, death.location, death.date, death.population, vacc.new_vaccinations, SUM(CAST(vacc.new_vaccinations AS int)) OVER (PARTITION BY death.location 
 ORDER BY death.location,death.date) AS RollingVaccinationTotal
FROM alert-condition-351514.covid.covid_deaths AS death 
JOIN alert-condition-351514.covid.covid_vaccinations  AS vacc
  ON death.location = vacc.location 
  AND death.date = vacc.date
WHERE death.continent is not NULL
--ORDER BY 2,3
)
SELECT 
  *, (RollingVaccinationTotal/population)*100 AS Percent_Population_Vaccinated
FROM Pop_vs_Vacc
*/


 # Creating view to store data for later visulization 
CREATE View covid.Pop_vs_Vacc AS 
SELECT  
 death.continent, death.location, death.date, death.population, vacc.new_vaccinations, SUM(CAST(vacc.new_vaccinations AS int)) OVER (PARTITION BY death.location 
 ORDER BY death.location,death.date) AS RollingVaccinationTotal
FROM alert-condition-351514.covid.covid_deaths AS death 
JOIN alert-condition-351514.covid.covid_vaccinations  AS vacc
  ON death.location = vacc.location 
  AND death.date = vacc.date
WHERE death.continent is not NULL

