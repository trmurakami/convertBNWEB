# convertBNWEB
Códigos e conversor do BNWEB para MARC21

# Requirements 

    Librecat/Catmandu: https://librecat.org/Catmandu/#installation

# SQL 

    Rodar as queries da pasta queries

# OpenRefine

    Subir no OpenRefine. Rodar os comandos do openrefine e exportar em TSV

    Tips:
    Rodar no itens: replace(value,"$y","$y"+cells['tipo'].value)
    Rodar nos fascículos: replace(value,"$y","$o"+cells['090a'].value+"$y")
    Rodar nos assuntos: cell.cross('AN Assuntos Editado','nome').cells['nome_novo'].value[0]
    Rodar nos autores: cell.cross('AN AUTORES BNWEB','nome_completo_caps').cells['nome_completo'].value[0]
    Rodar no cod_acervo: cell.cross('TODOS OS ASSUNTOS','cod_acervo').cells['650a 2'].value[0]

    Copiar valores faltando: cells["650a"].value

    Criar campo fonte_completa: cells['fonte_nome'].value + '$hv.' + cells['fasc_volumes'].value +'n.' + cells['fasc_numero'].value + '$g' + cells['fasc_data'].value 


# Converter para MARC21

    UPDATE dbo.tbibace0 SET notas = LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(notas, CHAR(9), ''), CHAR(10), ''), CHAR(13), '')))
    
    catmandu convert CSV --sep_char '\t' --fix fixes/fixesLIV.txt to MARC < data/AN-LIV.tsv > data/export.mrc

# Notepad ++

    Corrigir o 245 subcampo 2
    Pesquisar por: =200  \\\\\$a(.)\r\n=245  (.)(.)
    Substituir por: =245  \2\1

    Campo notas
    Pesquisar por: ^(=500.*?)\|(.*)$
    Subtituir por: \1\r\n=500  \\\\\$a\2

    Pesquisar por: ^(=520.*?)\|(.*)$
    Subtituir por: \1\r\n=520  \\\\\$a\2

    Excluir 774 vazio
    Pesquisar por: \r\n=774  0\\\$t\$w.*\r\n
    Substituir por: \r\n

    Corrigir códigos de barras
    Pesquisar por: =952  \\\\\$p(\d)\$
    Substituir por: =952  \\\\\$p00000\1\$
    
    No PER_EVE
    Pesquisar por: =952  \\\\\$aBC\$bBC\$p(\d\d\d\d\d)\$
    Substituir por: =952  \\\\\$aBC\$bBC\$p0\1\$
    

    Erro em exemplares com mais de um arquivo digital
    http://biblioteca.an.gov.br/bnweb/upload/pasta2\acervo18092/18092_1129.pdf

    Remover linhas duplicadas:
    Pesquisar por: ^(.*)(\r?\n\1)+$
    Substitutir por: \1

    Dois pontos nos subtitulos
    Pesquisar por: ^(=245.*?)\|\|(.*)$
    Substituir por: \1\:\2

    Data
    Pesquisar por: (=008  )(\d\d\d\d\d\d)(.*?)\r\n(=009  )(\d\d\d\d\d\d)
    Substituir por: \1\5\3

# Queries por campo

    Selecionar linhas de resumo com quebra de linha: 
        SELECT [cod_acervo], LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(resumo, CHAR(9), ''), CHAR(10), '|'), CHAR(13), '|'))) as resumo FROM [bnweb2].[dbo].[tbibace0] WHERE resumo LIKE '%' + CHAR(13)+CHAR(10) + '%'
    Selecionar subtitulo com dois pontos: 
        SELECT [cod_acervo], titulo_subtit FROM [bnweb2].[dbo].[tbibace0] WHERE titulo_subtit LIKE '%:%'
