DESCRIBE players_runs;      

-- Retrieve the id of all players and their total runs scored.

SELECT id , sum(runs)
FROM players_runs
GROUP BY id;

-- List the players who have taken more than 5 wickets.

SELECT id , sum(wickets) 
FROM players_wickets
GROUP BY id
HAVING sum(wickets) > 5;

-- Find the player with the highest individual score.

SELECT id, MAX(runs) AS 'highest score'
FROM players_runs
GROUP BY id
ORDER BY 'highest score' DESC
LIMIT 1;

-- Retrieve the total number of wickets taken by each player.

SELECT id , sum(wickets) 
FROM players_wickets
GROUP BY id;

-- Calculate the average runs scored by players in each category (if available) from the 'stats_runs_category' table. 

SELECT id , match_type , avg(runs_made) as average_runs
FROM stats_runs_category
GROUP BY id , match_type;

-- Retrieve the players who have an average of more than 40 in the 'stats_runs_category' table.

SELECT id , match_type , avg(runs_made) as average_runs
FROM stats_runs_category
GROUP BY id , match_type
HAVING average_runs > 40;

-- LEFT JOIN OF PLAYERS RUNS AND PLAYERS WICKETS.

SELECT pr.id , pr.match , runs , wickets
FROM players_runs pr
LEFT JOIN players_wickets pw
ON pr.id = pw.id;

-- WHAT PERCENTAGE OF RUNS IN MATCH 1 WERE MADE BY EACH PLAYER, USE PLAYERS RUNS 

SELECT id , (sum(runs) / (SELECT sum(runs) FROM players_runs WHERE `match` = 1)) * 100 as "percentage of runs"
FROM players_runs
WHERE `match` = 1
GROUP BY id;

-- STATS WICKETS

SELECT *
FROM stats_wickets;

-- RANK WICKETS BY ID

SELECT id , sum(wickets) as 'total wickets',
RANK() OVER(ORDER BY sum(wickets) DESC) as 'ranking'
FROM stats_wickets
GROUP BY id;

-- DENSE RANK WICKETS BY ID

SELECT id , sum(wickets) as 'total wickets',
DENSE_RANK() OVER(ORDER BY sum(wickets) DESC) as 'ranking'
FROM stats_wickets
GROUP BY id;

-- CALCULATE THE RANK AND DENSE RANK OF BATTING AVERAGES OF PLAYERS USING ROUND FUNCTION.

SELECT id, round(avg(runs),2) as batting_avg , 
RANK() OVER (order by round(avg(runs),2) desc) as ranking 
FROM stats_runs 
GROUP BY id, runs;

SELECT id, round(avg(runs),2) as batting_avg , 
DENSE_RANK() OVER (order by round(avg(runs),2) desc) as ranking 
FROM stats_runs 
GROUP BY id, runs;

-- WHAT PERCENTAGE OF WICKETS DID EACH PLAYERS GET IN EACH MATCH.

SELECT id , sum(wickets) / (SELECT sum(wickets) FROM players_wickets) * 100 as "percentage of wickets"
FROM players_wickets
GROUP BY id , `match`;
