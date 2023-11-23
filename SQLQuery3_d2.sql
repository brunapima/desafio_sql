-- Importando o arquivo em CSV para uma tabela temporária
BULK INSERT #SalesTemp
FROM 'C:\Users\brupi\Downloads\DB_Teste.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\your\path\to\your\errorfile.csv',
    TABLOCK
)

-- Tratando e importando os dados da tabela temporária para a tabela final
INSERT INTO SalesHistory
(
    [Tipo],
    [ClienteID],
    [VendedorID],
    [Month],
    [Year],
    [Result]
)
SELECT
    [VendaID],
    [ClienteID],
    [VendedorID],
    LEFT([Month], 3) + '-' + RIGHT([Month], 4),
    [Year],
    CAST([Result] AS DECIMAL(10, 2))
FROM #SalesTemp
WHERE [Result] IS NOT NULL AND [Result] <> ''

-- Listar todas as vendas (ID) e seus respectivos clientes apenas no ano de 2020
SELECT
    [VendaID],
    [ClienteID]
FROM
    SalesHistory
WHERE
    [Year] = 2020

-- Listar a equipe de cada vendedor
SELECT
    [VendedorID],
    COUNT(*) AS [TeamSize]
FROM
    SalesHistory
GROUP BY
    [VendedorID]

-- Construir uma tabela que avalia trimestralmente o resultado de vendas e plote um gráfico deste histórico.
SELECT 
    [Year], 
    AVG([Result]) OVER (ORDER BY [Year]) AS [AverageSales]
FROM 
    SalesHistory
ORDER BY 
    [Year]

-- Plote do gráfico
SELECT
    [Year],
    [Result]
FROM
    SalesHistory
ORDER BY
    [Year]