CREATE TABLE flights
  (flightid     INTEGER  PRIMARY KEY AUTOINCREMENT,
   origin       TEXT     NOT NULL,
   destination  TEXT     NOT NULL,
   duration     INT      NOT NULL);
