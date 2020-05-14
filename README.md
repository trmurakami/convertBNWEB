# convertBNWEB
Códigos e conversor do BNWEB para MARC21

# Requirements 

    Librecat/Catmandu: https://librecat.org/Catmandu/#installation

# SQL 

    Rodar as queries da pasta queries

# OpenRefime

    Subir no OpenRefine. Rodar os comandos do openrefine e exportar em TSV

    Tips:
    Rodar no itens: replace(value,"$y","$y"+cells['tipo'].value)
    Rodar nos assuntos: cell.cross('AN Assuntos Editado','nome').cells['nome_novo'].value[0]
    Rodar nos autores: cell.cross('AN AUTORES BNWEB','nome_completo_caps').cells['nome_completo'].value[0]

    Copiar valores faltando: cells["650a"].value


# Converter para MARC21

    UPDATE dbo.tbibace0 SET notas = LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(notas, CHAR(9), ''), CHAR(10), ''), CHAR(13), '')))
    
    catmandu convert CSV --sep_char '\t' --fix fixes/fixesLIV.txt to MARC < data/AN-LIV.tsv > data/export.mrc