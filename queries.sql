/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon%';
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT * FROM animals WHERE neutered AND escape_attempts<3;
SELECT date_of_birth FROM animals WHERE name = 'Pikachu' OR name = 'Agumon';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered;
SELECT * FROM animals WHERE name != 'Gabumon';  
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

/*transaction*/
vet_clinic=# begin transaction;
BEGIN
vet_clinic=*# update animals set species = 'unspecified';
UPDATE 11
vet_clinic=*# rollback;
ROLLBACK

vet_clinic=# BEGIN;
BEGIN
vet_clinic=*# update animals set species = 'digimon' where name like '%mon';
UPDATE 6
vet_clinic=*# update animals set species = 'pokemon' where species IS NULL;
UPDATE 5
vet_clinic=*# commit;
COMMIT

vet_clinic=# begin;
BEGIN
vet_clinic=*# DELETE FROM animals;
DELETE 11
vet_clinic=!# rollback;
ROLLBACK

vet_clinic=# begin;
BEGIN
vet_clinic=*# DELETE FROM animals WHERE date_of_birth > '2022-01-01';
DELETE 1
vet_clinic=*# SAVEPOINT update1;
SAVEPOINT
vet_clinic=*# UPDATE animals SET weight_kg = weight_kg*-1;
UPDATE 10
vet_clinic=*# rollback to update1;
ROLLBACK
vet_clinic=*# UPDATE animals SET weight_kg = weight_kg*-1 WHERE weight_kg < 0;
UPDATE 4
vet_clinic=*# commit;
COMMIT

/*queries to answer questions*/
vet_clinic=# SELECT COUNT(name) FROM animals; /*How many animals are there?*/ 
 count 
-------
    10

vet_clinic=# SELECT COUNT(name) FROM animals WHERE escape_attempts=0; /*How many animals have never tried to escape?*/
 count 
-------
     2

vet_clinic=# SELECT AVG(weight_kg) FROM animals; /*What is the average weight of animals?*/
         avg         
---------------------
 15.5500

 vet_clinic=# SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered;/*Who escapes the most, neutered or not neutered animals?*/
 neutered | max 
----------+-----
 f        |   3
 t        |   7

 vet_clinic=# SELECT species, MAX(weight_kg) FROM animals GROUP BY species;/*What is the maximum weight of each type of animal?*/
 species | max 
---------+-----
 pokemon |  17
 digimon |  45

vet_clinic=# SELECT species, MIN(weight_kg) FROM animals GROUP BY species;/*What is the minimum weight of each type of animal?*/
 species | min 
---------+-----
 pokemon |  11
 digimon | 5.7
(2 rows)

vet_clinic=# SELECT species, ROUND(AVG(escape_attempts),2) FROM animals GROUP BY species, date_of_birth HAVING date_of_birth BETWEEN '1990-01-01' AND '2000-12-31';
 species | round 
---------+-------
 pokemon |  3.00
 pokemon |  3.00
