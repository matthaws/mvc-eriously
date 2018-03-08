CREATE TABLE droids (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(planet_id) REFERENCES planets(id)
);

CREATE TABLE planets (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO
  planets (id, name)
VALUES
  (1, "Corellia"), (2, "Tatooine");

INSERT INTO
  humans (id, fname, lname, planet_id)
VALUES
  (1, "Luke", "Skywalker", 2),
  (2, "Han", "Solo", 1),
  (3, "Owen", "Lars", 2),
  (4, "Bib", "Fortuna", 2);

INSERT INTO
  droids (id, name, owner_id)
VALUES
  (1, "C3-P0", 1),
  (2, "R5-T9", 2),
  (3, "Moisture Vaporators", 3),
  (4, "R2-D2", 3),
  (5, "HK-47", NULL);
