# Projeto HILAB - Estágio - Rodrigo Napoli
#ETAPA 2 - Respondendo as perguntas do teste estágio análise de dados

#Instalando e carregando os pacotes
pacotes2 <- c("dplyr",
              "ggplot2",
              "writexl")
if(sum(as.numeric(!pacotes2 %in% installed.packages())) != 0){
  instalador <- pacotes2[!pacotes2 %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes2, require, character = T) 
} else {
  sapply(pacotes2, require, character = T) 
}

#Definindo o diretório dos dados
setwd("/Users/rodrigonapoli/Documents/Cientista de dados/Estágio Hilab/testes/analise")
dataset <- read.csv(file="dataset_hilab.csv")
dataset$X <- NULL

#Pergunta 1
p1 <- dataset[!(dataset$year<"2000"),] #apagando as linhas com anos menores do que 2000
summary(p1)

nomes_unicos <- p1 %>%
  group_by(year) %>%
  summarise(count = n_distinct(name))
nomes_unicos 
nomes_unicos_amp <- max(nomes_unicos$count) - min(nomes_unicos$count)
nomes_unicos_cv <- sd(nomes_unicos$count)/mean(nomes_unicos$count)*100  
write_xlsx(nomes_unicos, 'p1_nomes_unicos.xlsx',
           col_names = TRUE,
           format_headers = TRUE)
x <- nomes_unicos$count/1000
nomes_unicos$count_mil <- x

#gráfico
ggplot(data=nomes_unicos, aes(x=year, y=count_mil)) +
  geom_line()+
  ggtitle("Nomes únicos após o ano 2000") +
  ylab("Número de nomes únicos (*1000)") +
  xlab("Ano") +
  theme(panel.background = element_rect(fill='transparent'),
        plot.title = element_text(size=14),
        axis.line = element_line(color="black", size = 0.8),
        axis.title = element_text(size=12),
        axis.text = element_text(size=12)
        )


#Pergunta 2
p2 <- aggregate(n ~ year, dataset, sum)
p2
p2_result <- summary(p2$n)
p2_result
p2_cv <- sd(p2$n) / mean (p2$n) * 100
p2_cv <- round(p2_cv, digits=2)
p2_cv
# A média anual da contagem de bebês entre os anos de 1880 e 2017 é 2.522.612, 
# já a mediana é de 3.037.679.
# Uma vez que há grande variação de dados (coeficiente de variação = 54,51%),
# a medida mais apropriada é a mediana, uma vez que esta não é afetada por valores 
# extremos - caso da média. 
# Desta forma a interpretação seria que em 50% dos anos estudados houveram 3.037.679 
# nasciementos ou menos.
# Na verdade é melhor forma de descrever este conjunto
# de dados seria através de um quadro de distribuição de frequencias

#INSIGHT em relacão à pergunta 2
x <- p2$n/1000
p2$n_mil <- x
options (scipen = 999)
plot(x = p2$year, y=p2$n_mil,
     main = "Número de nascimentos por ano",
     xlab = "Ano",
     ylab = "Número de nascimentos (*1000)"
     )


ggplot(data=p2, aes(x=year, y=n_mil)) +
  geom_line()+
  geom_smooth(method=loess, se = FALSE, col="blue", size=0.6)+
  ggtitle("Número de nascimentos por ano") +
  ylab("Número de nascimentos (*1000)") +
  xlab("Ano") +
  theme(panel.background = element_rect(fill='transparent'),
        plot.title = element_text(size=14),
        axis.line = element_line(color="black", size = 0.8),
        axis.title = element_text(size=12),
        axis.text = element_text(size=12)
  )

# O gráfico de dispersão evidencia de forma clara o aumento no número total de nascimentos ao longo
# dos anos. Este crescimento é esperado conforme as condições econômicas, sanitárias e da medicina 
# melhoram. Após 1960 observa-se uma diminuição (posterior aos baby boomer pós 2a grande guerra - 1952),
# e um certo grau de estabilização dado o patamar de desenvolvimento dos EUA. 

# Abaixo é possivel observar
# com mais detalhes o processo entre 1950 e 1980.

p2_cut <- dataset[(dataset$year>="1950" & dataset$year<="1980"),] #apagando as linhas com anos menores do que 1950 e maiors do que 1980
p2_cut <- aggregate(n ~ year, p2_cut, sum)
summary (p2_cut)
plot(x = p2_cut$year, y=p2_cut$n,
     main = "Número de nascimentos por ano",
     xlab = "Ano",
     ylab = "Número de nascimentos"
) 

p2[which.max(p2$n),]
p2[which.min(p2$n),]
# Interessante observar que o ano de maior nascimento foi 1957 (4.200.007) e o ano 
# com menor nascimentos foi 1881 (192.696).



# Pergunta 3
p3 <- dataset[(dataset$year=="1997"),] #apagando as linhas com anos diferentes de 1997
summary(p3)
p3_mean <- mean(p3$n)
p3_sd <- sd(p3$n)
sd(p3$n)/mean(p3$n) *100
p3_sum <- sum(p3$n)
p3_sum

