-- Active: 1747410369150@@127.0.0.1@5432@conservation_db
CREATE DATABASE conservation_db;

CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    region TEXT
);

INSERT INTO rangers (name,region)
    VALUES ('Alice Green ','Northern Hills'),
            ('Bob White','River Delta'),
            ('Carol King','Mountain Range');

CREATE TABLE species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100),
    scientific_name VARCHAR(100),
    discovery_date DATE,
    conservation_status VARCHAR(50)
)

INSERT INTO species ( common_name, scientific_name, discovery_date, conservation_status)
VALUES
    ('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
    ('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
    ('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
    ( 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

CREATE TABLE sightings(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers(ranger_id),
    species_id INT REFERENCES species(species_id),
    sighting_time TIMESTAMP NOT NULL,
    location TEXT NOT NULL,
    notes TEXT 
)

INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge',        '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area',     '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass',     '2024-05-18 18:30:00', NULL);




-- problem 1
INSERT INTO rangers(name,region)  VALUES('Derek Fox','Coastal Plains')

-- problem 2
SELECT count(DISTINCT species_id)
FROM sightings;

-- problem 3
SELECT * FROM sightings WHERE location LIKE '%Pass%';

-- problem 4
SELECT r.name AS ranger_name,COUNT(s.sighting_id) AS total_sightings FROM rangers r
    LEFT JOIN sightings s ON r.ranger_id = s.ranger_id
    GROUP BY r.name
    ORDER BY total_sightings DESC;

-- problem 5
SELECT 
    s.common_name,
    s.scientific_name
FROM species s
LEFT JOIN sightings si ON s.species_id = si.species_id
WHERE si.sighting_id IS NULL;

-- problem 6
SELECT *
FROM sightings
ORDER BY sighting_time DESC
LIMIT 2;


-- problem 7
UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';


-- problem 8
SELECT 
    sighting_id,
    sighting_time,
    CASE 
        WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sighting_time) < 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;


DELETE FROM rangers
WHERE NOT EXISTS (
    SELECT 1
    FROM sightings
    WHERE sightings.ranger_id = rangers.ranger_id
);

