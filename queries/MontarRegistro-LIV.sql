SELECT 
	ace.cod_acervo,
	ace.cod_acervo as '001',
	idiom.idiomas as '008-35-37',
	CONCAT ('(BNWEB)',ace.cod_acervo) as '035z',
	aut.autores as '100',
	ace.titulo_artigo as '2452', 
	ace.titulo as '245a', 
	ace.edicao as '250a', 
	ace.local as '260a',
	edit.editores as '260b',
	ace.data_pub as '260c', 
	ace.colacao as '300a', 
	ace.serie as '490a', 
	ace.notas as '500a',
	ass.assuntos as '650a',
	links.links as '856'
FROM 
dbo.tbibace0 AS ace
LEFT JOIN
(
    SELECT codigo, STRING_AGG(nome, '|') as assuntos
	FROM [bnweb].[dbo].[vbibapiace0_assuntos]
	GROUP BY codigo
) ass
ON ace.cod_acervo=ass.codigo
LEFT JOIN
(
	SELECT codigo, STRING_AGG(CONCAT(nome, ';',tipo,';', qualificacao), '|') as autores
	FROM [bnweb].[dbo].[vbibapiace0_autores]
	GROUP BY codigo
) aut
ON ace.cod_acervo=aut.codigo
LEFT JOIN
(
	SELECT codigo, STRING_AGG(nome, '|') as editores
	FROM [bnweb].[dbo].[vbibapiace0_editores]
	GROUP BY codigo
) edit
ON ace.cod_acervo=edit.codigo
LEFT JOIN
(
	SELECT codigo, STRING_AGG(nome, '|') as idiomas
	FROM [bnweb].[dbo].[vbibapiace0_idiomas]
	GROUP BY codigo
) idiom
ON ace.cod_acervo=idiom.codigo
LEFT JOIN
(
	SELECT codigo, STRING_AGG(CONCAT(url, ';;',descricao), '|') as links
	FROM [bnweb].[dbo].[vbibapiace0_links]
	GROUP BY codigo
) links
ON ace.cod_acervo=links.codigo
WHERE tipo = 'LIV'