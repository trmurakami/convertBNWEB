SELECT
	ace.cod_acervo,
	ace.fasc_titulo,
	cla.classificacao,
	cla1.cod_acervo,
	cla1.titulo,
	cla1.ace_tipo,
	cla1.classificacao,
	CONCAT(cla1.titulo,'$w',cla1.cod_acervo) as fonte
FROM dbo.tbibace0 AS ace

LEFT JOIN (
	SELECT cod_acervo, STRING_AGG(classificacao, ';-;') as classificacao, STRING_AGG(cutter, ';-;') as cutter
	FROM [bnweb2].[dbo].[tbibcla0]
	GROUP BY cod_acervo
) cla
ON ace.cod_acervo=cla.cod_acervo

LEFT JOIN (
	SELECT
		ace.cod_acervo,
		ace.titulo,
		ace.tipo as ace_tipo,
		cla2.classificacao
	FROM dbo.tbibace0 AS ace

	LEFT JOIN (
		SELECT cod_acervo, STRING_AGG(classificacao, ';-;') as classificacao, STRING_AGG(cutter, ';-;') as cutter
		FROM [bnweb2].[dbo].[tbibcla0]
		GROUP BY cod_acervo
	) cla2
	ON ace.cod_acervo=cla2.cod_acervo
	WHERE ace.tipo = 'LIV' OR ace.tipo = 'LRA'

) cla1
ON cla.classificacao=cla1.classificacao

WHERE tipo = 'PEV' OR
tipo = 'PLV' OR
tipo = 'PTC' OR
tipo = 'PLC'