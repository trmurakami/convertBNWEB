select tip.nome AS tipo_nome, count(*) as registros
FROM 
dbo.tbibace0 AS ace 
LEFT OUTER JOIN dbo.tbibtip0 AS tip ON ace.tipo = tip.sigla
GROUP BY tip.nome
ORDER BY tip.nome
