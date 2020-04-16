# convertBNWEB
Códigos e conversor do BNWEB para MARC21

# Requirements 

    Librecat/Catmandu: https://librecat.org/Catmandu/#installation

# SQL 

    Rodar as queries da pasta queries

# Converter para MARC21

    sed -i 's/NULL//g' AN-LIV.tsv
    
    catmandu convert CSV --sep_char '\t' --fix fixes/fixesLIV.txt to MARC < data/AN-LIV.tsv > data/export.mrc

