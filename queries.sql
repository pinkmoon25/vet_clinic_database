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

--What animals belong to Melody Pond?
vet_clinic=# select animals.name,owners.full_name from animals join owners on animals.owner_id = owners.id 
where owners.full_name = 'Melody Pond';
    name    |  full_name  
------------+-------------
 Blossom    | Melody Pond
 Charmander | Melody Pond
 Squirtle   | Melody Pond

--List of all animals that are pokemon (their type is Pokemon).
vet_clinic=# select animals.name, species.name from animals join species 
 on animals.species_id = species.id
 where species.name = 'Pokemon';
   name   |  name   
----------+---------
 Agumon   | Pokemon
 Gabumon  | Pokemon
 Devimon  | Pokemon
 Plantmon | Pokemon
 Boarmon  | Pokemon
 Angemon  | Pokemon
(6 rows)

--List all owners and their animals
vet_clinic=# select owners.full_name, animals.name from animals right join owners on animals.owner_id = owners.id;
    full_name     |    name    
------------------+------------
 Sam Smith        | Agumon
 Jennifer Orwell  | Pikachu
 Jennifer Orwell  | Gabumon
 Bob              | Plantmon
 Bob              | Devimon
 Melody Pond      | Squirtle
 Melody Pond      | Charmander
 Melody Pond      | Blossom
 Dean Winchester  | Angemon
 Dean Winchester  | Boarmon
 Joddie Whittaker | 
(11 rows)

--How many animals are there per species?
vet_clinic=# select count(animals.name), species.name from animals join species on animals.species_id = species.id group by species.name;
 count |  name   
-------+---------
     4 | Pokemon
     6 | Digimon
(2 rows)

--List all Digimon owned by Jennifer Orwell.
vet_clinic=# select owners.full_name, species.name from animals join owners on animals.owner_id = owners.id 
join species on animals.species_id = species.id where species.name = 'Digimon' and owners.full_name = 'Jennifer Orwell';
    full_name    |  name   
-----------------+---------
 Jennifer Orwell | Digimon
(1 row)

--List all animals owned by Dean Winchester that haven't tried to escape.
vet_clinic=# select animals.name, owners.full_name from animals join owners on animals.owner_id = owners.id where animals.escape_attempts=0
and owners.full_name = 'Dean Winchester';
 name | full_name 
------+-----------
(0 rows)

--Who owns the most animals?
vet_clinic=# select count(*), owners.full_name from animals join owners on 
animals.owner_id = owners.id group by owners.full_name order by count desc;
 count |    full_name    
-------+-----------------
     3 | Melody Pond
     2 | Bob
     2 | Dean Winchester
     2 | Jennifer Orwell
     1 | Sam Smith
(5 rows)
