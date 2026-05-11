DECLARE @SearchText NVARCHAR(100)
SET @SearchText = 'AKSHA'   -- Yaha apni value likho

DECLARE @TableName NVARCHAR(256)
DECLARE @ColumnName NVARCHAR(256)
DECLARE @SQL NVARCHAR(MAX)

DECLARE TableCursor CURSOR FOR
SELECT t.name, c.name
FROM sys.tables t
INNER JOIN sys.columns c ON t.object_id = c.object_id
INNER JOIN sys.types ty ON c.user_type_id = ty.user_type_id
WHERE ty.name IN ('varchar','nvarchar','char','nchar','text','ntext')

OPEN TableCursor
FETCH NEXT FROM TableCursor INTO @TableName, @ColumnName

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = '
    IF EXISTS (
        SELECT 1 FROM [' + @TableName + '] 
        WHERE [' + @ColumnName + '] LIKE ''%' + @SearchText + '%''
    )
    PRINT ''Found in Table: ' + @TableName + ' Column: ' + @ColumnName + ''''

    EXEC (@SQL)

    FETCH NEXT FROM TableCursor INTO @TableName, @ColumnName
END

CLOSE TableCursor
DEALLOCATE TableCursor