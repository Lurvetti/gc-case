-- PLAYERS

SELECT
    player_id,

    -- social media
    CASE WHEN tem_facebook = 1 THEN TRUE ELSE FALSE END AS has_facebook,
    CASE WHEN tem_twitch = 1 THEN TRUE ELSE FALSE END AS has_twitch,
    CASE WHEN tem_twitter = 1 THEN TRUE ELSE FALSE END AS has_twitter,
    
    CASE WHEN 
        tem_facebook = 1 OR
        tem_twitch = 1 OR
        tem_twitter = 1
    THEN 1 ELSE 0 END has_social,

    CASE WHEN tem_twitch = 1 AND tem_twitter = 1 THEN TRUE ELSE FALSE END AS has_social_engaged,
    
    -- age & base
    strftime("%Y-%m-%d", data_cadastro) AS date_register,
    strftime("%Y-%m", data_cadastro) AS date_register_ym,
    CAST (julianday('now') - julianday(data_cadastro) AS INT) AS base_time_days,
    CAST ((julianday('now') - julianday(data_cadastro)) / 30 AS INT) AS base_time_months,

    strftime("%Y-%m-%d", data_aniversario) AS date_birthday,
    CAST ((julianday('now') - julianday(data_aniversario)) / 365 AS INT) AS age,
    
    -- country
    pais AS country,
    CASE WHEN pais = 'br' THEN TRUE ELSE FALSE END AS flag_br

FROM tb_players