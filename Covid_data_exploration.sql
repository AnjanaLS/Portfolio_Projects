--Details of Covid deaths in Covid_data table

select * from DataAnalysis_project..Covid_data
where continent is not null
order by location,date

--Vaccination details in Vaccine_data table

select * from DataAnalysis_project..Vaccine_data
where continent is not null
order by location,date

--Listing details with location,total covid cases and deaths
select location,date,total_cases,new_cases,total_deaths,population
from DataAnalysis_project..Covid_data
where continent is not null
order by location,date 

 --Total cases reported in each location

 select location, max(total_cases) as total_covid_cases
 from DataAnalysis_project..Covid_data
 where continent is not null
 group by location
 order by total_covid_cases desc

 --Listing countries with no covid cases

select location, max(total_cases) as total_covid_cases
 from DataAnalysis_project..Covid_data
 GROUP BY location
 HAVING max(total_cases) is null 
 
 
 --Total cases vs population

select location,date,population,total_cases, (total_cases/population)*100 as covid_percentage
from DataAnalysis_project..Covid_data
where continent is not null
order by location,date

--Total cases vs total deaths


select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as death_percentage
from DataAnalysis_project..Covid_data
where continent is not null
order by location,date

--Listing countries with highest infection rate compared to population
 
 select location,population, max(total_cases) as HighestInfectionCount,(max(total_cases)/population)*100 as highest_infection_percentage
 from DataAnalysis_project..Covid_data
   where continent is not null 
group by location, population
order by highest_infection_percentage desc


--Listing countries with highest death rate per population

select location,population, (max(cast(total_deaths as int))/population)*100 as highest_death_rate 
from DataAnalysis_project..Covid_data
where continent is not null
group by location, population
order by highest_death_rate  desc

--Listing countries with highest death count per population

select location,population, max(cast(total_deaths as int)) as total_death_count
from DataAnalysis_project..Covid_data
where continent is not null
group by location, population
order by total_death_count  desc

--Showing continents with highest death count

select continent, max(cast(total_deaths as int)) as total_death_count
from DataAnalysis_project..Covid_data
where continent is not null
group by continent
order by total_death_count  desc

--Global count of Total covid cases, deaths

select max(total_cases) as total_covid_cases, max(cast(total_deaths as int)) as total_covid_deaths, (max(cast(total_deaths as int))/max(total_cases))*100 as DeathPercentage
from DataAnalysis_project..Covid_data
where continent is not null


-- Total Population vs Vaccinations
-- percentage of people got fully vaccinated

---------------------------
With PopvsVac (Location, Population, total_people_vaccinated)
as
(
select cdata.location, cdata.population, max(vdata.people_fully_vaccinated) as total_people_vaccinated
from DataAnalysis_project..Covid_data cdata 
Join DataAnalysis_project..Vaccine_data vdata
   on cdata.location=vdata.location  and
   cdata.date=vdata.date
where cdata.continent is not null
group by cdata.location,cdata.population
)
Select *, (total_people_vaccinated/Population)*100 as perc
From PopvsVac
order by location



-- Using Temp Table to perform calculation
--percentage of people got fully vaccinated

DROP Table if exists #PopulationVaccinatedPercent
Create Table #PopulationVaccinatedPercent
(
Location nvarchar(255),
Population numeric,
total_people_vaccinated numeric
)

Insert into #PopulationVaccinatedPercent
select cdata.location, cdata.population, max(vdata.people_fully_vaccinated) as total_people_vaccinated
from DataAnalysis_project..Covid_data cdata 
Join DataAnalysis_project..Vaccine_data vdata
   on cdata.location=vdata.location  and
   cdata.date=vdata.date
where cdata.continent is not null
group by cdata.location,cdata.population

Select *, (total_people_vaccinated/Population)*100 as perc
From #PopulationVaccinatedPercent
order by location


-- Creating View to store data 

Create View PopulationVaccinated as
select cdata.location, cdata.population, max(vdata.people_fully_vaccinated) as total_people_vaccinated
from DataAnalysis_project..Covid_data cdata 
Join DataAnalysis_project..Vaccine_data vdata
   on cdata.location=vdata.location  and
   cdata.date=vdata.date
where cdata.continent is not null
group by cdata.location,cdata.population

