SELECT

Location, date, total_cases, new_cases, total_deaths, population
FROM
CovidDeaths
Order by 1,2

---TotalCovid cases VS TotalDeaths
--- Risk percentage of one dying if covid is contracted

SELECT
Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM
CovidDeaths
Where Location =  'South Africa'
Order by 1,2

---Total cases vs population---
--percentage of population with covid

SELECT
Location, date, population, total_cases, (total_cases/population)*100 AS InfectedPeoplePop
FROM
CovidDeaths
Where Location like  'South Africa'
Order by 1,2

---Countries with Highest Infection rate compared to population

SELECT
Location, population, MAX(total_cases) AS HighestInfectionCount, Max((total_cases/population)*100) AS InfectedPeoplePercentage
FROM
CovidDeaths
Group By Location, Population
Order by InfectedPeoplePercentage desc


--showing countries with highest death count per population


SELECT
Location,  MAX(cast(Total_deaths AS int)) AS TotalDeathCount
FROM
CovidDeaths
where continent is not NULL
GROUP BY location
Order By TotalDeathCount desc;


----TotalDeaths by Continent
SELECT
location,  MAX(cast(Total_deaths AS int)) AS TotalDeathCount
FROM
CovidDeaths
where continent is NULL
GROUP BY location
Order By TotalDeathCount desc;

--GlobalNumbers---


Select date, SUM(new_cases), SUM(Cast(new_deaths As int)) ,   SUM(Cast(new_deaths AS float))/ Sum(New_cases)* 100 As DeathPercentage
From CovidDeaths
Group by date
Order by 1,2

--TotalPopulation VS Vaccinations 

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(Cast(vac.new_vaccinations as float)) OVER (Partition by dea.Location Order by dea.location, dea.Date) AS RollingPeoplevaccinated
FROM
CovidDeaths Dea
JOIN CovidVaccinations Vac 
	ON Dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3


---Using CTE

With CTE_PopVsVac AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(Cast(vac.new_vaccinations as float)) OVER (Partition by dea.Location Order by dea.location, dea.Date) AS RollingPeoplevaccinated
FROM
CovidDeaths Dea
JOIN CovidVaccinations Vac 
	ON Dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null

)

Select *, (RollingPeoplevaccinated/Population)*100
FROM
CTE_PopVsVac


---using views-----
Create View PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(Cast(vac.new_vaccinations as float)) OVER (Partition by dea.Location Order by dea.location, dea.Date) AS RollingPeoplevaccinated
FROM
CovidDeaths Dea
JOIN CovidVaccinations Vac 
	ON Dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null


