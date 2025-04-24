## Case de Analise de dados com base de vendas:
KPI's: CLTV e Churn e a importância das Analises de Cliente.
 
## Período analisado 12 meses.

## Desafios:
ETL e Tratamento de Dados
Datas em diversos formatos/tipos.
Valores númericos como varchar, inteiros como float, e outros.
Nulos e Strings de NaN

## Cálculo de Métricas no SQL(melhorando a performance):
Visitas; 
Vida Útil; 
Status Ativo/Inativo(Regra de negócio: última compra < 3 meses);
Taxa de Churn(Inativos fim do periodo / Total Clientes inicio do periodo); 
Ticket Médio; 
Frequência Mensal; 
CLTV(TKM * FREQUENCIA_MENSAL * VIDA_UTIL_MESES *MARGEM); 
Gasto Médio Mensal; 

## Usabilidade dos Indicadores:
Indicador: CLTV, Objetivo: Projeção de valor futuro por cliente	Definir 
Indicador: TKM, Objetivo: Poder de compra médio por compra	
Indicador: Frequência Média Mensal, Objetivo: Consistência de compra ao longo do tempo	
Indicador: Vida Útil, Objetivo: Maturidade do relacionamento	
Indicador: Visitas, Objetivo: Engajamento efetivo (dias com compras)
Indicador: Churn Rate, Objetivo: Saúde da base de clientes (global).
Indicador: Gasto Médio Mensal, Objetivo: Contribuição média mensal do cliente
Indicador: Status Ativo, Objetivo: Identificação de clientes em risco de churn (>3 meses sem compra)

## Tomadas de decisão referente a análise: 
Focar em clientes com vida útil > 6 meses e CLTV alto, reduzindo churn.
Enviar e-mails antes de completar 3 meses sem compra (status “Inativo” iminente).
Segmentar clientes com TKM elevado, mas baixa frequência.
Calibrar CAC vs CLTV médio para avaliar ROI de canais de aquisição.
Testar percentuais de desconto em grupos com gasto médio mensal baixo para elevar ticket.

## Algumas análises também cabem, como, calcular quanto de retorno teríamos aumentando a margem em alguns P.P, multiplicando pelo LTV, calcular perdas devidas a churn no período de 12 meses futuros e como evitar.

## Conclusão: ##
Com este dashboard e as métricas implementadas, a equipe de Marketing/CRM ganha um ferramental robusto para entender o valor de cada cliente ao longo do tempo, antecipar riscos e otimizar alocação de budget. A combinação de insights quantitativos e segmentação dinâmica permite ações de marketing com maior acerto, retenção e maximização do ROI nas iniciativas de CRM. 

## Resumo do Dashboard em sí: ##
O dashboard oferece uma visão 360° sobre o comportamento do cliente, combinando métricas de engajamento (visitas, frequência), valor transacional (receita total, ticket médio e gasto mensal), ciclo de vida (vida útil e status ativo/inativo) e projeção de valor (CLTV). Através dele, a área de Marketing/CRM pode identificar grupos de clientes de maior valor, antecipar risco de churn e direcionar ações de retenção ou reativação de forma segmentada e eficiente.
