psql -U postgres -d bookmark_manager

CREATE DATABASE bookmark_manager;

CREATE DATABASE bookmark_manager_test;

\c bookmark_manager;

\c bookmark_manager_test;

CREATE TABLE bookmarks(id SERIAL PRIMARY KEY, url VARCHAR(60));

ALTER TABLE bookmarks ADD title VARCHAR(60);

CREATE TABLE comments(id SERIAL PRIMARY KEY, text VARCHAR(240), bookmark_id INTEGER REFERENCES bookmarks (id));

CREATE TABLE tags(id SERIAL PRIMARY KEY, content VARCHAR(60));

CREATE TABLE bookmark_tags(tag_id INTEGER REFERENCES tags (id), bookmark_id INTEGER REFERENCES bookmarks (id));

CREATE TABLE users(id SERIAL PRIMARY KEY, email VARCHAR(60), password VARCHAR(60));
