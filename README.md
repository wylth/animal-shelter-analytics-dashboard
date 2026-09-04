# Animal Shelter Analytics Dashboard

A full stack web application for exploring and analysing animal shelter outcome data using Node.js, Express.js, MySQL, and Mustache.

The application uses the Austin Animal Center Outcomes dataset containing 170,000+ records and provides several views for exploring animal outcomes, adoption patterns, euthanasia records, and trends over time.

## Features

- **Outcome Statistics** — View outcome counts by outcome type and subtype
- **Top Adopted Breeds** — Identify the 10 most frequently adopted breeds
- **Euthanasia Analysis** — Explore euthanasia outcomes by sex
- **Monthly Outcomes** — Examine outcome volumes over time
- **Normalized Database** — Transform raw CSV data into a relational MySQL database

## Tech Stack

- **Backend:** Node.js, Express.js
- **Database:** MySQL
- **Frontend:** HTML, CSS, Mustache
- **Data:** SQL, CSV

## Database

The raw dataset is first loaded into a staging table and then transformed into a normalized relational structure consisting of:
Animal AnimalType Breed Color OutcomeClassification Outcome

The application uses SQL joins, filtering, grouping, aggregation, and sorting to generate the analytical results displayed in the web interface.

## Screenshots

(To be continued...)

## Dataset

This project uses the **Austin Animal Center Outcomes** dataset from the City of Austin Open Data Portal.

**Dataset:** [Austin Animal Center Outcomes (10/01/2013 to 05/05/2025)](https://data.austintexas.gov/Health-and-Community-Services/Austin-Animal-Center-Outcomes-10-01-2013-to-05-05-/9t4d-g238/about_data)

The full dataset used for this project is included in the repository.

## Project Context

Developed as part of my Computer Science studies, combining database design, SQL analysis, and web application development.
