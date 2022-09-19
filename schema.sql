/* Database schema to keep the structure of entire database. */

CREATE TABLE animals(
    id INT PRIMARY KEY,
    name  VARCHAR,
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg Decimal
);

ALTER TABLE animals ADD species VARCHAR;
ALTER TABLE animals DROP column species;
ALTER TABLE animals ADD PRIMARY KEY(id);
ALTER TABLE animals ADD species_id INT;
ALTER TABLE animals ADD owner_id INT;
ALTER TABLE animals ADD FOREIGN KEY (species_id) REFERENCES species(id);
ALTER TABLE animals ADD FOREIGN KEY (owner_id) REFERENCES owners(id);

CREATE TABLE owners(id INT GENERATED ALWAYS AS IDENTITY, full_name VARCHAR, age INT);
ALTER TABLE owners ADD PRIMARY KEY(id);

CREATE TABLE species(id INT GENERATED ALWAYS AS IDENTITY, name VARCHAR);
ALTER TABLE species ADD PRIMARY KEY(id);

CREATE TABLE vets (
id INT GENERATED ALWAYS AS IDENTITY,
name VARCHAR,
age INT,
date_of_graduation DATE);

ALTER TABLE vets ADD PRIMARY KEY(id);

create table specializations (
    vet_id int references vets(id),
    species_id int references species(id)
);

create table visits (
vet_id int references vets(id),
animals_id int references animals(id),
date_of_visit date
);

ALTER TABLE owners ADD COLUMN email VARCHAR(120);
