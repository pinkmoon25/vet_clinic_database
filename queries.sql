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
vet_clinic=*# rollback;
ROLLBACK
vet_clinic=# begin;
BEGIN
vet_clinic=*# UPDATE animals SET weight_kg = weight_kg*-1 WHERE weight_kg < 0;
UPDATE 4
vet_clinic=*# commit;
COMMIT
