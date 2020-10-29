SELECT acervo.cod_acervo, items.* FROM [bnweb2].[dbo].[tbibace0] acervo
INNER JOIN 
(SELECT [cod_item]
      ,item.[cod_acervo] as cod_acervo_fasciculos
	  ,ace.tipo
	  ,ace.cod_fonte
	  ,REPLACE(CONCAT('http://biblioteca.an.gov.br/bnweb/upload/',anexo.diretorio,'/',anexo.arquivo),'\','/') as caminho_completo
	  ,anexo.arquivo
	  ,ace.titulo
      ,item.[cod_unidade]
      ,[dt_registro]
      ,[tomo]
      ,item.[volume]
      ,[empresta]
      ,item.[visivel]
      ,[patrimonio]
      ,item.[notas]
      ,[baixado]
      ,[dt_baixa]
      ,[exemp]
      ,item.[cod_matricula]
      ,[inventariando]
      ,[falha]
      ,[duplicata]
      ,[encadernacao]
      ,item.[cod_old]
      ,item.[dt_inc]
      ,item.[dt_alt]
      ,[cod_operador_baixa]
      ,[indexado]
      ,[tp_aqui]
      ,[cod_aqui]
      ,[cod_tipo_prospecto]
      ,[emissao_serie_prospecto]
      ,[suporte_prospecto]
      ,[motivo_baixa]
      ,[enviado_alerta_fas]
      ,[envia_alerta_fas]
      ,item.[cod_sysbibli]
      ,[cod_aqui_nfiscal]
      ,item.[situacao]
      ,item.[cod_matricula_alt]
  FROM [bnweb2].[dbo].[tbibite0] item
  INNER JOIN [bnweb2].[dbo].[tbibace0] ace on ace.cod_acervo = item.cod_acervo
  INNER JOIN [bnweb2].[dbo].[tbibane0] anexo on ace.cod_acervo = anexo.cod_acervo
  WHERE id_visual = '0') items on items.cod_fonte = acervo.cod_acervo
  ORDER BY 3