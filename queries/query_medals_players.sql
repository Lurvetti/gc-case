-- MEDALHA
WITH medals AS (
    SELECT
        *,
        CASE 
            WHEN 
                descricao_medalha LIKE "%BLACK DRAGONS%" OR
                descricao_medalha LIKE "%BOOM%" OR
                descricao_medalha LIKE "%BRAVOS%" OR
                descricao_medalha LIKE "%CRUZEIRO%" OR
                descricao_medalha LIKE "%DETONA%" OR
                descricao_medalha LIKE "%FURIA%" OR
                descricao_medalha LIKE "%FURIA%" OR
                descricao_medalha LIKE "%FURIOUS%" OR
                descricao_medalha LIKE "%HAVAN%" OR
                descricao_medalha LIKE "%INTZ%" OR
                descricao_medalha LIKE "%ISURUS%" OR
                descricao_medalha LIKE "%JAGUARES%" OR
                descricao_medalha LIKE "%META GAMING%" OR
                descricao_medalha LIKE "%MIBR%" OR
                descricao_medalha LIKE "%ORGLESS%" OR
                descricao_medalha LIKE "%PAIN%" OR
                descricao_medalha LIKE "%PAQUETA%" OR
                descricao_medalha LIKE "%RED CANIDS%" OR
                descricao_medalha LIKE "%SANTOS%" OR
                descricao_medalha LIKE "%SEVERE%" OR
                descricao_medalha LIKE "%SHARKS%" OR
                descricao_medalha LIKE "%SWS%" OR
                descricao_medalha LIKE "%VIVO KEYD%" OR
                descricao_medalha LIKE "%W7M%"
            THEN "team"

            WHEN descricao_medalha LIKE "%Gamers Club Partner%" THEN "partner"
            WHEN LOWER(descricao_medalha) LIKE "%membro%" THEN "member"	
            WHEN 
                LOWER(descricao_medalha) LIKE "%participei%" OR  
                LOWER(descricao_medalha) LIKE "%competidor%"
            THEN "participant"

			WHEN LOWER(descricao_medalha) LIKE "%lembran%" THEN "lembranca"
			WHEN LOWER(descricao_medalha) LIKE "%pedra%" THEN "pedra"

			WHEN LOWER(descricao_medalha) = "bom comportamento" THEN "bom_comportamento"
			WHEN 
                LOWER(descricao_medalha) LIKE "%conquistou 10%" OR  
                LOWER(descricao_medalha) LIKE "%conquistou 25%"
            THEN "inicio_10_25"

			WHEN LOWER(descricao_medalha) = "prime" THEN "prime"
			WHEN LOWER(descricao_medalha) = "rookie" THEN "rookie"
			WHEN LOWER(descricao_medalha) = "aspirante" THEN "aspirante"
			WHEN LOWER(descricao_medalha) = "elite" THEN "elite"

            ELSE "other" END AS classe

    FROM tb_medalha
),

temp2 AS (
SELECT 
	t1.*,
	medals.descricao_medalha,
	medals.tipo_medalha,
	medals.classe
FROM tb_players_medalha AS t1
LEFT JOIN medals
	ON t1.medalha_id = medals.medalha_id
)


SELECT 
	player_id,
	--COUNT (id_registro) AS total_medals,
	COUNT (DISTINCT descricao_medalha) AS distinct_medals,

	SUM(CASE WHEN classe = "team" THEN 1 ELSE 0 END) AS n_team_medal,
	SUM(CASE WHEN classe = "partner" THEN 1 ELSE 0 END) AS n_partner_medal,
	SUM(CASE WHEN classe = "member" THEN 1 ELSE 0 END) AS n_member_medal,
	SUM(CASE WHEN classe = "participant" THEN 1 ELSE 0 END) AS n_participant_medal,
	SUM(CASE WHEN classe = "lembranca" THEN 1 ELSE 0 END) AS n_lembranca_medal,
	SUM(CASE WHEN classe = "pedra" THEN 1 ELSE 0 END) AS n_pedra_medal,
	SUM(CASE WHEN classe = "bom_comportamento" THEN 1 ELSE 0 END) AS n_bom_comportamento_medal,
	SUM(CASE WHEN classe = "inicio_10_25" THEN 1 ELSE 0 END) AS n_inicio_10_25_medal,
	SUM(CASE WHEN classe = "prime" THEN 1 ELSE 0 END) AS n_prime_medal,
	SUM(CASE WHEN classe = "rookie" THEN 1 ELSE 0 END) AS n_rookie_medal,
	SUM(CASE WHEN classe = "aspirante" THEN 1 ELSE 0 END) AS n_aspirante_medal,
	SUM(CASE WHEN classe = "elite" THEN 1 ELSE 0 END) AS n_elite_medal,
	SUM(CASE WHEN classe = "other" THEN 1 ELSE 0 END) AS n_other_medal,
	SUM (ativo) AS active_medals

FROM temp2
GROUP BY player_id
