
SELECT * FROM 
PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

SELECT * FROM 
PortfolioProject..CovidVaccinations
order by 3,4

--Changed the datatype to FLOAT to perform divide operation

ALTER TABLE PortfolioProject..CovidDeaths
ALTER COLUMN total_cases FLOAT;

ALTER TABLE PortfolioProject..CovidDeaths
ALTER COLUMN total_deaths FLOAT;

--STATES DEATHRATIO PERCENTAGE

SELECT LOCATION, DATE, TOTAL_CASES, TOTAL_DEATHS, (total_deaths/total_cases)*100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths
where location like '%INDIA%'
order by 1,2

-- TOTAL CASES VS POPULATION
SELECT LOCATION, DATE, TOTAL_CASES, POPULATION, (total_cases/POPULATION)*100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths
where location like '%INDIA%'
order by 1,2

-- Countries with highest infection rate vs population

SELECT LOCATION, POPULATION, max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as InfectedPopulation
FROM PortfolioProject..CovidDeaths
group by LOCATION, POPULATION 
order by InfectedPopulation desc


--HighestDeathCount per population

SELECT location, max(cast(total_deaths as int)) as HighestDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
group by LOCATION
order by HighestDeathCount desc


-- based on continent HighestDeathCount

SELECT continent, max(cast(total_deaths as int)) as HighestDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by HighestDeathCount desc


-- Global numbers
-- Use aggregate function 
SELECT sum(new_cases), sum(CAST(new_deaths as int)) AS 
TOTAL_DEATHS, SUM(CAST(NEW_DEATHS AS INT)) / SUM(CAST(NEW_DEATHS AS INT))/ SUM(NEW_CASES) * 100 AS DEATHPERCENTAGE
FROM PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2


-- VACCINATION TABLE

-- Total population vs Vaccinations
-- JOIN tables

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--group by date
order by 2,3


-- USING PARTITION BY

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, sum(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) 
as RollingVaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--group by date
order by 2,3


-- USE CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingVaccinations)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, sum(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) 
as RollingVaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--group by date
--order by 2,3
)
select * , (RollingVaccinations/Population) * 100
from PopvsVac


-- TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingVaccinations numeric
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, sum(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) 
as RollingVaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select * , (RollingVaccinations/Population) * 100
from #PercentPopulationVaccinated



-- Create Views to store data for visualization

Create view PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, sum(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) 
as RollingVaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


Create view HighestDeathCount as
SELECT location, max(cast(total_deaths as int)) as HighestDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
group by LOCATION


