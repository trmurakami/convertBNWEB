SELECT
	ace.cod_acervo,
	ISNULL(fasc.fasciculos, '') as 'fasciculos'
FROM 
dbo.tbibace0 AS ace

LEFT JOIN (
	SELECT cod_fonte, STRING_AGG(CAST(CONCAT(REPLACE(REPLACE(cod_unidade,'1','BC'),'2','BIBCOREG'),'$b',REPLACE(REPLACE(cod_unidade,'1','BC'),'2','BIBCOREG'),'$d', CONVERT(varchar,dt_registro,23),'$p',item_fas.item_fas,'$h',ano,'  Ano ', fasc_ano,', v.',fasc_volume,', n.',fasc_numero,', ',fasc_data,'$u',anexos1.anexos,'$yPER','$z',item_fas.notas,'$3',titulo,'$7',REPLACE(REPLACE(REPLACE(item_fas.empresta,'0','2'),'1','0'),'2','1')) AS VARCHAR(MAX)), ';-;') as fasciculos
	FROM [bnweb2].[dbo].[tbibace0]
	LEFT JOIN (
		SELECT distinct cod_acervo as cod1, STRING_AGG(cod_item, '|') as item_fas, empresta, notas, dt_registro
		FROM [bnweb2].[dbo].[vbibite0]
		GROUP BY cod_acervo, empresta, notas, dt_registro
	) item_fas
	ON cod_acervo=item_fas.cod1
	LEFT JOIN (
	SELECT distinct cod_acervo as cod2, STRING_AGG(CONCAT('http://biblioteca.an.gov.br/bnweb/upload/',diretorio,'/',arquivo), ';-;') as anexos
	FROM [bnweb2].[dbo].[tbibane0]
	WHERE id_visual = '0'
	GROUP BY cod_acervo	
	) anexos1
	ON cod_acervo=anexos1.cod2
	GROUP BY cod_fonte
) fasc
ON ace.cod_acervo=fasc.cod_fonte

WHERE tipo = 'PER'