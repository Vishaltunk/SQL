-- Selecting the data that we are going to be using. 
-- Acquired the Data from World Govt site about the Covid impact on the World. 


select location, date, total_cases, new_cases, total_deaths, population
from [Portfolio Project].. Covid_deaths	 
order by 1,2


-- Looking at Total Cases vs Total Deaths
-- Likelihood of dying with Covid in the Country
select location, date, total_cases, total_deaths, (Convert(float,total_deaths)/NULLIF(Convert(float,total_cases),0))*100 as DeathPercentage
from [Portfolio Project].. Covid_deaths	 
where location like '%India'
order by 1,2

-- Looking at the total Cases VS the Population
select location, date,Population, total_cases, (total_cases/population)*100 as CasePercentage
from [Portfolio Project].. Covid_deaths	 
where location like 'India'
order by 1,2

--Countries has the highest infection rate compared to population
select location, Population, MAX(total_cases)as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from [Portfolio Project].. Covid_deaths	 
--where location like 'India'
group by location, population
order by PercentPopulationInfected DESC

--Countries with the highest Death count per population
select location, MAX(cast(total_deaths as int))as HighestDeathCount 
from [Portfolio Project].. Covid_deaths	 
--where location like 'India'
where continent is not null
group by location
order by HighestDeathCount DESC

-- BREAKING DOWN BY CONTINENT
--Showing the Continent with the highest death count

select continent, MAX(cast(total_deaths as int))as TotalDeathCount 
from [Portfolio Project].. Covid_deaths	 
where continent is not null
group by continent
order by TotalDeathCount DESC



select  SUM(cast(total_deaths as int))as TotalDeath, SUM(new_cases) as totalcases, 
sum(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercent
from [Portfolio Project].. Covid_deaths	 
where continent is not null
group by continent
order by deathpercent DESC


--Total population VS vaccinations
Select cd.continent, cd.location,cd.date, cd.population, ca.new_vaccinations, 
SUM(CAst(ca.new_vaccinations as bigint)) over (partition by cd.location order by cd.location, 
cd.date) as RollingPeopleVaccinated
from [Portfolio Project]..Covid_deaths cd
Join [Portfolio Project]..Covid_vaccinations ca
on cd.location = ca.location
and cd.date = ca.date
where cd.continent is not null
order by 2,3


-- USE CTE 


with PopvsVac (Continent, location, Date, Population, New_vaccinations, RollingPeopleVaccinated) 
as 
(
Select cd.continent, cd.location,cd.date, cd.population, ca.new_vaccinations, 
SUM(CAst(ca.new_vaccinations as bigint)) over (partition by cd.location order by cd.location, 
cd.date) as RollingPeopleVaccinated
from [Portfolio Project]..Covid_deaths cd
Join [Portfolio Project]..Covid_vaccinations ca
on cd.location = ca.location
and cd.date = ca.date
where cd.continent is not null
--order by 2,3
)
select *
from PopvsVac

-- Percentage of People Vaccinated in entire population 

with PopvsVac (Continent, location, Date, Population, New_vaccinations, RollingPeopleVaccinated) 
as 
(
Select cd.continent, cd.location,cd.date, cd.population, ca.new_vaccinations, 
SUM(CAst(ca.new_vaccinations as bigint)) over (partition by cd.location order by cd.location, 
cd.date) as RollingPeopleVaccinated
from [Portfolio Project]..Covid_deaths cd
Join [Portfolio Project]..Covid_vaccinations ca
on cd.location = ca.location
and cd.date = ca.date
where cd.continent is not null and cd.location like 'India'
--order by 2,3
)
select *, (RollingPeopleVaccinated/Population)*100 as VaccinatedPercent
from PopvsVac

-- Creating Temp Table
Drop Table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinatio numeric, 
RollingPeopleVaccinated numeric, 
)
Insert into #PercentPopulationVaccinated

Select cd.continent, cd.location,cd.date, cd.population, ca.new_vaccinations, 
SUM(CAst(ca.new_vaccinations as bigint)) over (partition by cd.location order by cd.location, 
cd.date) as RollingPeopleVaccinated
from [Portfolio Project]..Covid_deaths cd
Join [Portfolio Project]..Covid_vaccinations ca
on cd.location = ca.location
and cd.date = ca.date
where cd.continent is not null and cd.location like 'India'
--order by 2,3
select *, (RollingPeopleVaccinated/Population)*100 as VaccinatedPercent
from #PercentPopulationVaccinated

-- Creating View to store data for visualiztions

create view percentpopulationvaccinated as 
Select cd.continent, cd.location,cd.date, cd.population, ca.new_vaccinations, 
SUM(CAst(ca.new_vaccinations as bigint)) over (partition by cd.location order by cd.location, 
cd.date) as RollingPeopleVaccinated
from [Portfolio Project]..Covid_deaths cd
Join [Portfolio Project]..Covid_vaccinations ca
on cd.location = ca.location
and cd.date = ca.date
where cd.continent is not null and cd.location like 'India'
--order by 2,3

-- View to display highest number of deaths in one year (2022)
create view Deathsin2022 as 
select cd.location, SUM(cast(total_deaths as bigint))as TotalDeath
from [Portfolio Project]..Covid_deaths cd
Join [Portfolio Project]..Covid_vaccinations ca
on cd.location = ca.location
and cd.date = ca.date
where cd.date between '2022-01-01' and '2022-12-31'  and cd.continent is not null
group by cd.location

select *
from Deathsin2022 
order by TotalDeath DESC