# Os valores calculados para média (134,40) e desvio padrão (1024,32) para bebês
# nascidos em 1997 não são cálculos que fazem muito sentido uma vez que o que estes
# valores estão dizendo é que há em torno de 134 crianças nascidas em 1997 de cada
# nome distinto (coum um dp de 1024, coeficiente de variação de 762%!!!). 
# Aqui o valor que me parece mais interessante é o valor total do número de 
# nascimentos para este ano = 3.624.799

# Pergunta 4
p4 <- dataset[(dataset$year=="2002"),] #apagando as linhas com anos diferentes de 2002
summary(p4)
p4_sum <- sum(p4$n)
p4_sum
p4_sex <- aggregate(n ~ sex, p4, sum)
p4_sex$prop <- with(p4_sex, n/p4_sum*100)
p4_sex$prop <- round(p4_sex$prop, digits=2)
p4_sex

write_xlsx(p4_sex, 'p4_sexos.xlsx',
           col_names = TRUE,
           format_headers = TRUE)

# Em 2002 nasceram 3.736.042 crianças, sendo 1.940.301 do sexo masculino (51,93%) e 1.795.741 do sexo feminino (48,07%)


ggplot(p4_sex, aes(x=sex, y=prop)) + 
  geom_bar(stat = "identity", width=0.5, fill = "blue")+
  ggtitle("Frequência de sexos no ano 2002") +
  ylab("Número de nascimento (%)") +
  xlab("Sexo") +
  scale_x_discrete(labels=c("F"="Feminino", "M"="Masculino"))+
  theme(panel.background = element_rect(fill='transparent'),
        plot.title = element_text(size=14),
        axis.line = element_line(color="black", size = 0.8),
        axis.title = element_text(size=12),
        axis.text = element_text(size=12))

# Pergunta 5
## Nomes mais populares de todos os tempos
dataset[which.max(dataset$n),]
# o nome mais comum de todos os tempos em um único ano foi "Linda"
# com 99.686 meninas recebendo este nome no ano de 1947.

## Nomes mais populares ao longo de todos os tempos

p5_name <- aggregate(n ~ name, dataset, sum)
p5_name_ord <- p5_name %>%                                      
  arrange(desc(n)) %>% 
  slice(1:10)
p5_name_ord
write_xlsx(p5_name_ord, 'p5_nomes_ordenados.xlsx',
           col_names = TRUE,
           format_headers = TRUE)

# Obeservamos que os nomes mais populares em numeros absolutos foram (em ordem):
# James, John, Robert, Michael, Mary e William

#calculando o número de nomes únicos entre M e F (em toda escala de tempo)
p5_nomes_unicos <- dataset
p5_nomes_unicos <- p5_nomes_unicos %>%
  group_by(sex) %>%
  summarise(count = n_distinct(name))
p5_nomes_unicos

## Nomes mais populares nos últimos 20 anos
#criando o subset do banco de daddos para os últimos 20 anos
p5_20years <- dataset[(dataset$year>="1998"),] #apagando as linhas com anos maiores do que 1997
summary (p5_20years)

#criando o maior valores de cada ano (por sexo)
top1_20years <- p5_20years %>%                                      
  arrange(desc(n)) %>% 
  group_by(year, sex) %>%
  slice(1:1)
top1_20years     

#criando uma coluna com a posição no ano
x<-rep(c(1),times=40)
top1_20years$position <- x 
top1_20years

#gerando o gráfico
ggplot(top1_20years, aes(x=year, y=position, fill = name)) + 
  geom_bar(stat = "identity", width=0.5)+
  ggtitle("Nomes mais comuns nos últimos 20 anos") +
  ylab("") +
  xlab("Ano") +
  theme(panel.background = element_rect(fill='transparent'),
        plot.title = element_text(size=14),
        axis.line = element_line(color="black", size = 0.8),
        axis.title = element_text(size=12),
        axis.text.x = element_text(angle = 90, size=12),
        axis.text.y = element_text(size=0))

# O gráfico indica quais nomes foram mais comuns para meninos e meninas
# nos últimos 20 anos

top_names_20years <- table (top1_20years$name)  
top_names_20years
top_names_20years <- as.data.frame(top_names_20years)
write_xlsx(top_names_20years, 'p5_topnames.xlsx',
           col_names = TRUE,
           format_headers = TRUE)
# podemos ver que nos últimos 20 anos os nomes mais comuns na maioria dos anos foram:
# Emily (para meninas) em 19 dos 20 anos estudados
# Jacob (para meninos) em 14 dos 20 anos estudados


### Insight pergunta 5 - Influências dos filmes da franquia Star Wars ao nomear filhos desde 
###                     os anos 1970.

## Frequência de nomes Luke
p5_Luke <- dataset[(dataset$name=="Luke"),] #apagando as linhas com nomes diferentes de Luke
p5_Luke <- p5_Luke[(p5_Luke$year>="1970"),] #apagando as linhas com anos menores do que 1970
p5_Luke <- p5_Luke[(p5_Luke$sex=="M"),] #apagando as linhas com Luke desigando a uma mulher
summary (p5_Luke)
head (p5_Luke)

