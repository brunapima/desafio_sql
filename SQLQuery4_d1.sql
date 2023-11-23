-- Criando a tabela de vendas
-- Construa o modelo de relacionamento com as categorias utilizadas em todos os campos do arquivo CSV
CREATE TABLE Sales
(
    [VendedorID] INT PRIMARY KEY,
    [ClienteID] CHAR(10),
    [Tipo] CHAR,
    [Data_da_venda] CHAR,
    [Categoria] CHAR,
    [Regional] CHAR,
    [Meses_contrato] INT,
    [Time] CHAR,
    [Valor] CHAR
)

-- Importando o arquivo em CSV para uma tabela temporária
BULK INSERT #DB_Teste
FROM 'C:\Users\brupi\Downloads\DB_Teste.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\your\path\to\your\errorfile.csv',
    TABLOCK
)

-- Tratando e importando os dados da tabela temporária para a tabela final
INSERT INTO Sales
(
    [VendedorID],
    [ClienteID],
    [Tipo],
    [Data_da_venda],
    [Categoria],
    [Regional],
	[Venda],
    [Meses_contrato],
    [Time],
    [Valor]
)
SELECT
    [VendedorID],
    [ClienteID],
    [Tipo],
    [Data_da_venda],
    [Categoria],
    [Regional],
	[Venda],
    [Meses_contrato],
    [Time],
    [Valor]
FROM #SalesTemp
WHERE [Valor] IS NOT NULL AND [Valor] <> ''

-- Listar todas as vendas (ID) e seus respectivos clientes
SELECT
    [Venda],
    [ClienteID]
FROM
    Sales

-- Listar a equipe de cada vendedor
SELECT
    [VendedorID],
    COUNT(*) AS [TeamSize]
FROM
    Sales
GROUP BY
    [VendedorID]