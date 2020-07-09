SELECT
	ace.cod_acervo,
	ace.tipo,
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
	ISNULL(orientador.orientador, '') as 'orientador',
	ISNULL(LEN(ace.titulo_artigo), '0') as '2452',
	ISNULL(ace.titulo, '') as 'titulo',
	CONCAT (ace.titulo_artigo, ace.titulo_inicio) as '245a',
	ISNULL(ace.titulo_subtit, '') as '245b', 
	ISNULL(ace.edicao, '') as '250a', 
	ISNULL(ace.local, '') as '260a',
	ISNULL(edit.editores, '') as '260b',
	ISNULL(ace.data_pub, '') as '260c', 
	ISNULL(ace.colacao, '') as '300',
	ISNULL(ace.anexo, '') as '300e',
	ISNULL(CONCAT (ace.serie_art,' ', ace.serie), '') as '490a',
	ISNULL(ace.volume_qta, '') as '490v',
	ISNULL(REPLACE(ace.notas, char(9), ''),'') as '500a',
	ISNULL(REPLACE(ace.resumo, char(9), ''), '') as '520a',
	ISNULL(ass.assuntos, '') as '650a',
	ISNULL(ace.titulo_original, '') as '765t',
	ISNULL(links.links, '') as '856',
	ISNULL(REPLACE(anexos.anexos,'\','/'), '') as 'anexos',
	ISNULL(partes.partes, '') as 'partes',
	ISNULL(volumes.volumes, '') as 'volumes',
	ISNULL(item.items, '') as 'items',
	ISNULL(holdings.holdings, '') as 'holdings',
	ISNULL(acon.acon, '') as 'areacon_cod',
	ISNULL(acon_desc.sigla, '') as 'areacon_sigla',
	ISNULL(acon_desc.nome, '') as 'areacon_nome',
	ISNULL(fasc.fasciculos, '') as 'fasciculos',
	ISNULL(capitulo.capitulos, '') as 'capitulos'
FROM 
dbo.tbibace0 AS ace

LEFT JOIN
(
	SELECT cod_autor as codigo_orientador, tit1 as orientador
	FROM [bnweb2].[dbo].[tbibaut0] 
) orientador
ON ace.cod_orientador=orientador.codigo_orientador

LEFT JOIN
(
	SELECT codigo, STRING_AGG(CONVERT(nvarchar(max), nome), ';-;') AS assuntos
	FROM (
		SELECT tbass.cod_acervo as codigo, tbass.cod_assunto, tbass.posicao, ass.nome as nome
		FROM [bnweb2].[dbo].[tbibxas0] tbass
		LEFT JOIN [bnweb2].[dbo].[tbibass0] ass ON tbass.cod_assunto=ass.cod_assunto
		) as Assuntos
	GROUP BY codigo
) ass
ON ace.cod_acervo=ass.codigo

LEFT JOIN
(
	SELECT codigo, STRING_AGG(CONVERT(nvarchar(max), CONCAT(sobrenome,'|', nome, '--',tipo,'--',qualificador, '--', primeiro, '--', posicao)), ';-;') AS autores
	FROM (
		SELECT tbaut.cod_acervo as codigo, tbaut.cod_autor, aut.nome_sobre as sobrenome, ISNULL(aut.nome_inicio,'') as nome, qua.nome as qualificador, aut.tipo as tipo, tbaut.primeiro as primeiro, tbaut.posicao as posicao
		FROM [bnweb2].[dbo].[tbibxau0] tbaut
		LEFT JOIN [bnweb2].[dbo].[tbibaut0] aut ON tbaut.cod_autor=aut.cod_autor
		LEFT JOIN [bnweb2].[dbo].[tbibqua0] qua ON tbaut.cod_qualif=qua.cod_qualif
		) as Autores
	GROUP BY codigo
) aut
ON ace.cod_acervo=aut.codigo

LEFT JOIN
(
	SELECT codigo, STRING_AGG(nome, '--') as editores
	FROM [bnweb2].[dbo].[vbibapiace0_editores]
	GROUP BY codigo
) edit
ON ace.cod_acervo=edit.codigo

LEFT JOIN
(
	SELECT codigo, STRING_AGG(nome, '--') as idiomas
	FROM [bnweb2].[dbo].[vbibapiace0_idiomas]
	GROUP BY codigo
) idiom
ON ace.cod_acervo=idiom.codigo

LEFT JOIN
(
	SELECT codigo, STRING_AGG(CONCAT(url, '--',descricao), ';-;') as links
	FROM [bnweb2].[dbo].[vbibapiace0_links]
	GROUP BY codigo
) links
ON ace.cod_acervo=links.codigo

LEFT JOIN (
	SELECT cod_acervo, STRING_AGG(classificacao, ';-;') as classificacao, STRING_AGG(cutter, ';-;') as cutter
	FROM [bnweb2].[dbo].[tbibcla0]
	GROUP BY cod_acervo
) cla
ON ace.cod_acervo=cla.cod_acervo

LEFT JOIN
(
	SELECT codigo, STRING_AGG(CAST(titulo as varchar(max)), '--') as partes
	FROM [bnweb2].[dbo].[vbibapiace0_partes]
	GROUP BY codigo
) partes
ON ace.cod_acervo=partes.codigo

LEFT JOIN
(
	SELECT codigo, STRING_AGG(CAST(volume as varchar(max)), '--') as volumes
	FROM [bnweb2].[dbo].[vbibapiace0_volumes]
	GROUP BY codigo
) volumes
ON ace.cod_acervo=volumes.codigo

LEFT JOIN (
	SELECT cod_acervo, STRING_AGG(CONCAT(cod_item, '$a',sigla_unidade,'$b',sigla_unidade, '$d', CONVERT(varchar,dt_inc,23),'$e',TRIM(str_tp_aqui),'$h',TRIM(ISNULL(volume,'')),volume_qta,'$i',patrimonio,cod_old,'$o',classificacao,' ',cutter,' ',complemento,' ',data_pub,' ',edicao,'$t',exemp,'$y','$0',baixado, '$7', REPLACE(REPLACE(REPLACE(empresta,'0','2'),'1','0'),'2','1')), ';-;') as items
	FROM [bnweb2].[dbo].[vbibite0]
	GROUP BY cod_acervo
) item
ON ace.cod_acervo=item.cod_acervo

LEFT JOIN (
	SELECT distinct cod_acervo, STRING_AGG(CONCAT('$a',nome_unidade,'$f',classificacao,'$g',sigla_unidade), ';-;') as holdings
	FROM [bnweb2].[dbo].[vbibite0]
	GROUP BY cod_acervo
) holdings
ON ace.cod_acervo=holdings.cod_acervo

LEFT JOIN (
	SELECT cod_acervo, STRING_AGG(cod_acon, '') as acon
	FROM [bnweb2].[dbo].[tbibxaa0]
	GROUP BY cod_acervo
) acon
ON ace.cod_acervo=acon.cod_acervo
LEFT JOIN tbibaco0 AS acon_desc ON acon_desc.cod_acon=acon.acon

LEFT JOIN (
	SELECT distinct cod_acervo, STRING_AGG(CONCAT('http://biblioteca.an.gov.br/bnweb/upload/',diretorio,'/',arquivo), ';-;') as anexos
	FROM [bnweb2].[dbo].[tbibane0]
	GROUP BY cod_acervo
) anexos
ON ace.cod_acervo=anexos.cod_acervo

LEFT JOIN (
	SELECT cod_fonte, STRING_AGG(CAST(CONCAT('$hv.',fasc_volume,',n.',fasc_numero,'$g',fasc_data) AS VARCHAR(MAX)), ';-;') as fasciculos
	FROM [bnweb2].[dbo].[tbibace0]
	GROUP BY cod_fonte
) fasc
ON ace.cod_acervo=fasc.cod_fonte

LEFT JOIN (
	SELECT cod_fonte, STRING_AGG(CAST(CONCAT(titulo,'$w',cod_fonte) AS VARCHAR(MAX)), ';-;') as capitulos
	FROM [bnweb2].[dbo].[tbibace0]
 	GROUP BY cod_fonte
) capitulo
ON ace.cod_acervo=capitulo.cod_fonte

WHERE 
tipo = 'LIV' OR 
tipo = 'LRA' OR 
tipo = 'FOL' OR 
tipo = 'CAT' OR 
tipo = 'MON' OR
tipo = 'RFR' OR
tipo = 'MAN' OR
tipo = 'DVD' OR
tipo = 'CDS' OR
tipo = 'CDR' OR
tipo = 'APO' OR
tipo = 'OBJ' OR
tipo = 'LIT' OR
tipo = 'PRT' OR
tipo = 'RET' OR
tipo = 'PAL' OR
tipo = 'NTC' OR
tipo = 'TES' OR
tipo = 'ENC' OR
tipo = 'REV'