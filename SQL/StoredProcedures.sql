--Kwabena Agyei-Boahene --
-- STORED PROCEDURES--


USE AdventureWorks2012
GO



CREATE or alter proc processRow		
	 @currentRows int
	,@tableName varchar(30)
	,@percentage int
	,@changedTables int out

AS
BEGIN




SET @changedTables = 0;
declare @sql varchar(100);


	if (exists (select top 1 *
			FROM AdventureWorks2012.dbo.tableStatus 
			WHERE tableName = @tableName 
			ORDER BY checkDate DESC))


		SET @changedTables = @changedTables + 1;
		declare @checksql varchar(100);


		SET @checksql = 'select numberOfRows from tableStatus where tableName = ' + @tableName + ';';
		declare @previousRows int;
		exec @checksql = @previousRows;

		declare @rowChange int;
		SELECT @rowChange = (@currentRows * 100 / @previousRows) - 100
		
		declare @growth int;
		
		SET @growth =
		CASE 
			WHEN @rowChange = @percentage THEN '0'
			WHEN @rowChange <= @percentage THEN '-1'
			WHEN @rowChange >= @percentage THEN '1'
		END
			
		SET @sql = ' insert into AdventureWorks2012.dbo.tableStatus(tableName, numberOfRows, rateCheckValue, fastGrowth )
		values (' + @tableName + ', ' + @currentRows + ' , '+ @percentage + ' , ' + @growth + ');';
		execute(@sql);


	
	SET @sql = ' INSERT tableStatus(tableName, numberOfRows, rateCheckValue) VALUES (''' + @tableName + ''', ' + @currentRows + ', ' + @percentage + ');';
	execute (@sql)
END
GO

CREATE or alter proc dbStats
@percentage int, 
@changedTables int output
AS
BEGIN


if not exists(select 1 from sys.tables where name ='tableStatus')
BEGIN
	create table tableStatus(
	tableName varchar(300) not null
	, checkDate datetime DEFAULT getdate()
	, numberOfRows varchar(10)
	, rateCheckValue int default null
	, fastGrowth varchar(1) default null
	, primary key (tableName, checkDate)
	); 
END

if object_id('tempdb..##tempTable') is null
BEGIN
	create table tempTable (
		tableNumber int IDENTITY(1,1)
		,tableName	varchar(100)
	);



	insert into tempTable
	select table_schema + '.' + table_name AS [table] 
	FROM AdventureWorks2012.INFORMATION_SCHEMA.tables 
	WHERE table_type = 'BASE TABLE';
END



DECLARE @LoopMax int
DECLARE @SQL varchar(200)
declare @checksql varchar(200);
DECLARE @tableName varchar(100)
DECLARE @counter int;
DECLARE @rowCount int;

SELECT @LoopMax = COUNT(1) 
FROM tempTable

SELECT @counter = 1
WHILE @counter < @LoopMax
BEGIN
	SELECT @tableName = [tableName] 
	FROM tempTable 
	WHERE @counter = tableNumber

	SELECT @sql = ' Select @rowCount = count(1) from ' + @tableName + ';'
	EXEC @checksql = @rowCount
	EXEC @changedTables = processRow @rowCount, @tableName, @percentage;
	SELECT @counter = @counter + 1
END



-- QUESTION 3....GROWTH CHANGE--
select tableName, count(fastGrowth) AS [occurences] 
FROM tableStatus 
GROUP BY tableName 
HAVING count(fastGrowth) > 0

END
GO


CREATE or alter proc test
AS
BEGIN

BEGIN transaction


DECLARE	@return_value int
DECLARE	@changedTables int
drop table Sales.SalesTaxRate;

EXEC	@return_value = [dbo].[dbStats]
		@percentage =10

SELECT	'Return Value' = @return_value


EXEC	@return_value = [dbo].[processRow]
		@currentRows =150,
		@tableName = N'Sales.SalesOrderHeader',
		@percentage =30,
		@changedTables = @changedTables OUTPUT

SELECT	@changedTables as N'@changedTables'
SELECT	'Return Value' = @return_value
ROLLBACK;
END

EXEC dbo.test