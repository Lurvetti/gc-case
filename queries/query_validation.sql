----------- QUERIES VALIDAÇÂO  -----------
-- tamanho de base de players
SELECT
    COUNT(1)
FROM tb_players
; -- 2500

-- players nulos
SELECT 
    COUNT(1)  
FROM tb_players 
WHERE player_id IS NULL
; -- 0

-- tamanho de base de partidas
SELECT
    COUNT(1) 
FROM tb_lobby_stats_player
; -- 182591

--  partidas nulas
SELECT 
    COUNT(1)  
FROM tb_lobby_stats_player 
WHERE idlobby_game IS NULL
; -- 0 -> sem dados faltantes

-- partidas distintas
SELECT 
    COUNT (DISTINCT idlobby_game) AS n_lobbies 
FROM tb_lobby_stats_player 
; -- 172039 -> existem partidas repetidas (chave estrangeira player_id)


-- partindo da premissa que o registro no banco (created_at) é igual à data da partida
-- intervalo de base
SELECT
    MIN (created_at) AS oldest_game,
    MAX (created_at) AS newest_game,
FROM tb_lobby_stats_player
; -- as partidas registradas vão de 09/08/2021 a 06/01/2022

-- medalhas únicas
SELECT 
	COUNT (DISTINCT medalha_id) AS counter 
FROM tb_medalha
; -- 349