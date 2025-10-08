select *
from CovidDeaths_update
where continent is not null
order by 3, 4


select 
  location,
  date,
  total_cases,
  new_cases,
  total_deaths,
  population
from CovidDeaths_update
where continent is not null
order by 1, 2;

--Looking at Total Cases vs Total Deaths
--Show likelihood of dying if you contract covid in you country
SELECT 
  location,
  date,
  new_cases,
  total_cases,
  total_deaths,
  (CAST(total_deaths AS FLOAT) / NULLIF(CAST(total_cases AS FLOAT), 0)) * 100 AS DeathsPercentage
FROM CovidDeaths_update
WHERE location like '%viet%' and continent is not null
ORDER BY 1, 2;

--Looking at Total Cases vs Population
--Show what percentage of population got Covid
SELECT 
  location,
  date,
  total_cases,
  population,
  (CAST(total_cases AS FLOAT) / Cast(population as float))*100 as PercentPopulation
FROM CovidDeaths_update
--WHERE location like '%viet%'
ORDER BY 1, 2;


--Looking at Countries with Highest Infection Rate compared to Population

SELECT 
  location,
  population,
  MAX(total_cases) as HighestInfectionCount,  
  MAX((CAST(total_cases AS FLOAT) / Cast(population as float)))*100 as PercentPopulationInfected
FROM CovidDeaths_update
GROUP BY location, population
ORDER BY PercentPopulationInfected


--Showing Countries with Highest Death Count per Population
SELECT 
  location,
  MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths_update
where continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc


-- LET'S BREAK THINGS DOWN BY CONTINENT

-- Showing continents with the highest death count per population

SELECT 
  continent,
  MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths_update
where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

--GLOBAL NUMBER
SELECT 
  --date,
  SUM((NULLIF(new_cases, 0))) as TotalNewCases,
  SUM(new_deaths) as TotalNewDeaths,
  (SUM(Cast(new_deaths as float)) / SUM(NULLIF(CAST(new_cases as float), 0)))*100 as DeathPercentage
FROM CovidDeaths_update
WHERE continent is not null
--GROUP BY date
ORDER BY 1, 2;




-- Looking at Total Population vs Vaccinations
select  dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) RollingPeopleVaccinated
		
from CovidDeaths_update dea
join CovidVaccinations_update vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--and vac.new_vaccinations is not null
order by 2, 3


--USE CTE
with PopvsVac ( Continent, location, date, population, new_vaccination, RollingPeopleVaccinated)
as (
select  dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) RollingPeopleVaccinated
		
from CovidDeaths_update dea
join CovidVaccinations_update vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--and vac.new_vaccinations is not null
--order by 2, 3
)
select *, (NULLIF(Cast(RollingPeopleVaccinated as float), 0)/population)*100
from PopvsVac


--TEPM TABLE
Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
	(
	continent nvarchar(255),
	location nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
	)
insert into #PercentPopulationVaccinated
select  dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) RollingPeopleVaccinated
from CovidDeaths_update dea
join CovidVaccinations_update vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2, 3

select *, (NULLIF(Cast(RollingPeopleVaccinated as float), 0)/population)*100
from #PercentPopulationVaccinated


--Creating View to store data for later visualizations
Create view PercentPopulationVaccinated as
select  dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) RollingPeopleVaccinated		
from CovidDeaths_update dea
join CovidVaccinations_update vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2, 3



select *
from PercentPopulationVaccinated