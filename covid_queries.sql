-- DEATHS
select *
from coviddeaths
where continent is not null
order by 3, 4;

select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
where continent is not null
order by 1, 2;

-- total cases vs total deaths
-- likelihood of dying in a country
select location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 as deathpercent
from coviddeaths
where location like '%Ukraine%'
order by date;

-- percentage of population that got covid
select location, date, total_cases, population, (total_cases / population) * 100 as infectedpercent
from coviddeaths
where location like '%Ukraine%'
order by date;

-- countries with the highest infected population percentage
select location, population, max(total_cases), max((total_cases / population)) * 100 as infectedpercent
from coviddeaths
group by location, population
order by max((total_cases / population)) * 100 desc;

-- countries with the highest population deaths
select location, max(cast(total_deaths as int)) as totaldeaths
from coviddeaths
where continent is not null
group by location
having max(cast(total_deaths as int)) is not null
order by max(cast(total_deaths as int)) desc;

-- by continents
select continent, max(cast(total_deaths as int)) as totaldeaths
from coviddeaths
where continent is not null
group by continent
having max(cast(total_deaths as int)) is not null
order by max(cast(total_deaths as int)) desc;


-- global numbers
select date,
       sum(new_cases)                                          as totalcases,
       sum(cast(new_deaths as numeric))                        as totaldeaths,
       sum(cast(new_deaths as numeric)) / sum(new_cases) * 100 as deathpercantage
from coviddeaths
where continent is not null
group by date
order by sum(cast(new_deaths as numeric)) / sum(new_cases) * 100 desc;


-- VACCINATIONS PERCENTAGE

select *
from covidvaccinations
where continent is not null
order by 3, 4;

with popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
         as
         (select dea.continent,
                 dea.location,
                 dea.date,
                 dea.population,
                 vac.new_vaccinations,
                 sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date)
                     as rollingpeoplevaccinated
          from coviddeaths dea
                   join covidvaccinations vac
                        on dea.location = vac.location and dea.date = vac.date
          where dea.continent is not null
          order by 2, 3)
select *, (rollingpeoplevaccinated / population) * 100 as percent_vaccinated
from popvsvac;


-- crate view for future visualizations
create view percent_population_vaccinated as
select dea.continent,
       dea.location,
       dea.date,
       dea.population,
       vac.new_vaccinations,
       sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date)
           as rollingpeoplevaccinated
from coviddeaths dea
         join covidvaccinations vac
              on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null

select * from percent_population_vaccinated;