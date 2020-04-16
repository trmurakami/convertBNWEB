SELECT 
	ace.cod_acervo,
	ace.visivel as 'visivel',
	ace.reserva as 'reserva',
	ace.nacional as 'nacional',
	ace.cod_unidade as 'cod_unidade',
	ace.cod_acervo as '001',
	ISNULL(idiom.idiomas, '') as '008-35-37',
	ISNULL(cla.classificacao, '') as '090a',
	ISNULL(cla.cutter, '') as '090b',
	ISNULL(ace.is_barras, '') as '020a',
	ISNULL(ace.is_cod, '') as '020aOld',
	CONCAT ('(BNWEB)',ace.cod_acervo) as '035z',
	ISNULL(aut.autores, '') as '100',
	ISNULL(LEN(ace.titulo_artigo), '0') as '2452',
	ISNULL(ace.titulo, '') as 'titulo',
	CONCAT (ace.titulo_artigo, ace.titulo_inicio) as '245a',
	ISNULL(ace.titulo_subtit, '') as '245b', 
	ISNULL(ace.edicao, '') as '250a', 
	ISNULL(ace.local, '') as '260a',
	ISNULL(edit.editores, '') as '260b',
	ISNULL(ace.data_pub, '') as '260c', 
	ISNULL(ace.colacao, '') as '300a',
	ISNULL(ace.anexo, '') as '300e',
	ISNULL(CONCAT (ace.serie_art,' ', ace.serie), '') as '490a',
	ISNULL(ace.volume_qta, '') as '490v',
	ISNULL(ace.notas, '') as '500a',
	ISNULL(ace.resumo, '') as '520a',
	ISNULL(ass.assuntos, '') as '650a',
	ISNULL(ace.titulo_original, '') as '765t',
	ISNULL(links.links, '') as '856'
FROM 
dbo.tbibace0 AS ace
LEFT JOIN
(
    SELECT codigo, STRING_AGG(nome, '--') as assuntos
	FROM [bnweb].[dbo].[vbibapiace0_assuntos]
	GROUP BY codigo
) ass
ON ace.cod_acervo=ass.codigo
LEFT JOIN
(
	SELECT codigo, STRING_AGG(CONCAT(nome, '--',tipo,'--', qualificacao), ';-;') as autores
	FROM [bnweb].[dbo].[vbibapiace0_autores]
	GROUP BY codigo
) aut
ON ace.cod_acervo=aut.codigo
LEFT JOIN
(
	SELECT codigo, STRING_AGG(nome, '--') as editores
	FROM [bnweb].[dbo].[vbibapiace0_editores]
	GROUP BY codigo
) edit
ON ace.cod_acervo=edit.codigo
LEFT JOIN
(
	SELECT codigo, STRING_AGG(nome, '--') as idiomas
	FROM [bnweb].[dbo].[vbibapiace0_idiomas]
	GROUP BY codigo
) idiom
ON ace.cod_acervo=idiom.codigo
LEFT JOIN
(
	SELECT codigo, STRING_AGG(CONCAT(url, '--',descricao), ';-;') as links
	FROM [bnweb].[dbo].[vbibapiace0_links]
	GROUP BY codigo
) links
ON ace.cod_acervo=links.codigo
LEFT JOIN bnweb.dbo.tbibcla0 cla ON ace.cod_acervo=cla.cod_acervo
WHERE tipo = 'LIV'