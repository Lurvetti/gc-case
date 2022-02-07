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
)

SELECT 
	t1.*,
	medals.descricao_medalha,
	medals.tipo_medalha,
	medals.classe
FROM tb_players_medalha AS t1
LEFT JOIN medals
	ON t1.medalha_id = medals.medalha_id
