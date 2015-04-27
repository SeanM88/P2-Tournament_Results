-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


-- Creates a table for player registration.
CREATE TABLE players (
    id SERIAL PRIMARY KEY,
    name TEXT
);

-- Creates a table for recording the tournament's match results.
CREATE TABLE matches (
    match_id SERIAL PRIMARY KEY,
    winner INTEGER REFERENCES players (id),
    loser INTEGER REFERENCES players (id)
);

-- Returns the number of matches each player has played.
CREATE VIEW match_count AS
    SELECT players.id, COUNT(NULLIF(matches.match_id,0)) AS matches
    FROM players LEFT JOIN matches
    ON players.id = matches.winner OR players.id = matches.loser
    GROUP BY players.id
    ORDER BY players.id;

-- Returns the number of win each player has, sorted by wins.
CREATE VIEW win_count AS
    SELECT players.id, COUNT(NULLIF(matches.winner,0)) AS wins
    FROM players LEFT JOIN matches
    ON players.id = matches.winner
    GROUP BY players.id
    ORDER BY wins DESC;

-- Returns player standings, including both number of wins and matches played, sorted by wins.
CREATE VIEW standings AS
    SELECT players.id, players.name, win_count.wins, match_count.matches
    FROM players, win_count, match_count
    WHERE players.id = win_count.id AND players.id = match_count.id
    ORDER BY wins DESC;