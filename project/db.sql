DROP DATABASE IF EXISTS austin_animals;
CREATE DATABASE austin_animals;
USE austin_animals;

DROP TABLE IF EXISTS Outcome;
DROP TABLE IF EXISTS Animal;
DROP TABLE IF EXISTS OutcomeClassification;
DROP TABLE IF EXISTS AnimalType;
DROP TABLE IF EXISTS Breed;
DROP TABLE IF EXISTS Color;
DROP TABLE IF EXISTS Outcomes_raw;

CREATE TABLE Outcomes_raw (
    animal_id VARCHAR(20),
    name VARCHAR(100),
    datetime DATETIME,
    monthyear VARCHAR(20),
    date_of_birth DATE,
    outcome_type VARCHAR(50),
    outcome_subtype VARCHAR(50),
    animal_type VARCHAR(30),
    sex_upon_outcome VARCHAR(50),
    age_upon_outcome VARCHAR(50),
    breed VARCHAR(100),
    color VARCHAR(50)
);


CREATE USER IF NOT EXISTS 'root'@'localhost'
IDENTIFIED BY 'password';

GRANT SELECT
ON austin_animals.*
TO 'root'@'localhost';

LOAD DATA INFILE '/home/coder/project/Austin_Animal_Center_Outcomes_(10_01_2013_to_05_05_2025)_20260710.csv'
INTO TABLE Outcomes_raw
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    animal_id,
    date_of_birth,
    name,
    datetime,
    monthyear,
    outcome_type,
    outcome_subtype,
    animal_type,
    sex_upon_outcome,
    age_upon_outcome,
    breed,
    color
);

-- create E
CREATE TABLE AnimalType (
    animal_type_id INT AUTO_INCREMENT PRIMARY KEY,
    animal_type VARCHAR(30) UNIQUE
);

CREATE TABLE Breed (
    breed_id INT AUTO_INCREMENT PRIMARY KEY,
    breed VARCHAR(100) UNIQUE
);

CREATE TABLE Color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    color VARCHAR(50) UNIQUE
);

CREATE TABLE OutcomeClassification (
    classification_id INT AUTO_INCREMENT PRIMARY KEY,
    outcome_type VARCHAR(50),
    outcome_subtype VARCHAR(50),
    UNIQUE(outcome_type, outcome_subtype)

);

CREATE TABLE Animal (
    animal_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100),
    date_of_birth DATE,

    animal_type_id INT,
    breed_id INT,
    color_id INT,

    FOREIGN KEY (animal_type_id)
        REFERENCES AnimalType(animal_type_id),

    FOREIGN KEY (breed_id)
        REFERENCES Breed(breed_id),

    FOREIGN KEY (color_id)
        REFERENCES Color(color_id)
);

CREATE TABLE Outcome (
    outcome_id INT AUTO_INCREMENT PRIMARY KEY,
    animal_id VARCHAR(20),
    classification_id INT,
    datetime DATETIME,
    sex_upon_outcome VARCHAR(50),
    age_upon_outcome VARCHAR(50),

    FOREIGN KEY(animal_id)
        REFERENCES Animal(animal_id),

    FOREIGN KEY(classification_id)
        REFERENCES OutcomeClassification(classification_id)
);

-- insert into
INSERT INTO AnimalType(animal_type)
SELECT DISTINCT animal_type
FROM Outcomes_raw;

INSERT INTO Breed(breed)
SELECT DISTINCT breed
FROM Outcomes_raw;

INSERT INTO Color(color)
SELECT DISTINCT color
FROM Outcomes_raw;

INSERT INTO OutcomeClassification(outcome_type, outcome_subtype)
SELECT DISTINCT outcome_type, outcome_subtype
FROM Outcomes_raw;

INSERT INTO Animal (
    animal_id,
    name,
    date_of_birth,
    animal_type_id,
    breed_id,
    color_id
)
SELECT
    r.animal_id,
    MAX(r.name),
    MAX(r.date_of_birth),
    at.animal_type_id,
    b.breed_id,
    c.color_id
FROM Outcomes_raw r
JOIN AnimalType at
    ON r.animal_type = at.animal_type
JOIN Breed b
    ON r.breed = b.breed
JOIN Color c
    ON r.color = c.color
GROUP BY
    r.animal_id,
    at.animal_type_id,
    b.breed_id,
    c.color_id;

INSERT INTO Outcome(
    animal_id,
    classification_id,
    datetime,
    sex_upon_outcome,
    age_upon_outcome
)
SELECT
    r.animal_id,
    oc.classification_id,
    r.datetime,
    r.sex_upon_outcome,
    r.age_upon_outcome
FROM Outcomes_raw r
JOIN OutcomeClassification oc
ON r.outcome_type = oc.outcome_type
AND r.outcome_subtype <=> oc.outcome_subtype;