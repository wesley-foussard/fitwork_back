BEGIN;

DROP TABLE
    IF EXISTS article,
    category,
    label,
    role,
    "user",
    favorite,-- association table for user_like_article
    program,-- association table  for user_programs_article
    article_has_label;

-- ---------------------------------------------------------------------------------------

-- table article

-- ---------------------------------------------------------------------------------------

CREATE TABLE
    IF NOT EXISTS article(
        id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        time INTERVAL,-- time for activity, to check if interval works
        image TEXT, -- URL
        "type" TEXT, -- used for advice/activity
        category_id INT NOT NULL , -- used for food/at work/etc...
        user_id INT NOT NULL ,
        created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at timestamptz
    );

-- ---------------------------------------------------------------------------------------

-- table category

-- ---------------------------------------------------------------------------------------

CREATE TABLE
    IF NOT EXISTS category(
        id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name TEXT NOT NULL
    );

-- ---------------------------------------------------------------------------------------

-- table label
-- used for food/sleep/at work/etc...

-- ---------------------------------------------------------------------------------------

CREATE TABLE
    IF NOT EXISTS label(
        id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name TEXT NOT NULL
    );

-- ---------------------------------------------------------------------------------------

-- table role
-- member, coach, admin,

-- ---------------------------------------------------------------------------------------

CREATE TABLE
    IF NOT EXISTS role(
        id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        label TEXT NOT NULL
    );

-- ---------------------------------------------------------------------------------------

-- table user

-- ---------------------------------------------------------------------------------------

CREATE TABLE
    IF NOT EXISTS "user"(
        id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        firstname TEXT NOT NULL,
        lastname TEXT ,
        email TEXT NOT NULL UNIQUE,
        birth_date DATE NOT NULL,
        password TEXT NOT NULL,
        role_id INTEGER NOT NULL DEFAULT 2,
        created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at timestamptz
    );

-- ---------------------------------------------------------------------------------------

-- table favorite

-- ---------------------------------------------------------------------------------------

CREATE TABLE
    IF NOT EXISTS favorite(
        -- id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        user_id INTEGER REFERENCES "user"(id) ON DELETE CASCADE,
        article_id INTEGER REFERENCES article(id)ON DELETE CASCADE,
        CONSTRAINT unicity_like UNIQUE (user_id,article_id) -- contrainte empêchant l'ajout d'un même article plusieurs fois en favoris par un utilisateur
    );

-- ---------------------------------------------------------------------------------------

-- table program
-- table ds'association

-- ---------------------------------------------------------------------------------------

CREATE TABLE
    IF NOT EXISTS program(
        id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        user_id INTEGER REFERENCES "user"(id) ON DELETE CASCADE,
        article_id INTEGER REFERENCES article(id) ON DELETE CASCADE,
        status BOOLEAN DEFAULT false
    );

-- ---------------------------------------------------------------------------------------

-- table article_has_label
-- used for eyes/arms/whatever... 

-- ---------------------------------------------------------------------------------------

CREATE TABLE
    IF NOT EXISTS article_has_label(
        --id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
        article_id INTEGER REFERENCES article(id) ON DELETE CASCADE,
        label_id INTEGER REFERENCES label(id) ON DELETE CASCADE,
        CONSTRAINT label_unicity UNIQUE(article_id,label_id)
    );

ALTER TABLE article ADD FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE CASCADE;
ALTER TABLE article ADD FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;
ALTER TABLE "user" ADD FOREIGN KEY (role_id) REFERENCES role(id) ON DELETE CASCADE;
COMMIT;