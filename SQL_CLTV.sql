DECLARE @DATA_INICIO DATE;
SET @DATA_INICIO = CAST(DATEADD(MONTH, -12, '2011-12-09 12:50:00.000') AS DATE);
DECLARE @DATA_FIM DATE;
SET @DATA_FIM = CAST('2011-12-09 12:50:00.000' AS DATE);


WITH
    VISITAS AS (

        SELECT
            A.CustomerID AS ID_CLIENTE,
            COUNT(DISTINCT CAST(A.InvoiceDate_NEW AS DATE)) AS VISITAS  -- Considerando InvoiceNo como transação única

        FROM 
			[STAGE_STUDY].[STAGE_STUDY].[clientes] A

        GROUP BY
            A.CustomerID
    ),
    
    ATIVOS_INATIVOS AS (
        
        SELECT 
            CustomerID,
            MAX(CAST(InvoiceDate_New AS DATETIME)) AS ULTIMA_COMPRA,
            CASE 
                WHEN DATEDIFF(
                    MONTH, 
                    MAX(CAST(InvoiceDate_New AS DATETIME)), 
                    CONVERT(DATETIME, '20110909', 112)
                ) < 3 THEN 'Ativo'
                ELSE 'Inativo'
            END AS STATUS_CLIENTE

        FROM 
			[STAGE_STUDY].[STAGE_STUDY].[clientes] 

        GROUP BY 
			CustomerID
    ),
    
    VIDA_UTIL AS (
        SELECT
            CustomerID,
            DATEDIFF(
                MONTH, 
                MIN(CAST(InvoiceDate_New AS DATE)), 
                MAX(CAST(InvoiceDate_New AS DATE))
            ) AS VIDA_UTIL_MESES

        FROM 
			[STAGE_STUDY].[STAGE_STUDY].[clientes]

        GROUP BY 
			CustomerID
    ),
    
    CHURN AS (
        
        SELECT
            COUNT(CASE WHEN STATUS_CLIENTE = 'Inativo' THEN 1 END) * 1.0 / COUNT(*) AS TAXA_CHURN

        FROM 
			ATIVOS_INATIVOS
    ),
    
    METRICAS_CLTV AS (
       
        SELECT
            c.CustomerID																															AS ID_CLIENTE, 
			ROUND(
				SUM(
					CAST(c.Quantity AS float)
					) 
					* 
				SUM(
					CAST(c.UnitPrice  AS float)
					)
			,2)																																		AS RECEITA_TOTAL,
            COUNT(DISTINCT c.InvoiceNo)																												AS TOTAL_COMPRAS, 
            VIDA_UTIL_MESES																															AS VIDA_UTIL_MESES,
            SUM(
				CAST(c.Quantity AS FLOAT) 
				* 
				CAST(c.UnitPrice AS FLOAT)
			) / 
			COUNT(DISTINCT c.InvoiceNo)																												AS TKM,
            CAST(ROUND((COUNT(DISTINCT CAST(c.InvoiceDate_New AS DATE)) * 1.0 / DATEDIFF(MONTH, CAST(MIN(c.InvoiceDate_New) AS DATE), @DATA_FIM)),2) As decimal(6,2))	AS FREQUENCIA_MENSAL

        FROM 
			[STAGE_STUDY].[STAGE_STUDY].[clientes] c
        CROSS JOIN 
			CHURN ch  
        LEFT JOIN 
			VIDA_UTIL vu ON c.CustomerID = vu.CustomerID

		LEFT JOIN
			VISITAS vs ON VS.ID_CLIENTE = C.CustomerID

		WHERE vs.VISITAS > 1

        GROUP BY 
			c.CustomerID, 
			ch.TAXA_CHURN, 
			vu.VIDA_UTIL_MESES

		HAVING SUM(CAST(c.Quantity AS FLOAT) * CAST(c.UnitPrice AS FLOAT)) > 0.01

    )

SELECT 
	ID_CLIENTE, 
	(TKM * FREQUENCIA_MENSAL * VIDA_UTIL_MESES * 0.28) AS CLTV,
	 (RECEITA_TOTAL / CASE WHEN VIDA_UTIL_MESES = 0 THEN 1 ELSE VIDA_UTIL_MESES END) GASTO_MEDIO_MENSAL,
	*

FROM 
	METRICAS_CLTV

where ID_CLIENTE <> 'nan'

ORDER BY 2 DESC
