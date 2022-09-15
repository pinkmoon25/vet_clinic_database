/* Populate database with sample data. */

INSERT INTO animals VALUES (1, 'Agumon', '2020-02-03', 0, true, 10.23);
INSERT INTO animals VALUES (2, 'Gabumon', '2018-11-15', 2, true, 8);
INSERT INTO animals VALUES (3, 'Pikachu', '2021-01-07', 1, false, 15.04);
INSERT INTO animals VALUES (4, 'Devimon', '2017-05-12', 5, true, 11);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Charmander', '2020-02-08', 0, false, -11);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Plantmon', '2021-11-15', 2, true, -5.7);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Squirtle', '1993-04-02', 3, false, -12.13);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Angemon', '2005-06-12', 1, true, -45);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Boarmon', '2005-06-07', 7, true, 20.4);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Blossom', '1998-10-13', 3, true, 17);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Ditto', '2022-05-14', 4, true, 22);

insert into owners (full_name, age) values ('Sam Smith', 34),
 ('Jennifer Orwell', 19),
 ('Bob',45), ('Melody Pond', 77), 
 ('Dean Winchester', 14), 
 ('Joddie Whittaker', 38);

insert into species (name) values ('Pokemon'), ('Digimon');

vet_clinic=*# update animals set species_id = 2 where name like '%mon'; 
UPDATE 6
vet_clinic=*# update animals set species_id = 1 where species_id IS NULL; 
UPDATE 4
vet_clinic=*# update animals set owner_id = 1 where name='Agumon';
UPDATE 1
vet_clinic=*# update animals set owner_id = 2 where name in ('Gabumon', 'Pikachu');
UPDATE 2
vet_clinic=*# update animals set owner_id = 3 where name in ('Devimon', 'Plantmon');
UPDATE 2
vet_clinic=*# update animals set owner_id = 4 where name in ('Charmander', 'Squirtle', 'Blossom');
UPDATE 3
vet_clinic=*# update animals set owner_id = 5 where name in ('Angemon', 'Boarmon');
UPDATE 2

INSERT INTO vets (name, age, date_of_graduation)
VALUES ('William Tatcher', 45, '2000-04-23'),
('Maisy SMith', 26, '2019-01-17'),
('Stephanie Mendez', 64, '1981-05-04'),
('Jack Harness', 38, '2008-06-08');
