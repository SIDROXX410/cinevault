-- ============================================
-- CINEVAULT — database.sql
-- SQL Database Schema + Seed Data
-- Database: SQLite (can also run on MySQL/PostgreSQL)
-- ============================================

-- ============================================
-- SECTION 1: DROP EXISTING TABLES
-- (Useful when resetting/reinitializing the DB)
-- ============================================
DROP TABLE IF EXISTS watchlist;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS users;


-- ============================================
-- SECTION 2: CREATE TABLES
-- ============================================

-- Table: movies
-- Stores all movie records
CREATE TABLE movies (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,  -- Unique ID, auto-incremented
    title       TEXT    NOT NULL,                   -- Movie title
    year        INTEGER NOT NULL,                   -- Release year
    genre       TEXT    NOT NULL,                   -- Genre (Drama, Sci-Fi, etc.)
    rating      REAL    NOT NULL,                   -- Rating out of 10
    director    TEXT    NOT NULL,                   -- Director's name
    duration    TEXT    NOT NULL,                   -- Runtime e.g. "142 min"
    synopsis    TEXT    NOT NULL,                   -- Full synopsis
    poster      TEXT,                               -- URL to poster image
    emoji       TEXT    DEFAULT '🎬',               -- Fallback emoji icon
    created_at  TEXT    DEFAULT CURRENT_TIMESTAMP   -- When record was added
);

-- Table: users
-- Stores user accounts (for watchlist & reviews)
CREATE TABLE users (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    username    TEXT    NOT NULL UNIQUE,
    email       TEXT    NOT NULL UNIQUE,
    password    TEXT    NOT NULL,                   -- Should be hashed in production!
    created_at  TEXT    DEFAULT CURRENT_TIMESTAMP
);

-- Table: watchlist
-- Stores which user has saved which movies
-- This is a "junction table" linking users and movies (Many-to-Many relationship)
CREATE TABLE watchlist (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id     INTEGER NOT NULL,
    movie_id    INTEGER NOT NULL,
    added_at    TEXT    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE,
    UNIQUE(user_id, movie_id)  -- A user can't add same movie twice
);

-- Table: reviews
-- Stores user reviews for movies
CREATE TABLE reviews (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id     INTEGER NOT NULL,
    movie_id    INTEGER NOT NULL,
    score       INTEGER CHECK(score BETWEEN 1 AND 10),  -- Score must be 1-10
    comment     TEXT,
    created_at  TEXT    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE
);


-- ============================================
-- SECTION 3: CREATE INDEXES
-- Speeds up common queries
-- ============================================

CREATE INDEX idx_movies_genre   ON movies(genre);
CREATE INDEX idx_movies_rating  ON movies(rating DESC);
CREATE INDEX idx_reviews_movie  ON reviews(movie_id);
CREATE INDEX idx_watchlist_user ON watchlist(user_id);


-- ============================================
-- SECTION 4: SEED DATA — Insert Movies
-- ============================================

