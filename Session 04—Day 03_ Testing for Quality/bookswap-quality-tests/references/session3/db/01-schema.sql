
-- BookSwap practice database: schema

CREATE TABLE members (
  id           SERIAL PRIMARY KEY,
  display_name TEXT        NOT NULL,
  email        TEXT        NOT NULL UNIQUE,
  phone        TEXT,
  address      TEXT,
  building_id  INTEGER     NOT NULL,
  joined_on    DATE        NOT NULL
);

CREATE TABLE books (
  id          SERIAL PRIMARY KEY,
  owner_id    INTEGER     NOT NULL REFERENCES members(id),
  building_id INTEGER     NOT NULL,
  title       TEXT        NOT NULL,
  author      TEXT        NOT NULL,
  isbn        VARCHAR(13) NOT NULL,
  condition   TEXT        NOT NULL CHECK (condition IN ('new','good','fair','poor')),
  status      TEXT        NOT NULL CHECK (status IN ('available','on_loan','unavailable')),
  created_at  TIMESTAMP   NOT NULL
);

CREATE TABLE borrow_requests (
  id          SERIAL PRIMARY KEY,
  book_id     INTEGER   NOT NULL REFERENCES books(id),
  borrower_id INTEGER   NOT NULL REFERENCES members(id),
  status      TEXT      NOT NULL CHECK (status IN ('pending','accepted','declined')),
  created_at  TIMESTAMP NOT NULL
);

CREATE TABLE loans (
  id          SERIAL PRIMARY KEY,
  book_id     INTEGER NOT NULL REFERENCES books(id),
  borrower_id INTEGER NOT NULL REFERENCES members(id),
  status      TEXT    NOT NULL CHECK (status IN ('out','returned')),
  borrowed_at DATE    NOT NULL,
  returned_at DATE
);
