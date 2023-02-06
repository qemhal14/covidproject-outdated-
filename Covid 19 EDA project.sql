SELECT * 
FROM [SQL Portofolio].dbo.CovidDeaths
ORDER BY 3,4

SELECT * 
FROM [SQL Portofolio].dbo.CovidVaccinations
ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM [SQL Portofolio].dbo.CovidDeaths
ORDER BY 1,2

-- Total Cases VS Total Deaths
-- Death Percentage from Covid-19 cases in Indonesia

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 DeathPercentage
FROM [SQL Portofolio].dbo.CovidDeaths
WHERE location = 'Indonesia'
ORDER BY 1,2

-- Total Cases VS Population
-- Covid-19 Cases Percentage in Indonesia

SELECT Location, date, total_cases, population, (total_cases/population)*100 CasesPercentage
FROM [SQL Portofolio].dbo.CovidDeaths
WHERE location = 'Indonesia'
ORDER BY 1,2

-- Highest Infection Rate per Country Compared to Population

SELECT Location, population,  MAX(total_cases) HighestInfectionCount, MAX((total_cases/population))*100 CasesPercentage
FROM [SQL Portofolio].dbo.CovidDeaths
--WHERE location = 'Indonesia'
GROUP BY Location, population
ORDER BY CasesPercentage DESC

-- Countries with the Highest Death Count per Population

SELECT Location, MAX(CAST(total_deaths AS int)) TotalDeathCount
FROM [SQL Portofolio].dbo.CovidDeaths
--WHERE location = 'Indonesia'
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount DESC

-- By Continent

SELECT location, MAX(CAST(total_deaths AS int)) TotalDeathCount
FROM [SQL Portofolio].dbo.CovidDeaths
--WHERE location = 'Indonesia'
WHERE continent is null
and location not in ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Global Numbers

SELECT SUM(new_cases) total_cases, SUM(CAST(new_deaths AS int)) total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 DeathPercentage
FROM [SQL Portofolio].dbo.CovidDeaths
--WHERE location = 'Indonesia'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2

-- Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition By dea.location Order By dea.location, 
dea.Date) Vaccinated
FROM [SQL Portofolio].dbo.CovidDeaths dea
JOIN [SQL Portofolio].dbo.CovidVaccinations vac
    ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

-- Using CTE to perform calculation on Partition in previous query

WITH PopvsVac (continent, location, date, population, new_vaccinations, vaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition By dea.location Order By dea.location, 
dea.Date) Vaccinated
FROM [SQL Portofolio].dbo.CovidDeaths dea
JOIN [SQL Portofolio].dbo.CovidVaccinations vac
    ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *, (vaccinated/population)*100
FROM PopvsVac

-- Using Temp Table

DROP TABLE if exists #Percentpopulationvaccinated
CREATE TABLE #Percentpopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
Vaccinated numeric
)

INSERT INTO #Percentpopulationvaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition By dea.location Order By dea.location, 
dea.Date) Vaccinated
FROM [SQL Portofolio].dbo.CovidDeaths dea
JOIN [SQL Portofolio].dbo.CovidVaccinations vac
    ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *, (vaccinated/population)*100
FROM #Percentpopulationvaccinated

-- For later visualizations

CREATE VIEW Percentpopulationvaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition By dea.location Order By dea.location, 
dea.Date) Vaccinated
FROM [SQL Portofolio].dbo.CovidDeaths dea
JOIN [SQL Portofolio].dbo.CovidVaccinations vac
    ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *
FROM Percentpopulationvaccinated