INSERT INTO movies (title, year, genre, rating, director, duration, synopsis, poster, emoji) VALUES
(
    'The Shawshank Redemption', 1994, 'Drama', 9.3, 'Frank Darabont', '142 min',
    'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency. Andy Dufresne, a banker wrongly convicted of his wife''s murder, endures the brutal realities of Shawshank prison while maintaining hope and helping his fellow inmates along the way.',
    'https://m.media-amazon.com/images/M/MV5BNDE3ODcxYzMtY2YzZC00NmNlLWJiNDMtZDViZWM2MzIxZDYwXkEyXkFqcGdeQXVyNjAwNDUxODI@._V1_SX300.jpg',
    '🏛️'
),
(
    'The Godfather', 1972, 'Crime', 9.2, 'Francis Ford Coppola', '175 min',
    'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son. A saga of family, power, and loyalty that redefined American cinema and became one of the greatest films ever made.',
    'https://m.media-amazon.com/images/M/MV5BM2MyNjYxNmUtYTAwNi00MTYxLWJmNWYtYzZlODY3ZTk3OTFlXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg',
    '🌹'
),
(
    'Inception', 2010, 'Sci-Fi', 8.8, 'Christopher Nolan', '148 min',
    'A thief who enters the dreams of others to steal secrets from their subconscious is given the inverse task of planting an idea into the mind of a CEO. A visually stunning and intellectually challenging journey through layered realities and the architecture of the mind.',
    'https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_SX300.jpg',
    '🌀'
),
(
    'Interstellar', 2014, 'Sci-Fi', 8.7, 'Christopher Nolan', '169 min',
    'A team of explorers travel through a wormhole in space in an attempt to ensure humanity''s survival. An epic odyssey that blends theoretical physics with deeply human emotion, exploring time, gravity, and the unbreakable bond between a father and daughter.',
    'https://m.media-amazon.com/images/M/MV5BZjdkOTU3MDktN2IxOS00OGEyLWFmMjktY2FiMmZkNWIyODZiXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg',
    '🪐'
),
(
    'Parasite', 2019, 'Thriller', 8.5, 'Bong Joon-ho', '132 min',
    'Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan. A razor-sharp critique of economic inequality wrapped in darkly comic suspense.',
    'https://m.media-amazon.com/images/M/MV5BYWZjMjk3ZTItODQ2ZC00NTY5LWE0ZDYtZTI3MjcwN2Q5NTVkXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_SX300.jpg',
    '🪜'
),
(
    'Schindler''s List', 1993, 'Drama', 9.0, 'Steven Spielberg', '195 min',
    'In German-occupied Poland during World War II, industrialist Oskar Schindler gradually becomes concerned for his Jewish workforce after witnessing their persecution by the Nazis. A devastating and profoundly moving portrayal of courage, humanity, and the Holocaust.',
    'https://m.media-amazon.com/images/M/MV5BNDE4OTEyMDItNjBlOS00NjgzLWFlZGMtMmIyY2M0ZjA4YWMwXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_SX300.jpg',
    '🕯️'
),
(
    'The Dark Knight', 2008, 'Thriller', 9.0, 'Christopher Nolan', '152 min',
    'When the menace known as the Joker wreaks havoc and chaos on Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice. Heath Ledger''s iconic performance elevates this into a profound examination of order vs. chaos.',
    'https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_SX300.jpg',
    '🦇'
),
(
    'Pulp Fiction', 1994, 'Crime', 8.9, 'Quentin Tarantino', '154 min',
    'The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption. Tarantino''s non-linear narrative masterpiece redefined independent cinema with sharp dialogue and audacious style.',
    'https://m.media-amazon.com/images/M/MV5BNGNhMDIzZTUtNTBlZi00MTRlLWFjM2ItYzViMjE3YzI5MjljXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg',
    '💼'
),
(
    '2001: A Space Odyssey', 1968, 'Sci-Fi', 8.3, 'Stanley Kubrick', '149 min',
    'After discovering a mysterious artifact buried beneath the Lunar surface, a spacecraft is sent to Jupiter to find its origins, and an astronaut must battle HAL 9000, the ship''s intelligent computer. Kubrick''s visionary opus remains cinema''s most profound meditation on evolution and consciousness.',
    'https://m.media-amazon.com/images/M/MV5BMmNlYzRiNDctZWNhMi00MzI4LThkZTctZTUzZTQzM2IxOMjBlXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg',
    '🔲'
),
(
    'Spirited Away', 2001, 'Adventure', 8.6, 'Hayao Miyazaki', '125 min',
    'During her family''s move to the suburbs, a sullen ten-year-old girl wanders into a world ruled by gods, witches, and spirits. Studio Ghibli''s enchanting masterpiece is an immersive journey through a breathtaking spirit world of boundless imagination.',
    'https://m.media-amazon.com/images/M/MV5BMjlmZmI5MDctNDE2YS00YWE0LWE5ZWItZDBhYWQ0NTcxNWRhXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg',
    '🐉'
),
(
    'No Country for Old Men', 2007, 'Thriller', 8.2, 'Coen Brothers', '122 min',
    'Violence and mayhem ensue after a hunter stumbles upon a drug deal gone wrong and more than two million dollars in cash near the Rio Grande. The Coens'' existential thriller pits an unstoppable force of evil against aging lawmen.',
    'https://m.media-amazon.com/images/M/MV5BMjA5Njk3MjM4OV5BMl5BanBnXkFtZTcwMTc5MTE1MQ@@._V1_SX300.jpg',
    '🔩'
),
(
    'Lawrence of Arabia', 1962, 'Adventure', 8.3, 'David Lean', '228 min',
    'The story of T.E. Lawrence, the English officer who successfully united and led the Arab tribes during World War I. David Lean''s colossal epic remains the definitive portrait of one man''s myth-making against a backdrop of sweeping desert grandeur.',
    'https://m.media-amazon.com/images/M/MV5BYWY5ZGM0YTAtNjVlNS00ZDJkLWJjNTMtZGYwODc2MDQwMGFjXkEyXkFqcGdeQXVyNjc1NTYyMjg@._V1_SX300.jpg',
    '🏜️'
);


-- ============================================
-- SECTION 5: SEED DATA — Sample Users
-- ============================================

INSERT INTO users (username, email, password) VALUES
('alice',   'alice@example.com',   'hashed_password_1'),
('bob',     'bob@example.com',     'hashed_password_2'),
('charlie', 'charlie@example.com', 'hashed_password_3');


-- ============================================
-- SECTION 6: SEED DATA — Sample Watchlist
-- ============================================

-- Alice saved movie IDs 1, 3, 7
INSERT INTO watchlist (user_id, movie_id) VALUES (1, 1), (1, 3), (1, 7);

-- Bob saved movie IDs 2, 5, 8
INSERT INTO watchlist (user_id, movie_id) VALUES (2, 2), (2, 5), (2, 8);


-- ============================================
-- SECTION 7: SEED DATA — Sample Reviews
-- ============================================

INSERT INTO reviews (user_id, movie_id, score, comment) VALUES
(1, 1, 10, 'One of the greatest films ever made. Absolutely timeless.'),
(1, 3, 9,  'Mind-bending and beautifully crafted. Nolan at his best.'),
(2, 2, 10, 'A masterpiece of cinema. Every scene is perfect.'),
(2, 7, 9,  'Heath Ledger''s Joker is the greatest villain performance ever.'),
(3, 5, 10, 'Bong Joon-ho is a genius. This film is flawless.');


-- ============================================
-- SECTION 8: USEFUL QUERIES (for reference)
-- ============================================

-- Get all movies sorted by rating:
-- SELECT * FROM movies ORDER BY rating DESC;

-- Get all Drama movies:
-- SELECT * FROM movies WHERE genre = 'Drama';

-- Get a user's watchlist with movie details:
-- SELECT m.title, m.genre, m.rating
-- FROM watchlist w JOIN movies m ON w.movie_id = m.id
-- WHERE w.user_id = 1;

-- Get average rating per genre:
-- SELECT genre, ROUND(AVG(rating), 2) as avg_rating, COUNT(*) as count
-- FROM movies GROUP BY genre ORDER BY avg_rating DESC;

-- Get all reviews for a movie with username:
-- SELECT u.username, r.score, r.comment
-- FROM reviews r JOIN users u ON r.user_id = u.id
-- WHERE r.movie_id = 1;
