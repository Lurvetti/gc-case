-----------   QUERIES RESPOSTAS   ------------ 
----------------------------------------------
--Q1: Quantos jogadores únicos tempos na base?
SELECT 
    COUNT (DISTINCT player_id) AS n_players 
FROM tb_players 
; 
-- R: 2500 players, mesmo número de linhas -> sem dados faltantes ou duplicados 


------------------------------------------------------------------ 
--Q2: Quantos usuários únicos jogaram em agosto após o 02/08/2021? 
SELECT
	MIN (created_at) AS last_game_date,
	MAX (created_at) AS first_gamte_date,
    COUNT (DISTINCT player_id) AS n_players,
    COUNT (DISTINCT idlobby_game) AS n_lobbies
FROM tb_lobby_stats_player
WHERE created_at BETWEEN '2021-08-03' AND '2021-08-31' -- between do sqlite é inclusive
;  
-- R: 1185 players em 23979 lobbies, entre 09/08 e 30/08


----------------------------------------------------------------
-- Q3: Quantos usuários únicos não jogaram após o dia 01/12/2021
SELECT
    COUNT(player_id) AS n_players
FROM tb_players
WHERE player_id NOT IN (
    SELECT
        DISTINCT player_id
    FROM tb_lobby_stats_player
    WHERE created_at >= '2021-12-02'
)
; 
-- R: 417 players sem partida após 01/12/2021


----------------------------------------------------------------
-- Q4: Qual jogador ganhou mais clutchs em novembro?
SELECT
	player_id,
	SUM (clutch_won) AS sum_clutch_won
FROM tb_lobby_stats_player
WHERE strftime("%m", created_at) = "11"
GROUP BY player_id
ORDER BY sum_clutch_won DESC
LIMIT 10
; 
-- R: player 793, com 107 clutchs ganhos!



----------------------------------------------------------------
-- Q5: Qual a média diária de jogadores distintos?
-- a: da base | b: de outubro | c: de dezembro
WITH temp AS (
	SELECT 
		idlobby_game,
		player_id,
		
		created_at,
		strftime("%Y-%m", created_at) AS month_lobby,
		strftime("%Y-%m-%d", created_at) AS day_lobby
	FROM tb_lobby_stats_player
	ORDER BY idlobby_game ASC 
)

SELECT
	-- quebras
	month_lobby,
	day_lobby,
	
	-- stats
	COUNT (DISTINCT player_id) AS n_players,
	ROUND (AVG (COUNT (DISTINCT player_id)) OVER (), 2) AS avg_base,
	ROUND (AVG (COUNT (DISTINCT player_id)) OVER (PARTITION BY month_lobby), 2) AS avg_month
FROM temp
GROUP BY day_lobby
ORDER BY day_lobby ASC
; 
-- a: 452.87 players distintos por dia, considerando a base toda
-- b: 439.29 players distintos por dia, considerando outubro
-- c: 498.39 players distintos por dia, considerando dez




----------------------------------------------------------------
-- Q6: Dos jogadores que se cadastraram em junho, quantos não jogaram em agosto?
WITH temp AS (
	SELECT
		t1.player_id,
		data_cadastro,
		
		strftime("%Y-%m", data_cadastro) AS year_month_cadastro,
		strftime("%m", data_cadastro) AS month_cadastro,
		
		t2.players_ago
	FROM tb_players as t1
	INNER JOIN (
		SELECT
			DISTINCT(player_id) AS players_ago
		FROM tb_lobby_stats_player
		WHERE strftime("%Y-%m", created_at) != '2021-08'
	) AS t2 
    ON t1.player_id = t2.players_ago
	
	-- filtro para Junho de 2021 apenas
	WHERE year_month_cadastro = '2021-06'
	
	-- filtro para todos os meses de Junho
	/*WHERE year_month_cadastro IN (
		SELECT
			DISTINCT (strftime("%Y-%m", data_cadastro)) AS year_month_cadastro
		FROM tb_players
		WHERE strftime("%m", data_cadastro) = '06'
		)*/
	ORDER BY data_cadastro ASC

)
SELECT COUNT(1) FROM temp
;	
-- R: 37 players que se cadastraram em junho de 2021, não jogaram em agosto de 2021
-- R: 186 players que se cadastraram em todos os meses de Junho e não jogaram em agosto de 2021



----------------------------------------------------------------
-- Q7: Quais os 10 players que dão mais HS por jogo?
-- a: e os piores?
WITH temp AS (
	SELECT 
		player_id,

		SUM (hit_headshots) AS sum_hit_headshots,
		COUNT (DISTINCT idlobby_game) AS n_games,
		ROUND(SUM (hit_headshots) / COUNT (DISTINCT idlobby_game), 2) AS stat
		
	FROM tb_lobby_stats_player
	WHERE 
		hits IS NOT NULL AND 
		hit_headshots IS NOT NULL
	GROUP BY player_id
),

top AS (SELECT 'best' AS classe, * FROM temp ORDER BY stat DESC LIMIT 10),
bottom AS (SELECT 'worst' AS classe, * FROM temp ORDER BY stat ASC LIMIT 10)

SELECT * FROM top UNION ALL SELECT * FROM  bottom
;
-- done


----------------------------------------------------------------
-- Q8: Qual o Win Rate dos players que se cadastraram em Janeiro? E de Fevereiro?
WITH temp AS (
	SELECT
		t1.player_id,
		t1.data_cadastro,
		strftime("%Y-%m", t1.data_cadastro) AS year_month_cadastro,
		
		t2.*
	FROM tb_players as t1
	INNER JOIN (
		SELECT
			player_id,
			SUM (winner) AS games_won,
			COUNT (DISTINCT idlobby_game) AS games_played,
			ROUND (SUM (winner)*1.0 / COUNT (DISTINCT idlobby_game)*100, 2) AS win_rate
		FROM tb_lobby_stats_player
		GROUP BY player_id
	) AS t2 
    ON t1.player_id = t2.player_id
	
	-- filtro para jan e fev de 2021 apenas
	WHERE year_month_cadastro IN ('2021-01', '2021-02')
	
	-- filtro de jan e fev de todos os anos
	/*WHERE year_month_cadastro IN (
		SELECT
			DISTINCT (strftime("%Y-%m", data_cadastro)) AS year_month_cadastro
		FROM tb_players
		WHERE strftime("%m", data_cadastro) = '01' OR strftime("%m", data_cadastro) = '02' 
		)*/
)
SELECT 
	year_month_cadastro,
	ROUND(AVG(win_rate), 2) AS avg_win_rate
FROM temp
GROUP BY year_month_cadastro
;
-- winrate de jogadores de jan: 42.94
-- winrate de jogadres de fev: 46.12
-- (considerando 2021)




----------------------------------------------------------------
-- Q9: Qual a descrição de medalha que os players mais tem?
WITH temp AS (
	SELECT
		medalha_id,
		COUNT (DISTINCT player_id) AS n_players
	FROM tb_players_medalha as t1
	WHERE ativo = 1 
	GROUP BY medalha_id
	ORDER BY n_players DESC
	LIMIT 10
)
SELECT 
	*	
FROM temp
LEFT JOIN tb_medalha AS medal
ON temp.medalha_id = medal.medalha_id
;
-- R: Bom Comportamento (considerando medalhas ativas)









