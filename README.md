# Linguagens Formais - TAES CIn-UFPE
Repositório para amostragem do projeto de Especificações Formais do ciclo de Engenharia de Software. 
Disciplina de Tópicos Avançados em  Engenharia de Software. Ministrado pelo professor Augusto Cezar Alves Sampaio.

## Tema: Avaliação Empírica de LLMs Generalistas vs. Especializados na Síntese de Especificações Formais em Alloy

> **Projeto de Tópicos Avançados em Engenharia de Software**
>
> *Uma análise comparativa entre abordagens Generalistas (Zero-Shot) e Especialistas (In-Context Learning) na desmistificação de código formal.*

![Python](https://img.shields.io/badge/Python-3.10+-blue.svg)
![Colab](https://img.shields.io/badge/Google-Colab-orange.svg)
![OpenAI](https://img.shields.io/badge/LLM-GPT--4o-green.svg)
![Alloy](https://img.shields.io/badge/Formal-Alloy_6-purple.svg)

---

##  Objetivo do Projeto

Métodos Formais, especificamente a linguagem **Alloy**, são ferramentas poderosas para garantir a corretude de sistemas críticos e modelagem de software. No entanto, sua sintaxe matemática e lógica cria uma **"Lacuna Semântica"** (*Semantic Gap*) que dificulta a compreensão por *stakeholders* não técnicos (gerentes, clientes, analistas de negócio).

Este projeto investiga se **Grandes Modelos de Linguagem (LLMs)** podem atuar como "tradutores técnicos", convertendo especificações Alloy (`.als`) em linguagem natural (Português do Brasil) acessível.

O foco central é comparar se a **Engenharia de Prompt** (*Prompt Engineering*) melhora significativamente a **clareza**, **didática** e **precisão técnica** das explicações geradas.

---

## Metodologia Experimental

O experimento compara duas configurações distintas utilizando o mesmo modelo base (**GPT-4o**), isolando a variável "Estratégia de Prompt":

### 1. O Agente Generalista (Baseline)
* **Estratégia:** *Zero-Shot Learning*.
* **Prompt:** Simples e direto, instruindo apenas a explicar o código em português para um leigo.
* **Hipótese:** Tende a ser literal na tradução, muitas vezes mantendo termos de código (ex: "A assinatura Aluno...") em vez de conceitos de negócio.

### 2. O Agente Especialista (Challenger)
* **Estratégia:** *System Prompting* + *Role Playing* (In-Context Learning).
* **Prompt:** Injeção de uma "Persona" (Analista Sênior de Requisitos) com um manual de tradução explícito injetado no contexto do sistema.
    * *Regra Injetada:* `'sig' -> Entidade`
    * *Regra Injetada:* `'fact' -> Regra de Negócio`
    * *Diretriz:* Usar estrutura de tópicos e resumo executivo.
* **Hipótese:** Produzirá textos mais estruturados, focados no domínio do problema e com menos "ruído" de sintaxe.

---

## O Dataset (Software Abstractions)

Utilizamos exemplos clássicos do repositório oficial do livro *Software Abstractions* (Daniel Jackson, MIT) para garantir a validade técnica dos testes.

| Arquivo | Dificuldade | Conceito Testado |
| :--- | :--- | :--- |
| `addressBook.als` | 🟢 Fácil | Operações de conjunto e mapeamento simples. |
| `properties.als` | 🟡 Médio | Propriedades matemáticas de relações (transitiva, injetora, sobrejetora) e verificação de axiomas. |
| `filesystem.als` | 🟡 Médio | Hierarquias, recursividade e fechamento transitivo (`^`). |
| `grandpa2.als` | 🔴 Difícil | **O Paradoxo da Genealogia**. Teste de viés semântico (a IA percebe que o código permite ser avô de si mesmo?). |
| `ringElection2.als` | 🔴 Difícil | Algoritmos distribuídos em anel e ordenação temporal. |

---

## Métricas de Avaliação

Para evitar subjetividade, o projeto implementou um pipeline de avaliação automatizada em Python:

1.  **Índice de Leiturabilidade Flesch (Adaptado para PT-BR):**
    * Implementação manual da fórmula de Martins & Forghieri, calibrada para a estrutura silábica do Português.
    * Mede quão fácil é ler o texto gerado (Escala 0-100).
2.  **Score de Negócio (Business Score):**
    * Contagem de frequência de termos que indicam abstração e foco no problema (ex: "regra", "sistema", "garantia", "usuário").
3.  **Penalidade de Jargão (Tech Penalty):**
    * Contagem de termos de código que "vazaram" para a explicação (ex: "sig", "abstract", "extends", "univ").
4.  **Latência:** Tempo de resposta da inferência em segundos.

---

## Tecnologias Utilizadas

* **Google Colab:** Ambiente de execução e integração com Google Drive para carga de datasets.
* **OpenAI API (GPT-4o):** Motor de inferência principal.
* **Pandas:** Manipulação de dados e geração de relatórios comparativos (Excel/CSV).
* **TextStat / Regex:** Análise léxica e cálculo de métricas de texto.
* **Glob/OS:** Automação de leitura de arquivos em lote.

---

## Como Executar o Projeto

1.  **Clone este repositório** ou abra o notebook (`.ipynb`) no Google Colab.
2.  **Instale as dependências necessárias:**
    ```python
    !pip install -q -U google-generativeai openai anthropic textstat
    ```
3.  **Configure as Chaves de API:**
    * O código utiliza `google.colab.userdata` para segurança.
    * Adicione sua chave no menu "Secrets" (ícone de chave) do Colab com o nome `OPENAI_API_KEY`.
4.  **Carregue o Dataset:**
    * Tenha uma pasta no seu Google Drive com os arquivos `.als`.
    * Ajuste a variável `CAMINHO_PASTA` na célula de importação do notebook para apontar para sua pasta.
5.  **Execute o Pipeline:**
    * O script irá iterar sobre os arquivos, gerar as explicações com os dois agentes, calcular as métricas e exportar um arquivo `Resultado_Final_Metricas.xlsx`.

---

## Resultados Preliminares e Discussão

* **Clareza vs Estrutura:** O modelo **Generalista** tende a ter um índice Flesch maior (texto mais fluido/simples), enquanto o **Especialista** pontua mais baixo na facilidade de leitura devido ao uso de listas estruturadas e *bullet points*.
* **Interpretação:** Embora o Generalista seja "mais fácil de ler" estatisticamente, o Especialista demonstra maior precisão conceitual ao substituir jargões de código (`extends`, `sig`) por conceitos de domínio (`é um tipo de`, `entidade`).
* **Conclusão:** A engenharia de prompt (System Prompting) atua efetivamente como um filtro de abstração, tornando o output da IA mais adequado para validação de requisitos com clientes.

---

## Autores

Projeto desenvolvido para a disciplina de **Tópicos Avançados em Engenharia de Software**.

* **Grupo 1**

---

> *"A IA não substitui a Engenharia Formal, mas pode ser a ponte que faltava para torná-la acessível."*
