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
alter table animals add species_id int;
alter table animals add owner_id int;
alter table animals add foreign key (species_id) references species(id);
alter table animals add foreign key (owner_id) references owners(id);

CREATE TABLE owners(id INT GENERATED ALWAYS AS IDENTITY, full_name VARCHAR, age INT);
ALTER TABLE owners ADD PRIMARY KEY(id);

CREATE TABLE species(id INT GENERATED ALWAYS AS IDENTITY, name VARCHAR);
ALTER TABLE species ADD PRIMARY KEY(id);