#Gráfico (com valores absolutos dos nascimentos)
ggplot(data=p5_Luke, aes(x=year, y=n)) +
  geom_line() +
  ggtitle("Número crianças que receberam o nome Luke") +
  ylab("Número de nascimentos com nome Luke") +
  xlab("Ano") +
  geom_vline(xintercept=c(1977,1980, 1983, 1999, 2002, 2005, 2015, 2017), linetype="dotted")+
  theme(panel.background = element_rect(fill='transparent'),
        plot.title = element_text(size=14),
        axis.line = element_line(color="black", size = 0.8),
        axis.title = element_text(size=12),
        axis.text = element_text(size=12)
        )
#Linhas pontilhadas representam o lançamentos dos filmes da franquia Star Wars

## Apresentando a proporção de nomes Luke do total de nascimentos do ano
p5_Luke <- rename(p5_Luke, n_Luke = n)
p5_Luke_prop <- left_join(p5_Luke, p2)
x <- p5_Luke_prop$n_Luke/p5_Luke_prop$n*100
p5_Luke_prop$prop_Luke <- x
str(p5_Luke_prop)

#Gráfico (com valores proporcionais ao total de nascimentos do ano)
ggplot(data=p5_Luke_prop, aes(x=year, y=prop_Luke)) +
  geom_line(color = "blue") +
  ggtitle("Proporção de crianças que receberam o nome Luke") +
  ylab("Proporção de nascimentos com nome Luke (%)") +
  xlab("Ano") +
  geom_vline(xintercept=c(1977,1980, 1983, 1999, 2002, 2005, 2015, 2017), linetype="dotted")+
  theme(panel.background = element_rect(fill='transparent'),
        plot.title = element_text(size=14),
        axis.line = element_line(color="black", size = 0.8),
        axis.title = element_text(size=12),
        axis.text = element_text(size=12)
        )

## Frequência de nomes LEIA (valores absolutos)
p5_Leia <- dataset[(dataset$name=="Leia"),] #apagando as linhas com nomes diferentes de Luke
p5_Leia <- p5_Leia[(p5_Leia$year>="1970"),] #apagando as linhas com anos menores do que 1970
p5_Leia <- p5_Leia[(p5_Leia$sex=="F"),] #apagando as linhas com Luke desigando a uma mulher
summary (p5_Leia)
head (p5_Leia)

ggplot(data=p5_Leia, aes(x=year, y=n)) +
  geom_line() +
  ggtitle("Número crianças que receberam o nome Leia") +
  ylab("Número de nascimentos com nome Leia") +
  xlab("Ano") +
  geom_vline(xintercept=c(1977,1980, 1983, 1999, 2002, 2005, 2015, 2017), linetype="dotted")+
  theme(panel.background = element_rect(fill='transparent'),
        plot.title = element_text(size=14),
        axis.line = element_line(color="black", size = 0.8),
        axis.title = element_text(size=12),
        axis.text = element_text(size=12)
  )
#Linhas pontilhadas representam o lançamentos dos filmes da franquia Star Wars

## Apresentando a proporção de nomes Leia do total de nascimentos do ano
p5_Leia <- rename(p5_Leia, n_Leia = n)
p5_Leia_prop <- left_join(p5_Leia, p2)
x <- p5_Leia_prop$n_Leia/p5_Leia_prop$n*100
p5_Leia_prop$prop_Leia <- x
str(p5_Leia_prop)

ggplot(data=p5_Leia_prop, aes(x=year, y=prop_Leia)) +
  geom_line(color = "red") +
  ggtitle("Proporção de crianças que receberam o nome Leia") +
  ylab("Proporção de nascimentos com nome Leia (%)") +
  xlab("Ano") +
  geom_vline(xintercept=c(1977,1980, 1983, 1999, 2002, 2005, 2015, 2017), linetype="dotted")+
  theme(panel.background = element_rect(fill='transparent'),
        plot.title = element_text(size=14),
        axis.line = element_line(color="black", size = 0.8),
        axis.title = element_text(size=12),
        axis.text = element_text(size=12)
  )


## Colocando os dois gráficos juntos 

ggplot() +
  geom_line(data=p5_Leia_prop, aes(x=year, y=n_Leia), color = "Red") +
  geom_line(data=p5_Luke_prop, aes(x=year, y=n_Luke), color="Blue") +
  scale_y_sqrt() +      #foi usado uma tranformação do eixo Y para melhor visualização dos resultados
  ggtitle("Numero de crianças que receberam o nomes Luke e Leia") +
  ylab("Número de nascimentos com nome Luke/Leia (RQ)") +
  xlab("Ano") +
  geom_vline(xintercept=c(1977,1980, 1983, 1999, 2002, 2005, 2015, 2017), linetype="dotted")+
  theme(panel.background = element_rect(fill='transparent'),
        plot.title = element_text(size=14),
        axis.line = element_line(color="black", size = 0.8),
        axis.title = element_text(size=12),
        axis.text = element_text(size=12)
  )

