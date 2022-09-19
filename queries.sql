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
vet_clinic=# select owners.full_name, species.name from animals join owners on animals.owner_id = owners.id join species on animals.species_id = species.id where species.name = 'Digimon' and owners.full_name = 'Jennifer Orwell';
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

--Who was the last animal seen by William Tatcher?
select visits.date_of_visit, animals.name, vets.name from animals 
join visits on animals.id = visits.animals_id 
join vets on visits.vet_id = vets.id 
where vets.name = 'William Tatcher' 
order by visits.date_of_visit desc limit 1;
 date_of_visit |  name   |      name       
---------------+---------+-----------------
 2021-01-11    | Blossom | William Tatcher
(1 row)

--List all vets and their specialties, including vets with no specialties.
select vets.name, species.name from vets
left join specializations on specializations.vet_id = vets.id
left join species on specializations.species_id = species.id;
       name       |  name   
------------------+---------
 William Tatcher  | Pokemon
 Stephanie Mendez | Pokemon
 Stephanie Mendez | Digimon
 Jack Harness     | Digimon
 Maisy SMith      | 
(5 rows)

--How many different animals did Stephanie Mendez see?
select count(animals.name), vets.name from animals 
join visits on visits.animals_id = animals.id
join vets on vets.id = visits.vet_id
where vets.name = 'Stephanie Mendez'
group by vets.name;
 count |       name       
-------+------------------
     4 | Stephanie Mendez

--List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
select animals.name, vets.name, visits.date_of_visit from animals 
join visits on visits.animals_id = animals.id
join vets on vets.id = visits.vet_id
where vets.name = 'Stephanie Mendez' and visits.date_of_visit between '2020-04-01' and '2020-08-30';
  name   |       name       | date_of_visit 
---------+------------------+---------------
 Agumon  | Stephanie Mendez | 2020-07-22
 Blossom | Stephanie Mendez | 2020-05-24
(2 rows)

--What animal has the most visits to vets?
select animals.name, count(*) from animals join visits on visits.animals_id = animals.id
group by animals.name
order by count desc limit 1;
  name   | count 
---------+-------
 Boarmon |     4
(1 row)

--Who was Maisy Smith's first visit?
select visits.date_of_visit, animals.name, vets.name from animals
join visits on visits.animals_id = animals.id
join vets on vets.id = visits.vet_id
where vets.name = 'Maisy SMith'
order by visits.date_of_visit asc
limit 1;
 date_of_visit |  name   |    name     
---------------+---------+-------------
 2019-01-24    | Boarmon | Maisy SMith
(1 row)

--Details for most recent visit: animal information, vet information, and date of visit.
select animals.name, vets.name, visits.date_of_visit from animals 
join visits on visits.animals_id = animals.id
join vets on vets.id = visits.vet_id 
order by visits.date_of_visit desc limit 1;
  name   |       name       | date_of_visit 
---------+------------------+---------------
 Devimon | Stephanie Mendez | 2021-05-04
(1 row)

--What specialty should Maisy Smith consider getting? Look for the species she gets the most.
select vets.name, species.name, count(species.name) from vets 
join visits on visits.vet_id = vets.id 
join animals on visits.animals_id = animals.id 
join species on animals.species_id = species.id 
where vets.name = 'Maisy SMith' 
group by species.name, vets.name 
order by count desc limit 1;
    name     |  name   | count 
-------------+---------+-------
 Maisy SMith | Digimon |     6
(1 row)

--How many visits were with a vet that did not specialize in that animal's species?
select visits.vet_id as "Vets ID",
specializations.species_id as "specialized in",
animals.species_id as "Visited Species",
count(*), SUM(COUNT(*)) OVER() AS unspecialize_visits 
from visits left join specializations on specializations.vet_id=visits.vet_id 
join animals on visits.animals_id=animals.id 
where ((animals.species_id!=specializations.species_id or specializations.species_id is null) 
and visits.vet_id!=3) group by visits.vet_id,specializations.species_id,animals.species_id;

 Vets ID | specialized in | Visited Species | count | unspecialize_visits 
---------+----------------+-----------------+-------+---------------------
       2 |                |               2 |     6 |                  12
       1 |              1 |               2 |     2 |                  12
       4 |              2 |               1 |     1 |                  12
       2 |                |               1 |     3 |                  12
(4 rows)


/* data performance audit */
explain analyze SELECT COUNT(*) FROM visits where animals_id = 4;
explain analyze SELECT * FROM owners where email = 'owner_18327@mail.com';