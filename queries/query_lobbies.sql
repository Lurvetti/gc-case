SELECT
	player_id,

	-- general
	COUNT (DISTINCT idlobby_game) AS distinct_idlobby_game,
	SUM (winner) AS n_victories,
	SUM (winner)*1.0 / COUNT (DISTINCT idlobby_game) AS win_rate,

	MIN(strftime("%Y-%m-%d", created_at)) AS date_first_lobby,
	MAX(strftime("%Y-%m-%d", created_at)) AS date_last_lobby,
	CAST (julianday('now') - julianday(MAX(created_at)) AS INT) AS days_since_last_game,
	CAST (julianday(MAX(created_at)) - julianday(MIN(created_at)) AS INT) AS days_playing,
    
	-- maps
	SUM (CASE WHEN map_name = "de_dust2" THEN 1 ELSE 0 END) AS n_de_dust2,
	SUM (CASE WHEN map_name = "de_dust2" AND winner = 1 THEN 1 ELSE 0 END) AS wins_de_dust2,
	SUM (CASE WHEN map_name = "de_dust2" AND winner = 1 THEN 1 ELSE 0 END)*1.0 / SUM (CASE WHEN map_name = "de_dust2" THEN 1 ELSE 0 END) AS wr_de_dust2,

	SUM (CASE WHEN map_name = "de_inferno" THEN 1 ELSE 0 END) AS n_de_inferno, 
	SUM (CASE WHEN map_name = "de_inferno" AND winner = 1 THEN 1 ELSE 0 END) AS wins_de_inferno,
	SUM (CASE WHEN map_name = "de_inferno" AND winner = 1 THEN 1 ELSE 0 END)*1.0 / SUM (CASE WHEN map_name = "de_inferno" THEN 1 ELSE 0 END) AS wr_de_inferno,

	SUM (CASE WHEN map_name = "de_train" THEN 1 ELSE 0 END) AS n_de_train, 
	SUM (CASE WHEN map_name = "de_train" AND winner = 1 THEN 1 ELSE 0 END) AS wins_de_train,
	SUM (CASE WHEN map_name = "de_train" AND winner = 1 THEN 1 ELSE 0 END)*1.0 / SUM (CASE WHEN map_name = "de_train" THEN 1 ELSE 0 END) AS wr_de_train,

	SUM (CASE WHEN map_name = "de_vertigo" THEN 1 ELSE 0 END) AS n_de_vertigo, 
	SUM (CASE WHEN map_name = "de_vertigo" AND winner = 1 THEN 1 ELSE 0 END) AS wins_de_vertigo,
	SUM (CASE WHEN map_name = "de_vertigo" AND winner = 1 THEN 1 ELSE 0 END)*1.0 / SUM (CASE WHEN map_name = "de_vertigo" THEN 1 ELSE 0 END) AS wr_de_vertigo,

	SUM (CASE WHEN map_name = "de_mirage" THEN 1 ELSE 0 END) AS n_de_mirage, 
	SUM (CASE WHEN map_name = "de_mirage" AND winner = 1 THEN 1 ELSE 0 END) AS wins_de_mirage,
	SUM (CASE WHEN map_name = "de_mirage" AND winner = 1 THEN 1 ELSE 0 END)*1.0 / SUM (CASE WHEN map_name = "de_mirage" THEN 1 ELSE 0 END) AS wr_de_mirage,

	SUM (CASE WHEN map_name = "de_overpass" THEN 1 ELSE 0 END) AS n_de_overpass, 
	SUM (CASE WHEN map_name = "de_overpass" AND winner = 1 THEN 1 ELSE 0 END) AS wins_de_overpass,
	SUM (CASE WHEN map_name = "de_overpass" AND winner = 1 THEN 1 ELSE 0 END)*1.0 / SUM (CASE WHEN map_name = "de_overpass" THEN 1 ELSE 0 END) AS wr_de_overpass,

	SUM (CASE WHEN map_name = "de_ancient" THEN 1 ELSE 0 END) AS n_de_ancient, 
	SUM (CASE WHEN map_name = "de_ancient" AND winner = 1 THEN 1 ELSE 0 END) AS wins_de_ancient,
	SUM (CASE WHEN map_name = "de_ancient" AND winner = 1 THEN 1 ELSE 0 END)*1.0 / SUM (CASE WHEN map_name = "de_ancient" THEN 1 ELSE 0 END) AS wr_de_ancient,

	SUM (CASE WHEN map_name = "de_nuke" THEN 1 ELSE 0 END) AS n_de_nuke, 
	SUM (CASE WHEN map_name = "de_nuke" AND winner = 1 THEN 1 ELSE 0 END) AS wins_de_nuke,
	SUM (CASE WHEN map_name = "de_nuke" AND winner = 1 THEN 1 ELSE 0 END)*1.0 / SUM (CASE WHEN map_name = "de_nuke" THEN 1 ELSE 0 END) AS wr_de_nuke,

	-- rounds
	SUM (rounds_played) AS sum_rounds_played,
	SUM (rounds_played)*1.0 / COUNT (DISTINCT idlobby_game) AS rounds_per_game,	

	-- level GC
	MIN(level) AS min_level,
	MAX(level) AS max_level,
    MAX(level)-MIN (level) AS var_level,
    
    MAX(level)-MIN (level) / (julianday(MAX(created_at))-julianday(MIN(created_at)) / 30) AS test,

	-- skill
	AVG (shots) AS avg_shots,
	AVG (hits) AS avg_hits,
	AVG (damage) AS avg_damage,
	AVG (clutch_won) AS avg_clutch_won

FROM tb_lobby_stats_player t1

GROUP BY t1.player_id
ORDER BY distinct_idlobby_game DESC