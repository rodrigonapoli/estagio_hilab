---
output:
  html_document: default
---
# Teste estágio análise de dados
O teste consiste em juntar uma base de dados com nomes de bebês registrados nos Estados Unidos quebrada igualmente em 3 diferentes formatos de arquivos utilizando R ou Python e responder algumas perguntas. O objetivo é avaliar a sua capacidade de extrair dados de diferentes fontes e sua capacidade analítica e de interpretação utilizando as ferramentas disponíveis na linguagem de programação escolhida.

## O dataset
Como citado anteriormente o dataset está quebrado em 3 partes que devem ser juntadas em uma só para a realização das análises. Cada linha representa um nome diferente em um ano específico.
 **IMPORTANTE: Na parte 3 devem ser filtrados somente os dados que possuem valor 1 na coluna tipo_dado**

* parte1.json
* parte2.csv
* parte3.sqlite: não esquecer de filtrar tipo_dado = 1

### Colunas

|Variável |Class     |Descrição |
|:--------|:---------|:-----------|
|year     |double    | Ano de nascimento |
|sex      |character | Sexo do bebê |
|name     |character | Nome do bebê |
|n        |integer   | Contagem de bebês |
|prop     |double    | Proporção do total de nascimentos daquele ano  |


## Perguntas
1- Quantos nomes diferentes existem por ano a partir de 2000? Forneça uma tabela
e demonstre os resultados graficamente.

2- Qual a média e a mediana da contagem de bebês no dataset. Qual dessas medidas
de tendência central você escolheria para descrever esse dado, justifique sua opção.

3- Qual a média e desvio padrão da contagem de bebês no ano de 1997?

4- Levando em conta que o dataset engloba o nascimento de todos os bebês do país 
imaginário Hilablândia. Qual o total de nascimentos no ano de 2002? Desses, 
quantos são do sexo feminino e quantos do sexo masculino?

5 (Opcional)- Use sua criatividade para explorar a base e tentar retirar algum 
insight como por exemplo variação dos nomes Luke e Leia de acordo com lançamento 
dos filmes da série Star Wars.

6- Envie os côdigos com os resultados por e-mail ou sinta-se a vontade para criar
um repositório git (lembre-se de torná-lo público e compartilhar o link!!)

![](https://github.com/clauciorank/TidyTuesday/blob/main/2022-03-22/R/image.png?raw=true)
