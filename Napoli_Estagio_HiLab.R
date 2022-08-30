# Projeto HILAB - Estágio - Rodrigo Napoli
#ETAPA 1 - Agrupando 3 data sets de formatos diferenetes em um único arquivo

#Instalando e carregando os pacotes
pacotes <- c("rjson",
              "RSQLite", 
              "DBI")
if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}

##################################
#Parte 1 - FORMANDO O DATASET
#Parte 1.1 - Arquivo JSON
json <- fromJSON(file="parte1.json")
json_df <- data.frame(do.call(rbind.data.frame, json))
str(json_df)

#Parte 1.2 - Arquivo CSV
csv_df <- read.csv(file="parte2.csv")
str (csv_df)

#Parte 1.3 - Arquivo SQLITE
#Carregando os dados como um data base
caminho <- "parte3.sqlite"
conexao <- dbConnect(SQLite(), 
                 dbname = caminho )
dbListTables(conexao)
sqlite <- dbReadTable(conexao, 
                      name = "parte3" )
dbDisconnect(conexao) #desconectar do banco de dados do SQLite
str(sqlite)

#selecionando somente os dados do "tipo_dado = 1"
unique(sqlite$tipo_dado) #para saber quais valores únicos existem na variável "tipo_dado"
table(sqlite$tipo_dado) #para saber a frequencia de valores por tipo de dado
sqlite_df <- sqlite[!(sqlite$tipo_dado=="2"),] #apagando as linhas com valor 2
table(sqlite_df$tipo_dado) #para garantir que não há outros valores fora o 1

#apagando a variável"tipo_dado"
sqlite_df$tipo_dado = NULL
str(sqlite)

#Parte 2 - Juntando e exportando todos os data sets em um só
dataset <- rbind(json_df, csv_df, sqlite_df)
str(dataset)
dataset$n <- as.integer(dataset$n) #mudando o tipo da variável "n" de "num" para "integer"

write.csv(dataset, "dataset_hilab.csv") #gerar um arquivo CSV e gravar no diretório

