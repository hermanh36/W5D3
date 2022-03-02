
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;
PRAGMA foreign_keys = ON;
--USER TABLE
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname VARCHAR(255) NOT NULL
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Naran', 'Ivanchukov'),
  ('Herman', 'He');
----------------------------------------------------------
----------------------------------------------------------
CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);
INSERT INTO
  questions(title, body, author_id)
VALUES
  ('study q''s', 'How do i get an A without studying?', 1),
  ('cow meat', 'bovine meat is the best meat no question', 2),
  ('propoganda', 'is covid real?', 2);
----------------------------------------------------------
----------------------------------------------------------
CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  users_id INTEGER NOT NULL,
  questions_id INTEGER NOT NULL,

  FOREIGN KEY (users_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id) 
);
INSERT INTO
  question_follows(users_id, questions_id)
VALUES
  (1, 1),
  (2, 2),
  (2, 3);
----------------------------------------------------------
----------------------------------------------------------
CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  users_id INTEGER NOT NULL,
  questions_id INTEGER NOT NULL,
  parents_id INTEGER,
  body_reply TEXT NOT NULL,

  FOREIGN KEY (users_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id),
  FOREIGN KEY (parents_id) REFERENCES replies(id)
);
INSERT INTO 
  replies(users_id, questions_id, parents_id, body_reply)
VALUES
  (1, 1, NULL, 'study you idiot'),
  (2, 2, NULL, 'pork meat all the way'),
  (1, 1, 1, 'no u'),
  (2, 3, NULL, 'no its not lol, get educated scrub');
----------------------------------------------------------
----------------------------------------------------------
CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  likes INTEGER,
  users_id INTEGER NOT NULL,
  questions_id INTEGER NOT NULL,

  FOREIGN KEY (users_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id)
);
INSERT INTO 
  question_likes(likes, users_id, questions_id)
VALUES
  (26, 1, 1),
  (42716, 2, 2),
  (0, 2, 3);


